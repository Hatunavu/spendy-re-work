import 'dart:io';

class AdmobUtils {
  static bool adShow = false;

  static String get appId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6406955342054509~3006066358';
    }
    if (Platform.isIOS) {
      return 'ca-app-pub-6406955342054509~4510719714';
    }
    return '';
  }

  static String get bannerId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-6406955342054509/6739871158';///todo : Product Id
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    if (Platform.isIOS) {
      // return 'ca-app-pub-6406955342054509/7004676602';///todo : Product Id
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    return '';
  }

  static String get interstitialId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-6406955342054509/3232064508';///todo : Product Id
      return 'ca-app-pub-3940256099942544/1033173712';
    }
    if (Platform.isIOS) {
      // return 'ca-app-pub-6406955342054509/4305279507';///todo : Product Id
      return '	ca-app-pub-3940256099942544/4411468910';
    }
    return '';
  }
}
