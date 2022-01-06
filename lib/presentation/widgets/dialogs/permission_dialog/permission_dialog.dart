import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/app_dialog/app_dialog.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/dialog_constants.dart';

import 'permission_dialog_constants.dart';

class PermissionDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function() onPressedSetting;

  const PermissionDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onPressedSetting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: title,
      rightButtonTitle: PermissionDialogConstants.denyTxt,
      leftButtonTitle: PermissionDialogConstants.settingTxt,
      content: _content(),
      rightAction: () => Navigator.pop(context),
      leftAction: onPressedSetting,
      cancelColor: AppColor.primaryColor,
    );
  }

  Widget _content() => Padding(
        padding: const EdgeInsets.only(
          top: DialogConstants.spaceBetweenContentAndButton,
          right: DialogConstants.transactionDialogPadding,
        ),
        child: Text(
          content, //?? 'This app needs notification permission to push notification',
          style: ThemeText.getDefaultTextTheme().caption,
        ),
      );
}
