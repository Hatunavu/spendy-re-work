import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class AddPhotoElementOptionWidget extends StatelessWidget {
  final Widget? icon;
  final String? title;
  final Function? onTap;

  const AddPhotoElementOptionWidget(
      {Key? key, this.icon, this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!();
        Navigator.of(context).pop();
      },
      highlightColor: AppColor.deepPurpleCFD1F8,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: NewExpenseConstants.addPhotoElementOptionPaddingVertical),
        child: Row(
          children: <Widget>[
            icon!,
            const SizedBox(width: 15),
            Expanded(
                child: Text(title!,
                    style: ThemeText.getDefaultTextTheme().captionSemiBold))
          ],
        ),
      ),
    );
  }
}
