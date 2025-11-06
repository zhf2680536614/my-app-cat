import 'package:get/get.dart';

class UserController extends GetxController {
  // 可观察变量（自动触发UI更新）
  final RxString username = '初始用户'.obs;
  final RxInt age = 0.obs;

  // 更新用户信息（任意组件可调用）
  void updateUser(String name, int userAge) {
    username.value = name;
    age.value = userAge;
  }
}

// 更新状态的示例
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:my_app/state_manager.dart';

// class Page1 extends StatelessWidget {
//   final UserController _controller = Get.put(UserController()); // 注册控制器

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // 监听状态变化
//         Obx(() => Text('用户名: ${_controller.username.value}')),
//         Obx(() => Text('年龄: ${_controller.age.value}')),
//         ElevatedButton(
//           onPressed: () {
//             _controller.updateUser('张三', 25); // 更新状态
//           },
//           child: Text('更新用户'),
//         ),
//       ],
//     );
//   }
// }

// 获取状态的示例
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:my_app/state_manager.dart';

// class Page2 extends StatelessWidget {
//   final UserController _controller = Get.find<UserController>(); // 获取全局控制器

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Obx(() => Text('Page2 用户名: ${_controller.username.value}')),
//         Obx(() => Text('Page2 年龄: ${_controller.age.value}')),
//       ],
//     );
//   }
// }