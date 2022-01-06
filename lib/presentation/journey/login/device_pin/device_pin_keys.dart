import 'package:flutter/material.dart';

class DevicePinKeys {
  static const ValueKey popupFingerPrintActiveKey =
      ValueKey('popup_fingerprint_active');
  // button
  static const String activeNowButton = 'login_CreatePinScreen_ActiveNow';
  static const String laterButton = 'login_CreatePinScreen_Later';
  static const ValueKey usePinButton = ValueKey('login_EnterPin_usePin');
  static const ValueKey cancelButton = ValueKey('login_EnterPin_Cancel');

  // text
  static const ValueKey laterTextKey = ValueKey('later_text');
  static const ValueKey activeNowTextKey = ValueKey('active_now_text');
  static const ValueKey titleTextKey = ValueKey('title_text');
  static const ValueKey subTitleTextKey = ValueKey('sub_title_text');

  // locked Screen
  static const String contactCustomer = 'lockedScreen_contactCustomer_button';
  static const String lockedTitle = 'login_lockedScreen_title';
  static const String lockedDescription = 'login_lockedScreen_description';
  static const String lockedrestore = 'login_lockedScreen_restore';
}
