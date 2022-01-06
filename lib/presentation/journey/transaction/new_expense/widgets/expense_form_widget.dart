import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/button_state.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';

class ExpenseFormWidget extends StatelessWidget {
  final String? title;
  final String? content;

  final ButtonState? isHintText;
  final Function()? onPressTitle;
  final Function()? onPressContent;

  const ExpenseFormWidget(
      {Key? key,
      this.title,
      this.content = '',
      this.onPressTitle,
      this.isHintText = ButtonState.nonActive,
      this.onPressContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onTap: onPressTitle,
          child: Text(
            title!,
            style: ThemeText.getDefaultTextTheme().textMenu,
          ),
        ),
        GestureDetector(
          onTap: onPressContent,
          child: Text(
            content!,
            style: isHintText == ButtonState.active
                ? ThemeText.getDefaultTextTheme()
                    .caption
                    ?.copyWith(fontSize: NewExpenseConstants.fzHintText)
                : ThemeText.getDefaultTextTheme()
                    .textHint
                    .copyWith(fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }
}
