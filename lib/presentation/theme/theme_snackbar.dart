import 'package:flutter/material.dart';

import 'theme_color.dart';
import 'theme_text.dart';

class ThemeSnackBar {
  // default snack bar style following guideline

  static double elevation = 0.0;
  static SnackBarBehavior snackBarBehavior = SnackBarBehavior.fixed;

  static SnackBarThemeData getDefaultSnackBarTheme() => SnackBarThemeData(
        backgroundColor: AppColor.white,
        actionTextColor: AppColor.actionTextSnackBar,
        disabledActionTextColor: AppColor.disabledActionTextSnackBar,
        contentTextStyle: ThemeText.getDefaultTextTheme().caption,
        elevation: ThemeSnackBar.elevation,
        behavior: ThemeSnackBar.snackBarBehavior,
      );
}
