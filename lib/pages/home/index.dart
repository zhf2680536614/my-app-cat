import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './cpns/ai/index.dart';
import './cpns/search/index.dart';
import './cpns/market/index.dart';
import './cpns/person/index.dart';
import './cpns/information/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //定义默认展示的页面索引
  int _currentIndex = 0;

  //定义首页展示的页面集合
  final List<Widget> _pages = [
    const Search(),
    const Market(),
    const Ai(),
    const Information(),
    const Person(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = 2;
          });
        },
        child: Container(
          width: 50.w,
          height: 50.h,
          margin: EdgeInsets.only(top: 0.h),
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 227, 205, 1.0),
            shape: BoxShape.circle,
            border: Border.all(
              width: 1.sp,
              color: Color.fromRGBO(255, 120, 0, 1.0),
            ),
          ),
          child: SvgPicture.asset(
            'assets/home/bottom/baimao.svg',
            width: 24.sp,
            height: 24.sp,
          ),
        ),
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Theme(
        // 禁用水波纹效果，同时继承全局字体设置
        data: ThemeData(
          fontFamily: 'AlimamaFangYuanTiVF',
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          // 基础配置
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },

          // 外观样式属性
          type: BottomNavigationBarType.fixed,
          // 两种类型：fixed（固定）或shifting（浮动效果）
          backgroundColor: const Color.fromARGB(255, 255, 248, 248),
          // 导航栏背景色
          elevation: 0,
          // 阴影高度，设置为0可移除阴影
          // 颜色相关属性
          selectedItemColor: Color.fromRGBO(255, 119, 0, 1),
          // 选中项颜色
          unselectedItemColor: Color.fromRGBO(0, 0, 0, 1),
          // 未选中项颜色
          // 文本标签相关属性
          showSelectedLabels: true,
          // 是否显示选中项标签
          showUnselectedLabels: true,
          // 是否显示未选中项标签
          selectedFontSize: 12.sp,
          // 选中项字体大小
          unselectedFontSize: 12.sp,
          // 未选中项字体大小
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w900,
            fontFamily: 'AlimamaFangYuanTiVF',
          ),
          // 选中项文本样式
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w900,
            fontFamily: 'AlimamaFangYuanTiVF',
          ),
          // 未选中项文本样式
          // 图标相关属性
          selectedIconTheme: const IconThemeData(size: 20),
          // 选中项图标主题
          unselectedIconTheme: const IconThemeData(size: 20),
          // 未选中项图标主题
          // 横屏布局选项（当屏幕横屏时的布局方式）
          landscapeLayout: BottomNavigationBarLandscapeLayout.spread,

          // 移除旧的颜色方案
          useLegacyColorScheme: false,

          // 导航项
          items: [
            // 注意：在BottomNavigationBarType.fixed模式下，单个item的backgroundColor不起作用
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/home/bottom/chaiquan.svg',
                width: 24.w,
                height: 24.h,
              ),
              activeIcon: SvgPicture.asset(
                'assets/home/bottom/chaiquan.svg',
                width: 24.w,
                height: 24.h,
              ),
              label: '首页',
              tooltip: '柴犬', // 长按提示
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/home/bottom/cangshu.svg',
                width: 24.w,
                height: 24.h,
              ),
              activeIcon: SvgPicture.asset(
                'assets/home/bottom/cangshu.svg',
                width: 24.w,
                height: 24.h,
              ),
              label: '检索',
              tooltip: '仓鼠',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(width: 24.w, height: 24.h),
              activeIcon: SizedBox(width: 24.w, height: 24.h),
              label: '发布',
              tooltip: '发布',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/home/bottom/buoumao.svg',
                width: 24.w,
                height: 24.h,
              ),
              activeIcon: SvgPicture.asset(
                'assets/home/bottom/buoumao.svg',
                width: 24.w,
                height: 24.h,
              ),
              label: '消息',
              tooltip: '布偶猫',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/home/bottom/xiaoyang.svg',
                width: 24.w,
                height: 24.h,
              ),
              activeIcon: SvgPicture.asset(
                'assets/home/bottom/xiaoyang.svg',
                width: 24.w,
                height: 24.h,
              ),
              label: '我的',
              tooltip: '小羊',
            ),
          ],
        ),
      ),
    );
  }
}
