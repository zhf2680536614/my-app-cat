import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_app_cat/utils/flutter_toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_app_cat/api/test/test_api.dart';
import 'package:my_app_cat/model/user/user_model.dart';
import 'package:my_app_cat/utils/log_util.dart';

class Market extends StatefulWidget {
  const Market({super.key});

  @override
  State<Market> createState() => _MarketState();
}

class _MarketState extends State<Market> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: isLoading
            ? Lottie.asset(
                'animations/loading_color.json',
                width: 100.w,
                height: 100.h,
                repeat: true, // 是否循环播放
                reverse: false, // 是否倒放
                animate: true, // 是否自动播放
              )
            : TextButton(
                onPressed: () {
                  // 设置加载状态为true
                  setState(() {
                    isLoading = true;
                  });

                  TestApi()
                      .testService()
                      .then((value) {
                        UserModel userModel = value;
                        LogUtil.d("userModel: ${userModel.name}");
                        FlutterToastUtils.showSuccessToast(userModel.name);
                      })
                      .whenComplete(() {
                        // 请求完成后（无论成功失败）隐藏加载动画
                        setState(() {
                          isLoading = false;
                        });
                      });
                },
                child: Text(
                  '获取猫的信息',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'AlimamaFangYuanTiVF',
                  ),
                ),
              ),
      ),
    );
  }
}
