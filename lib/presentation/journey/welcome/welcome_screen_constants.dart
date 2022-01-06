import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class WelcomeScreenConstants {
  // Padding
  static double paddingTopSlogan = 32.5.h;
  static double versionPaddingTop = 160.h;

  // Size
  static Size logoSize = Size(76.w, 117.h);

  // Font size
  static double fzSlogan = 17.sp;

  // Multiple language
  static String textSlogan = translate('label.text_slogan');
}
