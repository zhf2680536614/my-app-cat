import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class Person extends StatefulWidget {
  const Person({super.key});

  @override
  State<Person> createState() => _PersonState();
}

class _PersonState extends State<Person> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'animations/loading_single.json',
              width: 80,
              height: 100,
              repeat: true, // 是否循环播放
              reverse: false, // 是否倒放
              animate: true, // 是否自动播放
            ),
            SizedBox(
              width: 300.w,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: '请输入姓名',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: TextField(
                  decoration: InputDecoration.collapsed(hintText: '请输入姓名'),
                ),
              ),
            ),
            SizedBox(height: 20.h,),
            SizedBox(
              width: 300.w,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: '请输入手机号',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: TextField(
                  decoration: InputDecoration.collapsed(hintText: '请输入手机号'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
