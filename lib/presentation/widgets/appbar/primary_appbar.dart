import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/utils/screen_utils.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

import 'appbar_constants.dart';

class AppbarNormalWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? action;
  final String? title;
  final Alignment actionAlignment;
  final Function()? onAction;
  final Color? colorBackground;
  final Color? colorTitle;
  AppbarNormalWidget(
      {this.leading,
      this.title,
      this.action,
      this.actionAlignment = Alignment.centerRight,
      this.onAction,
      this.colorTitle,
      this.colorBackground});

  @override
  Size get preferredSize => AppbarConstants.heightAppbar;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.1;
    return Container(
      color: colorBackground ?? AppColor.white,
      height: height,
      child: SafeArea(
          child: Stack(
        children: [
          Container(
            width: ScreenUtil().screenWidth,
            alignment: Alignment.center,
            child: Text(
              title ?? ' ',
              style: ThemeText.getDefaultTextTheme()
                  .headline4!
                  .copyWith(fontWeight: FontWeight.bold, color: colorTitle),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SizedBox(height: height, width: 65.w, child: leading),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onAction,
              child: Container(
                  color: colorBackground ?? Colors.white,
                  height: height,
                  width: 65.w,
                  child: action),
            ),
          ),
        ],
      )),
    );
  }
}
