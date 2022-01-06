import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

import 'alert_dialog_constants.dart';

class AlertDialogSpendy {
  static void showDialogOneAction(
      BuildContext context, String content, String labelBtn,
      {String? title}) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Material(
              type: MaterialType.transparency,
              child: CupertinoAlertDialog(
                  title: title != null
                      ? Text(
                          title,
                          style: ThemeText.getDefaultTextTheme()
                              .subtitle1!
                              .copyWith(
                                  fontSize: AlertDialogConstants.fzTitle,
                                  color: AppColor.black),
                        )
                      : null,
                  content: Text(
                    content,
                    style: ThemeText.getDefaultTextTheme().bodyText1!.copyWith(
                        fontSize: AlertDialogConstants.fzContent,
                        color: AppColor.black),
                  ),
                  actions: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: LayoutConstants.dimen_12),
                        child: Center(
                          child: Text(
                            labelBtn,
                            style: ThemeText.getDefaultTextTheme()
                                .button!
                                .copyWith(
                                    color: Colors.blue,
                                    fontSize: AlertDialogConstants.fzButtonText,
                                    fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ));
  }

  static void showDialogActions(BuildContext context, Widget content,
      {String? title, List<Widget>? actions}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CupertinoAlertDialog(
            title: title != null ? Text(title) : null,
            content: content,
            actions: actions!));
  }
}
