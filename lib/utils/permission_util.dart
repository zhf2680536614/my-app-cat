// 权限工具类
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cat/utils/flutter_toast_util.dart'; // 引入您已有的toast工具类
import 'log_util.dart'; // 引入日志工具类

/// 权限管理工具类
class PermissionUtil {
  /// 权限请求状态标志，用于防止并发请求
  static bool _isLocationPermissionRequesting = false;

  /// 请求位置权限
  static Future<bool> requestLocationPermission(BuildContext context) async {
    // 检查是否已有权限请求正在进行中
    if (_isLocationPermissionRequesting) {
      LogUtil.d('已有位置权限请求正在进行中，跳过此次请求');
      return false;
    }

    try {
      // 设置请求状态为进行中
      _isLocationPermissionRequesting = true;

      // 检查位置权限状态
      var status = await Permission.location.status;
      LogUtil.d('当前位置权限状态: $status');

      // 情况1：权限被永久拒绝
      if (status.isPermanentlyDenied) {
        LogUtil.d('位置权限被永久拒绝，显示设置跳转提示');
        if (context.mounted) {
          await handlePermanentlyDeniedPermission(context, '位置权限');
        }
        return false;
      }

      // 情况2：检查是否为"始终允许"权限（在Android上是Permission.locationAlways，在iOS上是特定状态）
      bool isAlwaysGranted = false;
      
      // Android平台的始终允许权限检查
      if (defaultTargetPlatform == TargetPlatform.android) {
        var alwaysStatus = await Permission.locationAlways.status;
        isAlwaysGranted = alwaysStatus.isGranted;
        LogUtil.d('Android平台始终允许权限状态: $isAlwaysGranted');
      }
      // iOS平台的检查，需要通过status的具体值来判断
      else if (defaultTargetPlatform == TargetPlatform.iOS) {
        // 对于iOS，我们需要检查更具体的状态
        // 注意：这里简化处理，实际可能需要根据具体版本调整
        isAlwaysGranted = status == PermissionStatus.granted && 
                         await Permission.locationWhenInUse.status.isGranted &&
                         await Permission.locationAlways.status.isGranted;
        LogUtil.d('iOS平台始终允许权限状态: $isAlwaysGranted');
      }

      // 如果是始终允许权限，直接返回true
      if (isAlwaysGranted) {
        LogUtil.d('位置权限已设置为始终允许，直接使用');
        return true;
      }

      // 情况3：其他情况（包括临时拒绝、首次请求或"本次使用时允许"后重新打开应用）
      // 检查系统是否允许再次显示权限请求弹窗
      bool shouldShowRationale = await Permission.location.shouldShowRequestRationale;
      LogUtil.d('是否应该显示权限说明: $shouldShowRationale');

      // 对于"本次使用时允许"后重新打开应用的情况，即使status.isGranted为true，也需要重新请求权限
      // 所以这里直接请求权限，不检查status.isGranted
      PermissionStatus permissionStatus = await Permission.location.request();
      LogUtil.d('位置权限请求结果: $permissionStatus');

      // 根据请求结果返回相应的值
      if (permissionStatus.isGranted) {
        LogUtil.d('用户授予了位置权限');
        return true;
      } else if (permissionStatus.isPermanentlyDenied) {
        LogUtil.d('用户拒绝位置权限并不再询问');
        return false;
      } else {
        LogUtil.d('用户拒绝了位置权限');
        // 如果用户拒绝了权限，可以提示用户权限的必要性
        FlutterToastUtils.showToast('需要位置权限才能获取您的位置信息');
        return false;
      }
    } catch (e) {
      LogUtil.e('请求位置权限出错: $e');
      FlutterToastUtils.showErrorToast('请求位置权限失败');
      return false;
    } finally {
      // 无论如何，最后都要重置请求状态
      _isLocationPermissionRequesting = false;
    }
  }

  /// 请求位置权限（包含后台位置）
  static Future<bool> requestLocationPermissionWithBackground(
    BuildContext context,
  ) async {
    // 检查是否已有权限请求正在进行中
    if (_isLocationPermissionRequesting) {
      LogUtil.d('已有位置权限请求正在进行中，跳过后台权限请求');
      return false;
    }

    try {
      // 设置请求状态为进行中
      _isLocationPermissionRequesting = true;

      // 先请求前台位置权限
      bool foregroundGranted = await requestLocationPermission(context);

      if (!foregroundGranted) {
        return false;
      }

      // 如果前台权限已授予，再请求后台位置权限（仅在Android上可用）
      // 仅在Android平台请求后台定位权限
      if (defaultTargetPlatform == TargetPlatform.android) {
        LogUtil.d('开始请求后台位置权限');
        var backgroundStatus = await Permission.locationAlways.status;
        LogUtil.d('当前后台位置权限状态: $backgroundStatus');

        if (!backgroundStatus.isGranted) {
          PermissionStatus permissionStatus = await Permission.locationAlways
              .request();
          LogUtil.d('后台位置权限请求结果: $permissionStatus');

          if (!permissionStatus.isGranted) {
            FlutterToastUtils.showToast('后台位置权限请求被拒绝');
            return false;
          }
        }
      } else {
        LogUtil.d('当前平台不支持后台位置权限请求');
      }

      LogUtil.d('位置权限请求成功');
      return true;
    } catch (e) {
      LogUtil.e('请求后台位置权限出错: $e');
      FlutterToastUtils.showErrorToast('请求后台位置权限失败');
      return false;
    } finally {
      // 无论如何，最后都要重置请求状态
      _isLocationPermissionRequesting = false;
    }
  }

