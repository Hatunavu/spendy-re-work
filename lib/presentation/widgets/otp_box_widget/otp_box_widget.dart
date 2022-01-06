import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/journey/login/login_verify_otp/verify_otp_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/widgets/otp_box_widget/widgets/pin_input_textfield/src/builder/color_builder.dart';
import 'package:spendy_re_work/presentation/widgets/otp_box_widget/widgets/pin_input_textfield/src/decoration/pin_decoration.dart';
import 'package:spendy_re_work/presentation/widgets/otp_box_widget/widgets/pin_input_textfield/src/widget/pin_widget.dart';
import 'otp_widget_constants.dart';
import 'widgets/otp_timer_widget.dart';

class OTPBoxWidget extends StatefulWidget {
  final int secondsNumber;
  final bool showOtpTimer;
  final Function? resendCallback;
  final Function(String otp, bool isTimerRunning)? validCodeCallback;
  final TextEditingController ctrlTextFieldOTP;

  OTPBoxWidget(
      {this.secondsNumber = 30,
      this.showOtpTimer = true,
      this.resendCallback,
      required this.ctrlTextFieldOTP,
      this.validCodeCallback})
      : assert(
            (showOtpTimer || resendCallback != null) &&
                validCodeCallback != null,
            '');

  @override
  _OTPBoxWidgetState createState() => _OTPBoxWidgetState();
}

class _OTPBoxWidgetState extends State<OTPBoxWidget> {
  late bool _isTimerRunning;
  late int _secondCounter;
  late Timer _timer;

  @override
  void initState() {
    _isTimerRunning = false;
    _secondCounter = widget.secondsNumber;
    if (widget.showOtpTimer && !_isTimerRunning) {
      _isTimerRunning = true;
      _updateProgress();
    }
    super.initState();
  }

  @override
  void dispose() {
    widget.ctrlTextFieldOTP.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = ThemeText.getDefaultTextTheme().bodyText1!.copyWith(
        fontSize: VerifyOtpConstant.fzTextField,
        color: AppColor.primaryDarkColor);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          PinInputTextFormField(
            controller: widget.ctrlTextFieldOTP,
            pinLength: OtpWidgetConstants.lengthCode,
            decoration: UnderlineDecoration(
                textStyle: textStyle,
                gapSpace: 12.w,
                colorBuilder: PinListenColorBuilder(
                    AppColor.primaryDarkColor, AppColor.primaryDarkColor),
                hintText: '------',
                hintTextStyle: textStyle),
            autoFocus: true,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.number,
            onChanged: (pin) {
              if (pin.length == OtpWidgetConstants.lengthCode) {
                widget.validCodeCallback!(pin, _isTimerRunning);
              }
            },
          ),
          SizedBox(
            height: OtpWidgetConstants.paddingBottomNumberField,
          ),
          OtpTimerWidget(
            isTimerRunning: _isTimerRunning,
            minute: _secondCounter ~/ 60,
            second: _secondCounter - (_secondCounter ~/ 60) * 60,
            onPressedResendButton: _onPressedResendButtonCb,
          )
        ],
      ),
    );
  }

  void _updateProgress() {
    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(oneSec, (Timer t) {
      _secondCounter -= 1;
      setState(() {
        if (_secondCounter == 0) {
          t.cancel();
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    _timer.cancel();
    setState(() {
      _secondCounter = widget.secondsNumber;
      _isTimerRunning = false;
    });
  }

  void _onPressedResendButtonCb() {
    if (!_isTimerRunning) {
      widget.resendCallback!();
      setState(() {
        _isTimerRunning = true;
      });
      _updateProgress();
    }
  }
}
