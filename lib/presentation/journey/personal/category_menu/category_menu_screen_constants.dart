import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class CategoriesMenuScreenConstant {
  static String textTitle = translate('label.category');
  static String textExpense = translate('label.expense');
  static String textGoal = translate('label.goal');

  static double paddingLeft = 27.w;
  static double paddingTop = 16.h;
  static double paddingBottom = 16.h;

  static double fzMenu = 15.sp;

  static EdgeInsetsGeometry dividerPadding =
      const EdgeInsets.fromLTRB(0, 16, 0, 16);
}
