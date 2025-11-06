// 导入页面
import 'package:flutter/material.dart';

import '../pages/home/index.dart';
import '../pages/other/index.dart';

// 路由名称常量
class AppRoutes {
  static const String home = '/'; // 首页路由
  static const String other = '/other'; // 详情页路由
}

// 路由表：key是路由名称，value是构建页面的函数
final Map<String, WidgetBuilder> routes = {
  AppRoutes.home: (context) => HomePage(),
  AppRoutes.other: (context) => OtherPage(),
};
