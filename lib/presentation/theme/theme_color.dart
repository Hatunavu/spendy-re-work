import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Define all custom color which includes
// Color code, hexa color, color from opacity, color from alpha

class AppColor {
  // because withAlpha replaced with `a` (which ranges from 0 to 255).;
  static const Color primaryColor = Color(0xff676FE5);
  static const Color primaryAccentColor = Color(0xffb8afe0);
  static const Color primaryDarkColor = Color(0xff3a385a);
  static const Color lightPurple = Color(0xff7077EA);
  static const Color hintColor = primaryDarkColor;
  static const Color hindColor = Color(0xffE3E3E3);
  static const Color dividerColor = Color(0xff707070);
  static const Color dateTimeTitleColor = Color.fromRGBO(209, 209, 217, 1);
  static const Color lightGrey = Color(0xffD4D4D4);
  static const Color pinkGrey = Color(0xffFF77A0);
  static const Color cornflowerBlue = Color(0xff8770FD);
  // text color
  static const Color textHideColor = Color(0xff707070);
  static const Color textColor = primaryDarkColor;
  static const Color textCaptionColor = iconColorGrey;
  static const Color textHintColor = textFilterNonActive;
  static const Color lineColor = hindColor;
  static const Color textError = redAccent;
  static const Color textChartGrey = Color.fromRGBO(162, 169, 188, 1);
  static const Color textFilterNonActive = Color.fromRGBO(130, 130, 130, 1);
  static Color searchHintTextColor = const Color(0xFF7077EA).withOpacity(0.3);

  // icon color
  static const Color iconColor = primaryDarkColor;
  static const Color iconColorGrey = Color.fromRGBO(123, 123, 123, 1);
  static const Color iconColorPrimary = Color.fromRGBO(112, 119, 234, 1);
  static Color searchBackgroundColor =
      const Color(0xFF7077ea).withOpacity(0.217);

  static const Color white = Colors.white;
  static const Color white38 = Colors.white38;
  static Color transparent = Colors.transparent;
  static const Color black = Colors.black;
  static const Color red = Color.fromRGBO(253, 126, 126, 1);
  static const Color amber = Color.fromRGBO(255, 198, 87, 1);
  static const Color amberAccent = Color.fromRGBO(255, 238, 204, 1);
  static const Color deepPurpleCFD1F8 = Color(0xffCFD1F8);
  static const Color deepPurple = iconColorPrimary;
  static const Color blue = Color.fromRGBO(26, 184, 254, 1);
  static const Color blueC0E7FE = Color(0xffC0E7FE);
  static const Color indigo = Color.fromRGBO(48, 130, 201, 1);
  static const Color indigoC0D5EC = Color(0xffC0D5EC);
  static const Color cyan = Color.fromRGBO(2, 179, 179, 1);
  static const Color cyanBAE5E5 = Color(0xffBAE5E5);
  static const Color pink = Color.fromRGBO(252, 90, 153, 1);
  static const Color pinkF2C8DC = Color(0xffF2C8DC);
  static const Color redAccent = Color.fromRGBO(253, 126, 126, 1);
  static const Color redAccentF5D3D4 = Color(0xffF5D3D4);
  static const Color orange = Color.fromRGBO(240, 141, 69, 1);
  static const Color orangeF2D8C2 = Color(0xffF2D8C2);
  static const Color green = Color.fromRGBO(60, 224, 155, 1);
  static const Color activeColor = Color(0xff20d760);
  static const Color trackColor = redAccent;
  static const Color greenCDF5DE = Color(0xffCDF5DE);
  static const Color purple = Color.fromRGBO(161, 97, 235, 1);
  static const Color purpleDACAF8 = Color(0xffDACAF8);
  static const Color red500 = Colors.red;
  static const Color red100 = Color(0xFFFFCDD2);

  // chart color
  static const Color chartBlueLight = colorTransport;
  static const Color chartBlue = colorBill;
  static const Color chartYellow = colorGroceries;
  static const Color chartNoHighLight = hindColor;
  static const Color chartRed = colorHealth;
  static const Color bgGroupTotalPieChart = Color.fromRGBO(239, 240, 246, 1);
  static const Color colorGroceries = amber;
  static const Color colorTransport = Color.fromRGBO(84, 203, 203, 1);
  static const Color colorOffice = orange;
  static const Color colorFoodDrink = iconColorPrimary;
  static const Color colorTravel = green;
  static const Color colorBill = blue;
  static const Color colorHealth = redAccent;
  static const Color colorBeauty = pink;
  static const Color colorEntertainment = indigo;
  static const Color colorOther = purple;

  static const Color colorBuyHouse = colorGroceries;
  static const Color colorEducation = colorHealth;
  static const Color colorBuyCar = cyan;
  static const Color colorHaveVacation = blue;
  static const Color colorShopping = iconColorPrimary;
  static const Color colorDebt = colorEntertainment;

  static const Color actionTextSnackBar = Colors.black;
  static const Color disabledActionTextSnackBar = Colors.grey;

  static const Color shadowsBottomTab = Color.fromRGBO(0, 0, 0, 0.53);

  /// Shimmer color
  static Color shimmerLine = const Color(0xFFE0E0E0);
  static Color shimmerBase = const Color(0xFFE0E0E0);
  static Color shimmerHighlight = const Color(0xFFF5F5F5);

  static Color black25 = Colors.black.withAlpha(64);
  static Color grey = const Color(0xff707070);
  static Color darkBlue = const Color(0xff3A385A);
}
