import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

// 自定义Toast工具类
class FlutterToastUtils {
  //成功提示
  static void showSuccessToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: const Color.fromARGB(255, 84, 255, 89),
      textColor: Colors.white,
      fontSize: 16.0.sp,
    );
  }

  //错误提示
  static void showErrorToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: const Color.fromARGB(255, 255, 89, 89),
      textColor: Colors.white,
      fontSize: 16.0.sp,
    );
  }

  //常规提示
  static void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: const Color.fromRGBO(251, 175, 94, 1),
      textColor: const Color.fromARGB(255, 255, 255, 255),
      fontSize: 16.0.sp,
    );
  }
}
