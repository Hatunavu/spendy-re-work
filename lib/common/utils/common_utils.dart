import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spendy_re_work/common/utils/permission_helpers.dart';

class CommonUtils {
  static Future<File?> getImageFromSources(
    ImageSource imageSourceType,
    bool cropImage,
  ) async {
    if ((imageSourceType == ImageSource.gallery) &&
        !(await PermissionHelpers.isPermissionGranted(Permission.photos))) {
      return null;
    }
    if ((imageSourceType == ImageSource.camera) &&
        !(await PermissionHelpers.isPermissionGranted(Permission.camera))) {
      return null;
    }
    final imageFile = await ImagePicker().pickImage(source: imageSourceType);
    //getImage(source: imageSourceType);
    if (imageFile != null) {
      return File(imageFile.path);
    }
    return null;
  }
}
