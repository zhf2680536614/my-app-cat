// 网络请求工具类（Dio封装）
import 'package:dio/dio.dart';
import 'package:my_app_cat/config/service/base_url.dart' show apiDevBaseUrl;
import 'package:my_app_cat/utils/flutter_toast_util.dart';
import 'package:my_app_cat/utils/log_util.dart' show LogUtil;

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;

  // Dio实例（静态变量）
  late Dio dio;

  // 需要加token的接口路径集合
  final List<String> _tokenRequiredPaths = [
    // 用户相关接口
    '/cat',
  ];

  HttpUtil._internal() {
    // 基础配置
    BaseOptions options = BaseOptions(
      baseUrl: apiDevBaseUrl, // 根据环境切换（开发/测试/生产）
      // 超时时间（60秒）
      connectTimeout: Duration(seconds: 10),
      // 接收超时时间（60秒）
      receiveTimeout: Duration(seconds: 10),
      // 响应数据类型（JSON）
      responseType: ResponseType.json,
    );
    dio = Dio(options);

    // 拦截器：请求/响应/错误
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 根据接口路径决定是否添加Token
          if (_isTokenRequired(options.path)) {
            // 实际项目中应该从本地存储或状态管理中获取token
            final token = _getToken();
            LogUtil.d('获取到的Token: $token');
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
              LogUtil.d('为接口 ${options.path} 添加了认证Token');
            } else {
              FlutterToastUtils.showErrorToast("请先登录");
              LogUtil.e('接口 ${options.path} 需要Token但未获取到');
              // 确保正确拒绝请求
              final error = DioException(
                requestOptions: options,
                message: '请先登录',
                type: DioExceptionType.cancel,
              );
              handler.reject(error);
              return;
            }
          }
          // 记录请求信息
          _logRequest(options);
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // 记录响应信息
          _logResponse(response);

          // 检查HTTP状态码是否为200
          if (response.statusCode != 200) {
            String statusErrorMsg =
                'HTTP错误 - 状态码: ${response.statusCode}, 状态描述: ${response.statusMessage}';
            LogUtil.e(statusErrorMsg);
            throw DioException(
              requestOptions: response.requestOptions,
              response: response,
              message: statusErrorMsg,
              type: DioExceptionType.badResponse,
            );
          }

          // 统一解析响应（格式：{code: 0, data: {}, msg: ""}）
          if (response.data['code'] != 0) {
            String errorMsg = response.data['msg'] ?? '未知业务错误';
            FlutterToastUtils.showErrorToast(errorMsg);
            LogUtil.e('业务错误: $errorMsg');
            throw DioException(
              requestOptions: response.requestOptions,
              response: response,
              message: errorMsg,
              type: DioExceptionType.badResponse,
            );
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // 详细记录所有类型的错误
          String errorType = _logError(e);
          FlutterToastUtils.showErrorToast(errorType);
          return handler.next(e);
        },
      ),
    );
  }

  // 记录请求信息
  void _logRequest(RequestOptions options) {
    String requestLog =
        '''
        [HTTP请求] ======= 开始 =======
        URL: ${options.baseUrl}${options.path}
        方法: ${options.method}
        请求头: ${options.headers}
        查询参数: ${options.queryParameters}
        请求体: ${options.data}
        [HTTP请求] ======= 结束 =======''';

    LogUtil.d(requestLog);
  }

  // 记录响应信息
  void _logResponse(Response response) {
    String responseLog =
        '''
        [HTTP响应] ======= 开始 =======
        URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}
        状态码: ${response.statusCode}
        响应头: ${response.headers}
        响应体: ${response.data}
        响应时间: ${response.headers.value('X-Response-Time') ?? '未知'}
        [HTTP响应] ======= 结束 =======''';

    LogUtil.d(responseLog);
  }

  // 获取Token（实际项目中应该从本地存储或状态管理中获取）
  String? _getToken() {
    // 这里只是示例，实际应该从SharedPreferences、Hive或状态管理中获取
    // 例如：return await SharedPreferences.getInstance().then((prefs) => prefs.getString('token'));
    return 'ABCD'; // 示例token
  }

  // 判断接口是否需要Token
  bool _isTokenRequired(String path) {
    // 精确匹配
    if (_tokenRequiredPaths.contains(path)) {
      return true;
    }

    // 前缀匹配（处理带参数的路径，如 /orders/123/detail）
    for (var requiredPath in _tokenRequiredPaths) {
      if (path.startsWith('$requiredPath/') || path == requiredPath) {
        return true;
      }
    }

    return false;
  }

  // 详细记录错误信息
  String _logError(DioException e) {
    String errorType = '';
    switch (e.type) {
      case DioExceptionType.cancel:
        errorType = '请求取消';
        break;
      case DioExceptionType.connectionTimeout:
        errorType = '连接超时';
        break;
      case DioExceptionType.sendTimeout:
        errorType = '发送超时';
        break;
      case DioExceptionType.receiveTimeout:
        errorType = '接收超时';
        break;
      case DioExceptionType.badResponse:
        errorType = '服务器错误';
        break;
      case DioExceptionType.badCertificate:
        errorType = '证书错误';
        break;
      case DioExceptionType.connectionError:
        errorType = '网络连接错误';
        break;
      case DioExceptionType.unknown:
        errorType = '未知错误';
        break;
    }

    String errorLog =
        '''
        [HTTP错误] ======= 开始 =======
        错误类型: $errorType
        错误信息: ${e.message}
        URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}
        请求方法: ${e.requestOptions.method}
        状态码: ${e.response?.statusCode ?? 'N/A'}
        响应数据: ${e.response?.data ?? 'N/A'}
        错误栈: ${e.stackTrace}
        [HTTP错误] ======= 结束 =======''';

    LogUtil.e(errorLog);

    return errorType;
  }

  // GET请求封装
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? params,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: params);
      final rowData = response.data['data'];
      if (rowData is Map<String, dynamic>) {
        return fromJson(rowData);
      }
      return rowData as T;
    } on DioException catch (e) {
      // 已在拦截器中记录，这里可以根据需要进行额外处理
      rethrow; // 抛出错误，由调用方处理
    } catch (e) {
      // 捕获非Dio异常（如解析错误等）
      String unknownErrorLog =
          '''
          [HTTP未知错误] ======= 开始 =======
          错误类型: ${e.runtimeType}
          错误信息: $e
          错误栈: ${StackTrace.current}
          [HTTP未知错误] ======= 结束 =======''';
      LogUtil.e(unknownErrorLog);
      rethrow;
    }
  }

  // GET请求封装（返回List<T>）
  Future<List<T>> getList<T>(
    String path, {
    Map<String, dynamic>? params,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: params);
      final rawList = response.data['data'] as List; // 接口返回的`data`是List

      // 将列表中每个元素转为T类型（要求T有fromJson方法）
      return rawList
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList()
          .cast<T>();
    } on DioException catch (e) {
      rethrow;
    } catch (e, stack) {
      String errorLog =
          '''
    [HTTP列表解析错误] ======= 开始 =======
    接口路径: $path
    请求参数: $params
    错误类型: ${e.runtimeType}
    错误信息: $e
    错误栈: $stack
    [HTTP列表解析错误] ======= 结束 =======''';
      LogUtil.e(errorLog);
      rethrow;
    }
  }

  // POST请求封装
  Future<T> post<T>(
    String path, {
    required T data,
    required Map<String, dynamic> Function(T) toJson,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await dio.post(path, data: toJson(data));
      return fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      // 已在拦截器中记录，这里可以根据需要进行额外处理
      rethrow;
    } catch (e) {
      // 捕获非Dio异常（如解析错误等）
      String unknownErrorLog =
          '''
          [HTTP未知错误] ======= 开始 =======
          错误类型: ${e.runtimeType}
          错误信息: $e
          错误栈: ${StackTrace.current}
          [HTTP未知错误] ======= 结束 =======''';
      LogUtil.e(unknownErrorLog);
      rethrow;
    }
  }

  // DELETE请求封装
  Future<T> delete<T>(String path, {Map<String, dynamic>? params}) async {
    try {
      final response = await dio.delete(path, queryParameters: params);
      return response.data['data'] as T;
    } on DioException catch (e) {
      // 已在拦截器中记录，这里可以根据需要进行额外处理
      rethrow;
    } catch (e) {
      // 捕获非Dio异常（如解析错误等）
      String unknownErrorLog =
          '''
          [HTTP未知错误] ======= 开始 =======
          错误类型: ${e.runtimeType}
          错误信息: $e
          错误栈: ${StackTrace.current}
          [HTTP未知错误] ======= 结束 =======''';
      LogUtil.e(unknownErrorLog);
      rethrow;
    }
  }

  // PUT请求封装
  Future<T> put<T>(
    String path, {
    required T data,
    required Map<String, dynamic> Function(T) toJson,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: toJson(data),
        queryParameters: params,
      );
      return fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      // 已在拦截器中记录，这里可以根据需要进行额外处理
      rethrow;
    } catch (e) {
      // 捕获非Dio异常（如解析错误等）
      String unknownErrorLog =
          '''
          [HTTP未知错误] ======= 开始 =======
          错误类型: ${e.runtimeType}
          错误信息: $e
          错误栈: ${StackTrace.current}
          [HTTP未知错误] ======= 结束 =======''';
      LogUtil.e(unknownErrorLog);
      rethrow;
    }
  }
}
