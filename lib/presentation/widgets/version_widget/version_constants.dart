import 'package:flutter_translate/flutter_translate.dart';
import 'package:package_info/package_info.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class VersionConstants {
  // Padding
  static double paddingBottom = 85.h;

  // Font size
  static double fzVersion = 15.sp;

  // Multiple language
  static String textVersion = translate('label.version');
  static String defaultVersion = '$textVersion 1.0.0';
  static Future<String> getVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }
}