  /// 请求相机权限
  static Future<bool> requestCameraPermission() async {
    try {
      var status = await Permission.camera.status;
      LogUtil.d('当前相机权限状态: $status');

      if (status.isGranted) {
        return true;
      }

      if (status.isPermanentlyDenied || status.isDenied) {
        if (status.isPermanentlyDenied) {
          FlutterToastUtils.showToast('相机权限被拒绝，请在设置中开启');
          try {
            LogUtil.d('正在打开应用设置页面...');
            await openAppSettings();
            // 添加短暂延迟，确保设置页面有足够时间打开
            await Future.delayed(Duration(milliseconds: 500));
          } catch (e) {
            LogUtil.e('打开设置页面失败: $e');
            FlutterToastUtils.showErrorToast('无法打开设置页面，请手动前往设置');
          }
        }

        PermissionStatus permissionStatus = await Permission.camera.request();
        LogUtil.d('相机权限请求结果: $permissionStatus');

        if (permissionStatus.isGranted) {
          return true;
        } else {
          FlutterToastUtils.showToast('需要相机权限才能拍照或扫码');
          return false;
        }
      }

      return false;
    } catch (e) {
      LogUtil.e('请求相机权限出错: $e');
      FlutterToastUtils.showErrorToast('请求相机权限失败');
      return false;
    }
  }

  /// 请求相册权限
  static Future<bool> requestPhotoPermission() async {
    try {
      Permission permission;

      // 根据平台选择正确的相册权限
      if (defaultTargetPlatform == TargetPlatform.android) {
        permission = Permission.photos;
      } else {
        permission = Permission.photos;
      }

      var status = await permission.status;
      LogUtil.d('当前相册权限状态: $status');

      if (status.isGranted) {
        return true;
      }

      if (status.isPermanentlyDenied || status.isDenied) {
        if (status.isPermanentlyDenied) {
          FlutterToastUtils.showToast('相册权限被拒绝，请在设置中开启');
          try {
            LogUtil.d('正在打开应用设置页面...');
            await openAppSettings();
            // 添加短暂延迟，确保设置页面有足够时间打开
            await Future.delayed(Duration(milliseconds: 500));
          } catch (e) {
            LogUtil.e('打开设置页面失败: $e');
            FlutterToastUtils.showErrorToast('无法打开设置页面，请手动前往设置');
          }
        }

        PermissionStatus permissionStatus = await permission.request();
        LogUtil.d('相册权限请求结果: $permissionStatus');

        if (permissionStatus.isGranted) {
          return true;
        } else {
          FlutterToastUtils.showToast('需要相册权限才能选择图片');
          return false;
        }
      }

      return false;
    } catch (e) {
      LogUtil.e('请求相册权限出错: $e');
      FlutterToastUtils.showErrorToast('请求相册权限失败');
      return false;
    }
  }

  /// 请求存储权限
  static Future<bool> requestStoragePermission() async {
    try {
      Permission permission;

      // 根据平台选择正确的存储权限
      if (defaultTargetPlatform == TargetPlatform.android) {
        // Android 13+ 使用新的存储权限
        if (defaultTargetPlatform == TargetPlatform.android) {
          permission = Permission.storage;
        } else {
          permission = Permission.photos; // 降级使用相册权限
        }
      } else {
        permission = Permission.storage;
      }

      var status = await permission.status;
      LogUtil.d('当前存储权限状态: $status');

      if (status.isGranted) {
        return true;
      }

      if (status.isPermanentlyDenied || status.isDenied) {
        if (status.isPermanentlyDenied) {
          FlutterToastUtils.showToast('存储权限被拒绝，请在设置中开启');
          try {
            LogUtil.d('正在打开应用设置页面...');
            await openAppSettings();
            // 添加短暂延迟，确保设置页面有足够时间打开
            await Future.delayed(Duration(milliseconds: 500));
          } catch (e) {
            LogUtil.e('打开设置页面失败: $e');
            FlutterToastUtils.showErrorToast('无法打开设置页面，请手动前往设置');
          }
        }

        PermissionStatus permissionStatus = await permission.request();
        LogUtil.d('存储权限请求结果: $permissionStatus');

        if (permissionStatus.isGranted) {
          return true;
        } else {
          FlutterToastUtils.showToast('需要存储权限才能保存或读取文件');
          return false;
        }
      }

      return false;
    } catch (e) {
      LogUtil.e('请求存储权限出错: $e');
      FlutterToastUtils.showErrorToast('请求存储权限失败');
      return false;
    }
  }

  /// 检查权限是否被永久禁用，如果是则弹出确认对话框
  static Future<void> handlePermanentlyDeniedPermission(
    BuildContext context,
    String permissionName,
  ) async {
    try {
      // 弹出确认对话框
      if (!context.mounted) return;
      showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('权限被永久禁用'),
          content: Text('$permissionName已被永久禁用，需要前往设置页面开启才能继续使用此功能。'),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                LogUtil.d('用户取消跳转到设置页面');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('去设置'),
              onPressed: () async {
                LogUtil.d('用户确认跳转到设置页面');
                await openAppSettings();
                // 添加短暂延迟，确保设置页面有足够时间打开
                await Future.delayed(Duration(milliseconds: 1500));
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      );
    } catch (e) {
      LogUtil.e('处理永久禁用权限出错: $e');
      FlutterToastUtils.showErrorToast('检查权限状态失败');
    }
  }
}
