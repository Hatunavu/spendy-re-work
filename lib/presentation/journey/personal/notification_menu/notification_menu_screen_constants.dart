import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class NotificationMenuScreenConstants {
  static String textTitle = translate('label.notification');
  static String textEnableNotification = translate('label.enable_notification');
  static String cameraPermission = translate('label.camera_permission');
  static String cameraPerContent =
      translate('label.this_app_needs_camera_permission_to_open_camera');
  static String galleryPermission = translate('label.gallery_permission');
  static String galleryPerContent =
      translate('label.this_app_needs_gallery_permission_to_open_gallery');

  static double paddingLeft = 28.w;
  static double paddingTop = 18.h;
}
