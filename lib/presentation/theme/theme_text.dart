import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

import 'theme_color.dart';

//w100 Thin, the least thick
//w200 Extra-light
//w300 Light
//w400 Normal / regular / plain
//w500 Medium
//w600 Semi-bold
//w700 Bold
//w800 Extra-bold
//w900 Black, the most thick

// All text style based on design guideline

class ThemeText {
  // Default Text Style Following Guideline

  static TextTheme getDefaultTextTheme() => TextTheme(
      headline1: TextStyle(
          fontSize: 38.sp,
          fontWeight: FontWeight.bold,
          color: AppColor.textColor),
      headline2: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.normal,
          color: AppColor.textColor),
      headline3: TextStyle(
          fontSize: 26.sp,
          fontWeight: FontWeight.normal,
          color: AppColor.textColor),
      headline4: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.normal,
          color: AppColor.textColor),
      headline5: TextStyle(
          fontSize: 44.0.sp,
          fontWeight: FontWeight.bold,
          color: AppColor.textColor),
      subtitle1: TextStyle(
          fontSize: 27.sp,
          fontWeight: FontWeight.bold,
          color: AppColor.textColor),
      bodyText1: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.normal,
          color: AppColor.textColor),
      bodyText2: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
      headline6: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.normal),
      caption: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
          color: AppColor.textColor,
          letterSpacing: -0.3),
      overline: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.4,
          color: AppColor.iconColorGrey),
      subtitle2: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
          color: AppColor.textColor),
      button: TextStyle(
          fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColor.white));
}

extension CustomTextTheme on TextTheme {
  TextStyle get snackbarTextStyle => TextStyle(
        fontSize: 18.sp,
        color: AppColor.black,
      );

  TextStyle get buttonTextStyle => TextStyle(
      fontSize: 18.sp,
      color: AppColor.white,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.4);

  TextStyle get captionSemiBold => TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColor.textColor);

  TextStyle get textLabelItem => TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      color: AppColor.textColor,
      letterSpacing: -0.3);

  TextStyle get textTitleItem => TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: AppColor.textColor,
      letterSpacing: -0.3);

  TextStyle get textHint => TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: AppColor.textHintColor,
      letterSpacing: -0.3);

  TextStyle get textMenu => TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: AppColor.textColor,
      letterSpacing: -0.3);

  TextStyle get subTextMenu => TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.bold,
      color: AppColor.textCaptionColor,
      letterSpacing: -0.18);

  TextStyle get paymentTitle => TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.w500,
      color: AppColor.white,
      letterSpacing: -0.18);

  TextStyle get textMoneyMenu => TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      color: AppColor.textColor,
      letterSpacing: -0.3);

  TextStyle get textTotalMoneyChart => TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      color: AppColor.textColor,
      letterSpacing: -0.4);

  TextStyle get textErrorField => TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
      color: AppColor.textError);

  TextStyle get hint => TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: AppColor.textHintColor,
      letterSpacing: -0.3);

  TextStyle get textField => TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: AppColor.textColor,
      letterSpacing: -0.3);

  TextStyle get textDateRange => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.normal,
      );
  TextStyle get labelStyle => TextStyle(
      fontSize: 15.sp, fontWeight: FontWeight.w400, color: AppColor.black);

  TextStyle get textLabelChart => TextStyle(
      fontSize: 13.sp,
      fontWeight: FontWeight.bold,
      color: AppColor.textChartGrey);
  TextStyle get priceStyle => TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      color: AppColor.lightPurple);
  TextStyle get titleMenuPayments => TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColor.grey);
  TextStyle get textNoInternet => TextStyle(
      fontSize: 18.sp,
      letterSpacing: -0.34,
      fontWeight: FontWeight.bold,
      color: AppColor.primaryDarkColor);

  TextStyle get titleStyle => ThemeText.getDefaultTextTheme()
      .textMoneyMenu
      .copyWith(fontSize: 10.sp, color: AppColor.textColor);
  TextStyle get infomationPaymentStyle =>
      TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp);
  TextStyle get currencyNationalStyle => TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.w600,
      color: const Color(0xff3A385A));
  TextStyle get transactionSubTextStyle => TextStyle(
      color: AppColor.grey,
      fontStyle: FontStyle.normal,
      fontSize: 13.sp,
      fontWeight: FontWeight.w500);
}
