import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        left: true,
        right: true,
        bottom: true,
        child: PageView(
          scrollDirection: Axis.vertical,
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/home/bottom/xiaoyang.svg',
                width: 24.w,
                height: 24.h,
              ),
            ),
            Center(
              child: SvgPicture.asset(
                'assets/home/bottom/buoumao.svg',
                width: 24.w,
                height: 24.h,
              ),
            ),
            Center(
              child: SvgPicture.asset(
                'assets/home/bottom/cangshu.svg',
                width: 24.w,
                height: 24.h,
              ),
            ),
            Center(
              child: SvgPicture.asset(
                'assets/home/bottom/chaiquan.svg',
                width: 24.w,
                height: 24.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
