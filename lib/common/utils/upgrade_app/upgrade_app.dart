import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/app_dialog/app_dialog.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/dialog_constants.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';

/// Information about the app's current version, and the most recent version
/// available in the Apple App Store or Google Play Store.
class VersionStatus {
  /// True if the there is a more recent version of the app in the store.
  bool? canUpdate;

  /// The current version of the app.
  String? localVersion;

  /// The most recent version of the app in the store.
  String? storeVersion;

  /// A link to the app store page where the app can be updated.
  String? appStoreLink;

  VersionStatus({this.canUpdate, this.localVersion, this.storeVersion});
}

class NewVersion {
  /// This is required to check the user's platform and display alert dialogs.
  BuildContext? context;

  /// An optional value that can override the default packageName when
  /// attempting to reach the Google Play Store. This is useful if your app has
  /// a different package name in the Play Store for some reason.
  String? androidId;

  /// An optional value that can override the default packageName when
  /// attempting to reach the Apple App Store. This is useful if your app has
  /// a different package name in the App Store for some reason.
  String? iOSId;

  /// An optional value that can override the default callback to dismiss button
  VoidCallback? dismissAction;

  /// An optional value that can override the default text to alert,
  /// you can ${versionStatus.localVersion} to ${versionStatus.storeVersion}
  /// to determinate in the text a versions.
  String? dialogText;

  /// An optional value that can override the default title of alert dialog
  String? dialogTitle;

  /// An optional value that can override the default text of dismiss button
  String? dismissText;

  /// An optional value that can override the default text of update button
  String? updateText;

  bool? isForceUpdate;
  String? optionalDialogText;

  NewVersion(
      {this.androidId,
      this.iOSId,
      required this.context,
      this.dismissAction,
      this.dismissText: 'Maybe Later',
      this.updateText: 'Update',
      this.dialogText,
      this.dialogTitle: 'Update Available',
      this.isForceUpdate,
      this.optionalDialogText});

  /// This checks the version status, then displays a platform-specific alert
  /// with buttons to dismiss the update alert, or go to the app store.
  Future showAlertIfNecessary() async {
    final versionStatus = await getVersionStatus();
    if (versionStatus.canUpdate!) {
      await showUpdateDialog(versionStatus);
    }
  }

  /// This checks the version status and returns the information. This is useful
  /// if you want to display a custom alert, or use the information in a different
  /// way.
  Future<VersionStatus> getVersionStatus() async {
    final packageInfo = await PackageInfo.fromPlatform();
    VersionStatus versionStatus = VersionStatus(
      localVersion: packageInfo.version,
    );
    switch (Theme.of(context!).platform) {
      case TargetPlatform.android:
        final id = androidId ?? packageInfo.packageName;
        versionStatus = await _getAndroidStoreVersion(id, versionStatus);
        break;
      case TargetPlatform.iOS:
        final id = iOSId ?? packageInfo.packageName;
        versionStatus = await _getiOSStoreVersion(id, versionStatus);
        break;
      default:
    }

    ///CHECK VERSION null
    // if (versionStatus == null) {
    //   return null;
    // }
    versionStatus.canUpdate = checkCanUpdate(versionStatus);
    return versionStatus;
  }

  bool checkCanUpdate(VersionStatus versionStatus) {
    final localVersionNumber =
        versionStatus.localVersion!.replaceAll('.', '').toInt!; //1.0.1
    final storeVersionNumber =
        versionStatus.storeVersion!.replaceAll('.', '').toInt!; //1.0.2
    if (storeVersionNumber > localVersionNumber) {
      return true;
    }
    return false;
  }

  /// iOS info is fetched by using the iTunes lookup API, which returns a
  /// JSON document.
  Future _getiOSStoreVersion(String id, VersionStatus versionStatus) async {
    final String uriAppStore = 'https://itunes.apple.com/lookup?id=$id';
    final Uri urlAppStore = Uri.parse(uriAppStore);
    final response = await http.get(urlAppStore);
    if (response.statusCode != 200) {
      return null;
    }
    final jsonObj = json.decode(response.body);
    versionStatus
      ..storeVersion = jsonObj['results'][0]['version']
      ..appStoreLink = jsonObj['results'][0]['trackViewUrl'];
    return versionStatus;
  }

  /// Android info is fetched by parsing the html of the app store page.
  Future _getAndroidStoreVersion(String id, VersionStatus versionStatus) async {
    final String uriPlayStore =
        'https://play.google.com/store/apps/details?id=$id';
    final Uri urlPlayStore = Uri.parse(uriPlayStore);
    final response = await http.get(urlPlayStore);
    if (response.statusCode != 200) {
      return null;
    }
    final document = parse(response.body);
    final elements = document.getElementsByClassName('hAyfc');
    final versionElement = elements.firstWhere(
      (elm) => elm.querySelector('.BgcNfc')!.text == 'Current Version',
    );
    versionStatus
      ..storeVersion = versionElement.querySelector('.htlgb')!.text
      ..appStoreLink = uriPlayStore;
    return versionStatus;
  }

  /// Shows the user a platform-specific alert about the app update. The user
  /// can dismiss the alert or proceed to the app store.
  Future showUpdateDialog(VersionStatus versionStatus) async {
    final content = Padding(
      padding: const EdgeInsets.only(
        top: DialogConstants.spaceBetweenContentAndButton,
        right: DialogConstants.transactionDialogPadding,
      ),
      child: Text(
        isForceUpdate!
            ? dialogText!
            : optionalDialogText ??
                sprintf(translate('label.dialog_text'),
                    [versionStatus.localVersion, versionStatus.storeVersion]),
        style: ThemeText.getDefaultTextTheme().caption,
      ),
    );

    final dismissAction = this.dismissAction ??
        () => Navigator.of(context!, rootNavigator: true).pop();
    final updateText = this.updateText;
    final updateAction = () {
      _launchAppStore(versionStatus.appStoreLink!);
      Navigator.of(context!, rootNavigator: true).pop();
    };
    await showDialog(
      context: context!,
      barrierDismissible: !isForceUpdate!,
      builder: (BuildContext context) {
        return AppDialog(
            title: dialogTitle!,
            rightButtonTitle: updateText!,
            leftButtonTitle: dismissText!,
            content: content,
            rightAction: updateAction,
            leftAction: dismissAction,
            buttonTextSize: 16.sp,
            haveLeftButton: !isForceUpdate!);
      },
    );
  }

  /// Launches the Apple App Store or Google Play Store page for the app.
  Future _launchAppStore(String appStoreLink) async {
    if (await canLaunch(appStoreLink)) {
      await launch(appStoreLink);
    } else {
      throw ArgumentError('Could not launch appStoreLink');
    }
  }
}
