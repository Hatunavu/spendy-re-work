import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/app_dialog/app_dialog.dart';

import 'delete_dialog_constants.dart';

class DeleteDialogWidget extends StatelessWidget {
  final Function() onPressedYes;
  final Function() onPressedNo;
  final String? typeNameItem;

  const DeleteDialogWidget(
      {Key? key,
      required this.onPressedYes,
      required this.onPressedNo,
      this.typeNameItem = 'item'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: '${DeleteDialogConstants.notificationTitle} $typeNameItem',
      rightButtonTitle: DeleteDialogConstants.yesButtonTitle,
      leftButtonTitle: DeleteDialogConstants.noButtonTitle,
      content: _content(),
      rightAction: onPressedYes,
      leftAction: onPressedNo,
    );
  }

  Widget _content() => Padding(
        padding: const EdgeInsets.only(
          top: TransactionConstants.spaceBetweenContentAndButton,
          right: TransactionConstants.transactionDialogPadding,
        ),
        child: Text(
          '${DeleteDialogConstants.deleteMessage} $typeNameItem?',
          style: ThemeText.getDefaultTextTheme().caption,
        ),
      );
}
