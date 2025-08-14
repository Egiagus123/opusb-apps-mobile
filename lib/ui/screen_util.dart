import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class ScreenUtil {
  // Fungsi untuk membungkus aplikasi dengan ScreenUtilInit
  static Widget init({
    Widget? child,
    double? screenSizeheight,
    double? screenSizewidth,
  }) {
    return ScreenUtilInit(
      designSize: Size(
          screenSizewidth!, screenSizeheight!), // Ukuran desain yang diinginkan
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => child!,
    );
  }
}
