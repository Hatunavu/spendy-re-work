import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';

import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class ExpenseAppbarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String? appBarTitle;
  final Widget? child;
  final Function()? onPressBackButton;

  const ExpenseAppbarWidget(
      {Key? key, this.appBarTitle, this.child, this.onPressBackButton})
      : super(key: key);

  @override
  Size get preferredSize => NewExpenseConstants.heightAppbar;

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding;
    if (Platform.isIOS) {
      padding = NewExpenseConstants.appbarPaddingIOS;
    } else {
      padding = NewExpenseConstants.appbarPaddingAndroid;
    }
    return Container(
      color: AppColor.primaryColor,
      child: SafeArea(
        child: Padding(
            padding: padding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[_headerWidget(context), child!],
            )),
      ),
    );
  }

  Widget _headerWidget(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            appBarTitle ?? NewExpenseConstants.personalExpenseTitle,
            style: ThemeText.getDefaultTextTheme().headline4!.copyWith(
                color: AppColor.white,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.44,
                fontSize: NewExpenseConstants.fzTitleText),
          ),
        ),
        GestureDetector(
            onTap: onPressBackButton ?? () => Navigator.of(context).pop(),
            child: Image.asset(IconConstants.backIcon, width: 18, height: 18))
      ],
    );
  }
}
