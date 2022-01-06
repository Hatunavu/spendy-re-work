class DevicePinConstants {
  static int firstStep = 0;
  static const bool configPassCodeFailed = false;

  // UI
  static const double dotSize = 13;
  static const int timeAnimationButton = 80;
  static const double paddingAll = 8;
  static const double paddingBottomTextForgotPassword = 14;
  static const double fingerprintPictureSize = 116;

  // loading
  static const double loadingSize = 56.0;
  static const String fingerKey = 'title';
  static const String iconKey = 'icon';

  static const int limitEnterPin = 3;
}

enum AuthLocalType { face, fingerprint, iris, touchId }
