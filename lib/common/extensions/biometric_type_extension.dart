import 'package:local_auth/local_auth.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/presentation/journey/personal/security_menu/security_menu_screen_constants.dart';

extension BiometricTypeExtension on BiometricType {
  String get name {
    switch (this) {
      case BiometricType.fingerprint:
        return SecurityMenuConstants.textFingerPrintMenu;
      case BiometricType.face:
        return SecurityMenuConstants.textFaceIDMenu;
      default:
        return '';
    }
  }

  String get icon {
    switch (this) {
      case BiometricType.fingerprint:
        return IconConstants.fingerPrintIcon;
      case BiometricType.face:
        return IconConstants.faceIDIcon;
      default:
        return '';
    }
  }
}
