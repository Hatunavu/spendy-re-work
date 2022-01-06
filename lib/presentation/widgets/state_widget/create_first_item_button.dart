import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget.dart';
import 'package:spendy_re_work/presentation/widgets/state_widget/state_widget_constants.dart';

class CreateFirstItemButton extends StatelessWidget {
  final String? titleButton;
  final Function()? onPressButton;

  const CreateFirstItemButton({Key? key, this.titleButton, this.onPressButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
          vertical: NewExpenseConstants.saveButtonPaddingVertical,
          horizontal: NewExpenseConstants.newExpensePaddingHorizontal,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWidget.primary(
                width: StateWidgetConstants.widthCreateButton,
                height: StateWidgetConstants.heightCreateButton,
                title: titleButton!,
                onPress: onPressButton!),
          ],
        ));
  }
}
