import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spendy_re_work/presentation/journey/personal/notification_menu/notification_menu_screen_constants.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/permission_dialog/permission_dialog.dart';

class PermissionHelpers {
  static Future<bool> isPermissionGranted(Permission permission) async {
    final status = await permission.request();
    return status.isGranted || status.isLimited;
  }

  /// Open App Setting, when re-apply some permission
  static Future<bool> openDeviceSettings({Permission? permission}) => openAppSettings();

  static Future<PermissionStatus> check(Permission permission) => permission.status;

  static Future<PermissionStatus> request(Permission permission) => permission.request();

  static Future<bool> requestPhotoPermission(BuildContext context) async {
    final _isShown = await Permission.storage.shouldShowRequestRationale;
    final _status =
        await (Platform.isAndroid ? check(Permission.storage) : check(Permission.photos));
    if (_status.isGranted) {
      return true;
    }
    if (_status.isPermanentlyDenied || _isShown) {
      await showDialog(
        context: context,
        builder: (_) => PermissionDialog(
          title: NotificationMenuScreenConstants.galleryPermission,
          content: NotificationMenuScreenConstants.galleryPerContent,
          onPressedSetting: () {
            Navigator.of(context).pop();
            openAppSettings();
          },
        ),
      );
      return false;
    }
    final _result =
        await (Platform.isAndroid ? request(Permission.storage) : request(Permission.photos));
    if (_result.isGranted) {
      return true;
    }
    return false;
  }

  static Future<bool> requestCameraPermission(BuildContext context) async {
    final _isShown = await Permission.camera.shouldShowRequestRationale;
    final _status = await check(Permission.camera);
    if (_status.isGranted) {
      return true;
    }
    if (_status.isPermanentlyDenied || _isShown) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => PermissionDialog(
          title: NotificationMenuScreenConstants.cameraPermission,
          content: NotificationMenuScreenConstants.cameraPerContent,
          onPressedSetting: () {
            Navigator.of(context).pop();
            openAppSettings();
          },
        ),
      );
      return false;
    }
    final _result = await request(Permission.camera);
    if (_result.isGranted) {
      return true;
    }
    return false;
  }
}
