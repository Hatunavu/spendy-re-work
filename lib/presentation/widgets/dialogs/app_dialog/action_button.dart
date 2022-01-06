import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/app_dialog/app_dialog_constants.dart';

class ActionButton extends StatelessWidget {
  final String? title;
  final Function()? onPressed;
  final Color? color;
  final double? textSize;
  final EdgeInsets? padding;
  final EdgeInsets? verticalPadding;

  const ActionButton(
      {Key? key,
      this.title,
      this.onPressed,
      this.color,
      this.textSize,
      this.padding,
      this.verticalPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: verticalPadding ??
          const EdgeInsets.only(
            top: AppDialogConstants.spaceBetweenContentAndButton,
            right: AppDialogConstants.dialogPaddingHorizontal,
          ),
      child: ButtonWidget.primary(
        onPress: onPressed,
        title: title,
        color: color,
        textSize: textSize,
        padding: padding,
      ),
    );
  }
}
