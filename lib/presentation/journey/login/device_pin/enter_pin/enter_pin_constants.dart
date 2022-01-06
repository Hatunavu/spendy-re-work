import 'package:flutter_translate/flutter_translate.dart';

class EnterPINConstants {
  static const int limitTryTimes = 5;
  static const int debounceMilliseconds = 500;

// Multiple language
  static const String confirmPinKey = 'confirm_pin_key';

  static String textWrong(int limitTimes) {
    return 'You only have $limitTimes more times to try';
  }

  static String textOk = translate('label.ok');
  static String textTitleAlert = translate('label.notification');
  static String textOverTryTimesAlert =
      translate('label.text_over_try_times_alert');
  static String textEnterPIN = translate('label.text_enter_pin');
}
