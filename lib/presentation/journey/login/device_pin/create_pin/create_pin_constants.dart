import 'package:flutter_translate/flutter_translate.dart';

class CreatePINScreenConstants {
  static const int firstStep = 0;
  static const int confirmStep = 1;

  // Keys
  static const createPinKey = 'create_pin_key';
  static const confirmPinKey = 'confirm_pin_key';
  static const confirmErrorPinKey = 'confirm_error_pin_key';

// Multiple language
  static String textCreate = translate('label.create_pass_code');
  static String textConfirm = translate('label.confirm_pass_code');
}
