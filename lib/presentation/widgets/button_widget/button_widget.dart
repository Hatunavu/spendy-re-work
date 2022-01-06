import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget_constants.dart';

import 'button_widget_constants.dart';

// ignore: must_be_immutable
class ButtonWidget extends StatelessWidget {
  final Function()? onPress;
  final String? title;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool isOutline;
  final bool isActive;
  final bool? autoExpendedWidth;
  late Color? color;

  late BorderSide _borderSide;
  late Color _textColor;
  late double? textSize;

  ButtonWidget.primary({
    Key? key,
    this.isActive = true,
    this.autoExpendedWidth = false,
    this.isOutline = false,
    this.onPress,
    this.title,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
    this.width,
    this.height,
    this.color,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutline) {
      color = AppColor.primaryColor;
      _borderSide = BorderSide(
          color: _isUnActive() ? AppColor.hindColor : AppColor.textHideColor,
          style: BorderStyle.solid);
      _textColor = _isUnActive() ? AppColor.hindColor : AppColor.textHideColor;
    } else {
      color = color;
      _borderSide = BorderSide.none;
      _textColor = AppColor.white;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(
          (autoExpendedWidth! ? null : width ?? MediaQuery.of(context).size.width * 2 / 3)!,
          height ?? ButtonWidgetConstants.buttonHeight,
        ),
        elevation: 0,
        primary: color ?? AppColor.lightPurple,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ButtonWidgetConstants.roundedButtonRadius,
            ),
            side: _borderSide),
      ),
      onPressed: onPress,
      child: Text(
        title!,
        textAlign: TextAlign.center,
        style: ThemeText.getDefaultTextTheme()
            .button!
            .copyWith(color: _textColor, fontSize: textSize ?? 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  bool _isUnActive() => onPress == null || !isActive;
}
