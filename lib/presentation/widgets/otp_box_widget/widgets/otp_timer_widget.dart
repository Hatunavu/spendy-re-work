import 'package:flutter/material.dart';

import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget.dart';
import '../otp_widget_constants.dart';
import 'package:spendy_re_work/common/extensions/num_extensions.dart';

class OtpTimerWidget extends StatelessWidget {
  OtpTimerWidget({
    Key? key,
    required this.isTimerRunning,
    required this.onPressedResendButton,
    this.minute,
    this.second,
  }) : super(key: key);

  // bool? _isTimerRunning;
  // int? _second;
  // int? _minute;
  // Function()? _onPressedResendButton;
  final bool? isTimerRunning;
  final int? second;
  final int? minute;
  final Function()? onPressedResendButton;

  @override
  Widget build(BuildContext context) {
    final bodyStyle = ThemeText.getDefaultTextTheme().bodyText1!.copyWith(
        fontSize: OtpWidgetConstants.fzBody, color: AppColor.textHintColor);
    final bodyBoldStyle = ThemeText.getDefaultTextTheme().bodyText1!.copyWith(
        fontSize: OtpWidgetConstants.fzBody,
        fontWeight: FontWeight.w600,
        color: AppColor.primaryDarkColor);

    return Column(
      children: [
        Text(
          OtpWidgetConstants.textDontReceive,
          style: bodyStyle,
        ),
        SizedBox(
          height: OtpWidgetConstants.resendPaddingTop,
        ),
        isTimerRunning!
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    OtpWidgetConstants.textResentTimer,
                    style: bodyBoldStyle,
                  ),
                  Text(
                    ' (${minute!.toStandardized}',
                    style: bodyBoldStyle,
                  ),
                  Text(
                    ':${second!.toStandardized})',
                    style: bodyBoldStyle,
                  )
                ],
              )
            : _resendButton(context),
      ],
    );
  }

  Widget _resendButton(BuildContext context) {
    return ButtonWidget.primary(
      //  key: const ValueKey(OtpWidgetConstants.resendBtnKey),
      onPress: onPressedResendButton!,
      title: OtpWidgetConstants.textResentButton,
    );
  }
}
