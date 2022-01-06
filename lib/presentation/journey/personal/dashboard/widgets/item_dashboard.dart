import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';
import 'package:spendy_re_work/common/configs/configurations.dart';
import 'package:spendy_re_work/common/constants/list_item_setting_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/common/utils/device_utils.dart';
import 'package:spendy_re_work/common/utils/upgrade_app/upgrade_app.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/home/blocs/home_bloc/home_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/dashboard/personal_page_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/create_form/item_button_widget.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/app_dialog/app_dialog.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/rate_app_dialog/rate_app_dialog.dart';
import 'package:spendy_re_work/presentation/widgets/rate_my_app/core.dart';
import 'package:spendy_re_work/presentation/widgets/rate_my_app/dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuPersonal extends StatefulWidget {
  @override
  _MenuPersonalState createState() => _MenuPersonalState();
}

class _MenuPersonalState extends State<MenuPersonal> {
  late UserEntity _userEntity;
  late int _listLengthSetting;
  late HomeBloc _homeBloc;
  @override
  void initState() {
    rateMyApp.init();
    _userEntity = Injector.resolve<AuthenticationBloc>().userEntity;
    _listLengthSetting = ListItemPersonal.listItemPersonal.length;
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    super.initState();
  }

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 1,
    minLaunches: 5,
    remindDays: 7,
    remindLaunches: 5,
    googlePlayIdentifier: Configurations.androidID,
    appStoreIdentifier: Configurations.iosID,
  );
  Future<void> _callBackItemPersonal(int index, BuildContext context) async {
    final itemPersonal = ListItemPersonal.listItemPersonal[index];
    switch (itemPersonal.id) {
      case 0:
        return _onPressedCategory(context);
      case 1:
        return _onPressedGroup(context);
      case 2:
        return;
      case 3:
        return _onPressedNotification(context);
      case 4:
        return _onPressedSecurity(context);
      case 5:
        return _shareApp(context);
      case 6:
        return _onPressedHelpAndSupport(context);
      case 7:
        return _onPressedReview(context);
      case 8:
        return _onPressedPolicy(context);
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: PersonalPageConstants.paddingLeft,
      ),
      child: Column(
          children: List.generate(_listLengthSetting, (index) {
        final itemPersonal = ListItemPersonal.listItemPersonal[index];
        return ItemButtonWidget(
          widgetSuffix: itemPersonal.id == 2
              ? Text(
                  _userEntity.isoCode ?? '',
                  style: ThemeText.getDefaultTextTheme().textMenu,
                )
              : const Icon(
                  Icons.navigate_next,
                  color: AppColor.iconColorGrey,
                ),
          showLineBottom: index != _listLengthSetting - 1,
          onItemClick: () => _callBackItemPersonal(index, context),
          itemPersonalEntity: itemPersonal,
        );
      })),
    );
  }

  void _onPressedCategory(BuildContext context) =>
      Navigator.pushNamed(context, RouteList.categories);

  void _onPressedSecurity(BuildContext context) =>
      Navigator.pushNamed(context, RouteList.security);

  Future<void> _onPressedPolicy(BuildContext context) async {
    if (await canLaunch(PersonalPageConstants.urlPolicy)) {
      await launch(PersonalPageConstants.urlPolicy);
    } else {
      final Error error =
          ArgumentError('Could not launch ${PersonalPageConstants.urlPolicy}');
      throw error;
    }
  }

  void _onPressedReview(BuildContext context) {
    RateAppDialog.showRateApp(
        context: context,
        rateMyApp: rateMyApp,
        rate: () => _rateApp(context),
        noThanks: _noThanks,
        onDismissed: _onDismissed);

    /*LaunchReview.launch(
        androidAppId: Configurations.androidID, iOSAppId: Configurations.iosID);*/
  }

  Future<void> _onPressedHelpAndSupport(BuildContext context) async {
    final String deviceInfo = await Device.getInformation();
    final VersionStatus versionStatus = await NewVersion(
            context: context,
            androidId: Configurations.androidID,
            iOSId: Configurations.iosID)
        .getVersionStatus();

    String subject = PersonalPageConstants.mailSupportTitle;
    String body = '''
    
    
    
    
    --------------
    Please don't remove this technical info:
    $deviceInfo, app version: ${versionStatus.localVersion}''';

    if (Platform.isIOS) {
      subject = Uri.encodeComponent(subject);
      body = Uri.encodeComponent(body);
    }
    final String url = 'mailto:${PersonalPageConstants.mailSupport}'
        '?subject=$subject'
        '&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      await showDialog(
          context: context,
          builder: (context) {
            return AppDialog(
                title: 'Alert',
                rightButtonTitle: 'OK',
                content: Text(
                  'Could not launch',
                  style: ThemeText.getDefaultTextTheme()
                      .caption
                      ?.copyWith(color: AppColor.black),
                ),
                buttonTextSize: 14,
                haveLeftButton: false);
          });
    }
  }

  void _onPressedNotification(BuildContext context) =>
      Navigator.pushNamed(context, RouteList.notificationMenu);
  void _onPressedGroup(BuildContext context) =>
      Navigator.pushNamed(context, RouteList.group);
  void _shareApp(BuildContext context) {
    Share.share(PersonalPageConstants.shareAppMessage);
  }

  Future _rateApp(BuildContext context) async {
    await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
    Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.rate);
    _homeBloc.add(RateAppEvent(true));
  }

  Future _noThanks() async {
    await rateMyApp.callEvent(RateMyAppEventType.noButtonPressed);
    Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.no);
  }

  Future _onDismissed() async {
    await rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
  }
}
