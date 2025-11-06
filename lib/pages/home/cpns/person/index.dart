import 'package:flutter/material.dart';
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
        child: Lottie.asset(
          'animations/loading_single.json',
          width: 80,
          height: 100,
          repeat: true, // 是否循环播放
          reverse: false, // 是否倒放
          animate: true, // 是否自动播放
        ),
      ),
    );
  }
}
