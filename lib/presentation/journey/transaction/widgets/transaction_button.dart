import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_constants.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget.dart';

class TransactionButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final Color? color;

  const TransactionButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: TransactionConstants.spaceBetweenContentAndButton,
        right: TransactionConstants.transactionDialogPadding,
      ),
      child: ButtonWidget.primary(
        onPress: onPressed,
        title: title,
        color: color,
      ),
    );
  }
}
