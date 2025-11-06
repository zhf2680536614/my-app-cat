import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

class LogUtil {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // 显示方法栈层数
      colors: true, // 彩色输出
    ),
  );

  // Debug日志（仅开发环境输出）
  static void d(dynamic message, [dynamic error, StackTrace? stack]) {
    if (kDebugMode) {
      _logger.d(message, error: error, stackTrace: stack);
    }
  }

  // Info日志（开发/生产均可输出）
  static void i(dynamic message, [dynamic error, StackTrace? stack]) {
    _logger.i(message, error: error, stackTrace: stack);
  }

  // Error日志（必须输出）
  static void e(dynamic message, [dynamic error, StackTrace? stack]) {
    _logger.e(message, error: error, stackTrace: stack);
  }
}
