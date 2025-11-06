import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class Information extends StatefulWidget {
  const Information({super.key});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'animations/loading.json',
          width: 80.w,
          height: 100.h,
          repeat: true, // 是否循环播放
          reverse: false, // 是否倒放
          animate: true, // 是否自动播放
        ),
      ),
    );
  }
}
