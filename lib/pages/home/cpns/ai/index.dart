import 'package:flutter/material.dart';
import 'package:cat/utils/log_util.dart';
import 'package:cat/utils/permission_util.dart';

class Ai extends StatefulWidget {
  const Ai({super.key});

  @override
  State<Ai> createState() => _AiState();
}

class _AiState extends State<Ai> with WidgetsBindingObserver {
  bool _isGranted = false;

  @override
  void initState() {
    super.initState();
    // 注册WidgetsBindingObserver，用于监听应用生命周期变化
    WidgetsBinding.instance.addObserver(this);
    // 应用启动时请求权限
    _requestPermission();
  }

  @override
  void dispose() {
    // 移除观察者
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 标记是否是首次进入页面时的生命周期回调
  bool _isFirstLifecycleCall = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 当应用从后台恢复到前台时（例如从设置页面返回）
    if (state == AppLifecycleState.resumed) {
      // 跳过首次生命周期回调，避免重复请求权限
      if (_isFirstLifecycleCall) {
        _isFirstLifecycleCall = false;
        return;
      }

      _requestPermission();
    }
  }

  // 请求权限的方法
  Future<void> _requestPermission() async {
    if (!mounted) return;

    // 调用修改后的requestLocationPermission方法
    // 该方法现在会：
    // 1. 只对"始终允许"的权限直接返回true
    // 2. 对"本次使用时允许"和其他情况重新请求权限
    // 3. 对"禁止且不再询问"的情况显示设置跳转提示
    bool granted = await PermissionUtil.requestLocationPermission(context);

    // 更新UI状态
    if (granted) {
      LogUtil.d('位置权限已授权');
      setState(() {
        _isGranted = granted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: _isGranted ? Text("AI 模块 已授权") : Text("AI 模块 未授权")),
    );
  }
}
