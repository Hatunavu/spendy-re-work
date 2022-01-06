import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/app_dialog/app_dialog.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/dialog_constants.dart';

import 'logout_dialog_constants.dart';

class LogoutDialogWidget extends StatelessWidget {
  final Function() onPressedYes;
  final Function() onPressedNo;

  const LogoutDialogWidget({
    Key? key,
    required this.onPressedYes,
    required this.onPressedNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: LogoutDialogConstants.textTitleLogout,
      rightButtonTitle: LogoutDialogConstants.textOk,
      leftButtonTitle: LogoutDialogConstants.textCancel,
      content: _content(),
      rightAction: onPressedYes,
      leftAction: onPressedNo,
    );
  }

  Widget _content() => Padding(
        padding: const EdgeInsets.only(
          top: DialogConstants.spaceBetweenContentAndButton,
          right: DialogConstants.transactionDialogPadding,
        ),
        child: Text(
          LogoutDialogConstants.textContentLogout,
          style: ThemeText.getDefaultTextTheme().caption,
        ),
      );
}
