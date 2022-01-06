import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget_constants.dart';

class ResetButton extends StatelessWidget {
  final Function()? onPress;
  final String? title;

  const ResetButton({Key? key, this.onPress, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: ButtonWidgetConstants.buttonHeight,
      minWidth: MediaQuery.of(context).size.width * 2 / 3,
      child: ElevatedButton(
        key: key,
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(
              Size(
                MediaQuery.of(context).size.width * 2 / 3,
                ButtonWidgetConstants.buttonHeight,
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(AppColor.white),
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(vertical: 8, horizontal: 25)),
            elevation: MaterialStateProperty.all<double>(0),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        ButtonWidgetConstants.roundedButtonRadius),
                    side: BorderSide(
                        color: onPress == null
                            ? AppColor.primaryAccentColor
                            : AppColor.primaryColor,
                        style: BorderStyle.solid)))),
        onPressed: onPress,
        child: Text(title ?? '',
            style: ThemeText.getDefaultTextTheme().button?.copyWith(
                color: onPress == null
                    ? AppColor.primaryAccentColor
                    : AppColor.primaryColor)),
      ),
    );
  }
}
