import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget.dart';

class NewExpenseActiveButtonWidget extends StatelessWidget {
  final String? title;
  final Function()? onPressed;
  final bool hasPadding;
  const NewExpenseActiveButtonWidget(
      {Key? key, this.title, this.onPressed, this.hasPadding = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: hasPadding
            ? EdgeInsets.symmetric(
                vertical: NewExpenseConstants.saveButtonPaddingVertical,
                horizontal: NewExpenseConstants.newExpensePaddingHorizontal,
              )
            : EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWidget.primary(title: title, onPress: onPressed),
          ],
        ));
  }
}
