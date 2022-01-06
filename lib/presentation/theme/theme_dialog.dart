import 'package:flutter/material.dart';

import 'theme_color.dart';
import 'theme_text.dart';

class ThemeDialog {
  // default Dialog style following guideline
  static double elevation = 0.0;
  static ShapeBorder shapeBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(13.0),
      side: const BorderSide(color: AppColor.white));
  static TextStyle titleTextStyle = ThemeText.getDefaultTextTheme()
      .headline6!
      .copyWith(fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle contentTextStyle =
      ThemeText.getDefaultTextTheme().caption!.copyWith(color: Colors.black);

  static DialogTheme getDefaultDialogTheme() => DialogTheme(
        elevation: ThemeDialog.elevation,
        shape: ThemeDialog.shapeBorder,
        titleTextStyle: ThemeDialog.titleTextStyle,
        contentTextStyle: ThemeDialog.contentTextStyle,
      );
}
