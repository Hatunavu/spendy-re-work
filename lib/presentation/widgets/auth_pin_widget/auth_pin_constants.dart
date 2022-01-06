import 'package:flutter/foundation.dart';

import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class AuthPinConstants {
  static const lengthPinCode = 6;

  static const String btnUsePassKey = 'authPin_UsePass';
  static const String btnFingerPrintKey = 'authPin_FingerPrint';
  static const String btnDeleteKey = 'authPin_Delete';
  static const String loadingPinCode = 'authPin_loading_pin_code';

  static const double scaleEmptySpaceTopPaddingRatio = 0.01;
  static const double defaultTopPaddingRatio = 0.04;
  static const double showPasswordButtonTopPaddingRatio = 0.05;
  static const double defaultTitlePaddingRatio = 0.015;
  static const double scaleEmptySpaceTitlePaddingRatio = 0.059;

  static double paddingTop = 148.h;
  static double paddingBottom = 65.h;
  static double fieldPINPaddingTop = 49.h;
  static double wrongTextPaddingTop = 22.h;
  static double keyboardPaddingTop = 127.h;

  static double fzTitle = 25.sp;

  static const double dotSize = 12;
  static const double btnNumberHeight = 66;
  static double fzTextDeleteButton = 20.sp;

  static const int timeAnimationButton = 80;
  static const int timeAnimationFirstStep = 0;
}

class AuthPinKeys {
  static const authPinHandleKey = ValueKey('auth_pin_code_handle');
  static const ValueKey authPinEmptyContainer =
      ValueKey('auth_pin_empty_container_key');
  static const authPinTitleKey = 'auth_pin_title';
  static const fingerFaceId = 'fingger_faceID';
}

class AuthPinLanguage {
  static const deleteButtonLabel = 'Delete';
}
