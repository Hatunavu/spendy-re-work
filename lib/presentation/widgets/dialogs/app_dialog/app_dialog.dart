import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/app_dialog/action_button.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/app_dialog/app_dialog_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class AppDialog extends StatelessWidget {
  final String? title;
  final double? buttonTextSize;
  final String? rightButtonTitle;
  final String? leftButtonTitle;
  final Widget? content;
  final Function()? rightAction;
  final Function()? leftAction;
  final bool? haveLeftButton;
  final Color cancelColor;
  final Color applyColor;

  AppDialog({
    Key? key,
    this.title,
    this.rightButtonTitle,
    this.leftButtonTitle,
    this.content,
    this.rightAction,
    this.leftAction,
    this.applyColor = AppColor.primaryColor,
    this.cancelColor = AppColor.red,
    this.buttonTextSize,
    this.haveLeftButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
          horizontal: AppDialogConstants.dialogMarginHorizontal),
      child: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(LayoutConstants.roundedRadius),
          color: AppColor.white),
      padding: const EdgeInsets.only(
        top: AppDialogConstants.dialogPaddingVertical,
        bottom: AppDialogConstants.dialogPaddingVertical,
        left: AppDialogConstants.dialogPaddingHorizontal,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _title(),
          content!,
          _groupButton(),
        ],
      ),
    );
  }

  Widget _title() => Padding(
        padding: const EdgeInsets.only(
          right: AppDialogConstants.dialogPaddingHorizontal,
        ),
        child: Text(
          title ?? AppDialogConstants.dialogTitleDefault,
          style: ThemeText.getDefaultTextTheme()
              .headline4!
              .copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      );

  Widget _groupButton() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (haveLeftButton!)
            Expanded(
                flex: 1,
                child: Center(
                  child: ActionButton(
                    title:
                        leftButtonTitle ?? AppDialogConstants.applyTitleDefault,
                    onPressed: leftAction!,
                    color: AppColor.red,
                    textSize: buttonTextSize,
                    padding: EdgeInsets.zero,
                  ),
                )),
          Expanded(
              flex: 1,
              child: Center(
                child: ActionButton(
                  title:
                      rightButtonTitle ?? AppDialogConstants.applyTitleDefault,
                  onPressed: rightAction!,
                  textSize: haveLeftButton!
                      ? buttonTextSize
                      : (buttonTextSize! + 4.sp),
                  padding: EdgeInsets.zero,
                ),
              )),
        ],
      );
}
