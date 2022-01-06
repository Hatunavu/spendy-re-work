import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:flutter/material.dart';

class CurrencyScreenConstants {
  static String titleScreen = translate('label.currency');
  static String textSave = translate('label.save');
  static String textPopular = translate('label.popular');
  static String textResultSearch = translate('label.result');

  static final paddingBody = EdgeInsets.only(
      left: CurrencyScreenConstants.paddingLeft,
      top: CurrencyScreenConstants.paddingTop);

  static final paddingHorizontal = EdgeInsets.symmetric(
    horizontal: CurrencyScreenConstants.paddingLeft,
  );

  static final double paddingLeft = 27.w;
  static final double paddingTop = 16.h;
  static final double paddingBottom = 16.h;
  static final double titlePaddingLeft = 12.w;
  static final double titlePaddingRight = 26.w;

  static final double labelPaddingBottom = 18.h;
  static final double paddingBottom28 = 28.h;

  static final double sizeRadio = 20.w;

  static final double fzSaveText = 20.sp;
}
