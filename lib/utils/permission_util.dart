// 权限工具类
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:my_app_cat/utils/flutter_toast_util.dart'; // 引入您已有的toast工具类
import 'log_util.dart'; // 引入日志工具类

/// 权限管理工具类
class PermissionUtil {
  /// 请求位置权限
  static Future<bool> requestLocationPermission() async {
    try {
      // 检查位置权限状态
      var status = await Permission.location.status;
      LogUtil.d('当前位置权限状态: $status');

      // 如果权限已授予，直接返回true
      if (status.isGranted) {
        return true;
      }

      // 如果权限被永久拒绝，提示用户去设置页面开启
      if (status.isPermanentlyDenied || status.isDenied) {
        // 显示提示信息
        FlutterToastUtils.showToast('位置权限被拒绝，请在设置中开启');

        // 对于被永久拒绝的情况，引导用户去设置
        if (status.isPermanentlyDenied) {
          // 打开应用设置页面
          await openAppSettings();
        }

        // 请求权限
        PermissionStatus permissionStatus = await Permission.location.request();
        LogUtil.d('位置权限请求结果: $permissionStatus');

        // 根据请求结果返回相应的值
        if (permissionStatus.isGranted) {
          return true;
        } else {
          // 如果用户拒绝了权限，可以提示用户权限的必要性
          FlutterToastUtils.showToast('需要位置权限才能获取您的位置信息');
          return false;
        }
      }

      return false;
    } catch (e) {
      LogUtil.e('请求位置权限出错: $e');
      FlutterToastUtils.showErrorToast('请求位置权限失败');
      return false;
    }
  }

  /// 请求位置权限（包含后台位置）
  static Future<bool> requestLocationPermissionWithBackground() async {
    try {
      // 先请求前台位置权限
      bool foregroundGranted = await requestLocationPermission();

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
    }
  }

  /// 检查并请求多个权限
  static Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(
    List<Permission> permissions,
  ) async {
    try {
      LogUtil.d('开始请求多个权限: $permissions');
      final Map<Permission, PermissionStatus> statuses = await permissions
          .request();

      // 记录每个权限的请求结果
      statuses.forEach((permission, status) {
        LogUtil.d('权限 $permission 请求结果: $status');
      });

      return statuses;
    } catch (e) {
      LogUtil.e('请求多个权限出错: $e');
      FlutterToastUtils.showErrorToast('请求权限失败');
      return {};
    }
  }

  /// 检查多个权限是否都已授予
  static bool areAllPermissionsGranted(
    Map<Permission, PermissionStatus> statuses,
  ) {
    return statuses.values.every((status) => status.isGranted);
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
          await openAppSettings();
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
          await openAppSettings();
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
          await openAppSettings();
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

  /// 显示权限被拒绝的弹窗提示
  static void showPermissionDeniedDialog(
    BuildContext context,
    String permissionName,
  ) {
    try {
      LogUtil.d('显示$permissionName权限被拒绝的弹窗');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('权限申请'),
          content: Text('需要$permissionName权限才能继续使用此功能，请在设置中开启。'),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                LogUtil.d('用户取消了权限设置');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('去设置'),
              onPressed: () async {
                LogUtil.d('用户选择去设置页面');
                Navigator.of(context).pop();
                try {
                  await openAppSettings();
                  LogUtil.d('已打开应用设置页面');
                } catch (e) {
                  LogUtil.e('打开设置页面失败: $e');
                  FlutterToastUtils.showErrorToast('无法打开设置页面');
                }
              },
            ),
          ],
        ),
      );
    } catch (e) {
      LogUtil.e('显示权限弹窗出错: $e');
      FlutterToastUtils.showErrorToast('显示权限提示失败');
    }
  }
}
