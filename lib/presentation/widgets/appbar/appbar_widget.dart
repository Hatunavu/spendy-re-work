//import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

import 'appbar_constants.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool leading;

  AppBarWidget(
      {Key? key, required this.title, this.actions, this.leading = false})
      : super(key: key);

  @override
  Size get preferredSize => AppbarConstants.heightAppbar;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: SafeArea(
        child: _headerWidget(context),
      ),
    );
  }

  Widget _headerWidget(BuildContext context) {
    double paddingTop = AppbarConstants.paddingTopIOS;
    if (Platform.isAndroid) {
      paddingTop = AppbarConstants.paddingTopAndroid;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                left: LayoutConstants.paddingHorizontal, top: paddingTop),
            child: GestureDetector(
              onTap: leading ? () => Navigator.pop(context) : null,
              child: Row(
                children: [
                  SizedBox(
                    height: LayoutConstants.dimen_18,
                    child: leading
                        ? Row(
                            children: [
                              Image.asset(
                                IconConstants.backIcon,
                                color: AppColor.primaryDarkColor,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                            ],
                          )
                        : null,
                  ),
                  Text(
                    title,
                    style: ThemeText.getDefaultTextTheme()
                        .headline4!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: actions != null && actions!.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(
                right: LayoutConstants.paddingHorizontal21),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!
                  .map((action) => Padding(
                        padding: EdgeInsets.only(
                            left: AppbarConstants.paddingHorizontal20),
                        child: action,
                      ))
                  .toList(),
            ),
          ),
        )
      ],
    );
  }
}
