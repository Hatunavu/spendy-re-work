import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class AppbarConstants {
  static double fzTitle = 22.sp;

  static const heightAppbar = Size.fromHeight(56);
  static double actionHeight = 26.h;

  static EdgeInsetsGeometry appbarPaddingIOS =
      EdgeInsets.fromLTRB(26.w, 0, 26.w, 8.h);
  static EdgeInsetsGeometry appbarPaddingAndroid =
      EdgeInsets.fromLTRB(26.w, 10.h, 26.w, 8.h);
  static const double paddingTopIOS = 0;
  static const double paddingTopAndroid = 15;
  static double paddingHorizontal35 = 35.w;
  static double paddingHorizontal20 = 20.w;
}
