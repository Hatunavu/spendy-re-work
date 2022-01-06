import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/enums/enable_permission.dart';
import 'package:spendy_re_work/common/utils/permission_helpers.dart';
import 'package:spendy_re_work/presentation/journey/personal/notification_menu/bloc/notify_settings_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/notification_menu/bloc/notify_settings_event.dart';
import 'package:spendy_re_work/presentation/journey/personal/notification_menu/bloc/notify_settings_state.dart';
import 'package:spendy_re_work/presentation/journey/personal/security_menu/widgets/switch_menu_item.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/primary_appbar.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/loader_dialog/loader_wallet_dialog.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/permission_dialog/permission_dialog.dart';

import 'notification_menu_screen_constants.dart';

class NotificationMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarNormalWidget(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            IconConstants.backIcon,
            width: LayoutConstants.dimen_18,
            height: LayoutConstants.dimen_18,
            color: AppColor.iconColor,
          ),
        ),
        title: NotificationMenuScreenConstants.textTitle,
      ),
      body: Padding(
          padding: EdgeInsets.only(
              top: NotificationMenuScreenConstants.paddingTop,
              left: NotificationMenuScreenConstants.paddingLeft),
          child: BlocConsumer<NotifySettingsBloc, NotifySettingsState>(
            listener: (context, state) {
              if (state is NotifySettingsLoadingState) {
                LoaderWalletDialog.getInstance().show(context);
              } else if (state is NotifySettingsInitialState) {
                if (state.permissionState == PermissionState.disable) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => PermissionDialog(
                      title: 'Notification Permission',
                      onPressedSetting: () => _onPressedSetting(context),
                      content: '',
                    ),
                  );
                }
              }
            },
            builder: (context, state) {
              if (state is NotifySettingsInitialState) {
                LoaderWalletDialog.getInstance().hide(context);
                return _buildListMenu(context, state.isEnableNotification!);
              }
              return Container(
                color: AppColor.white,
              );
            },
          )),
    );
  }

  Widget _buildListMenu(
    BuildContext context,
    bool notify,
  ) {
    return SwitchMenuItem(
      icon: IconConstants.notificationIcon,
      title: NotificationMenuScreenConstants.textEnableNotification,
      value: notify,
      onChanged: (tick) => _onNotificationSwitchChanged(context, tick),
    );
  }

  void _onNotificationSwitchChanged(
    BuildContext context,
    bool tick,
  ) {
    BlocProvider.of<NotifySettingsBloc>(context).add(NotifySwitchEvent(notify: tick));
  }

  Future<void> _onPressedSetting(BuildContext context) async {
    Navigator.of(context).pop();
    final bool flag =
        await PermissionHelpers.openDeviceSettings(permission: Permission.notification);
    log('NotificationMenuScreen - onPressedSetting - flag: $flag');
  }
}
