import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/domain/entities/user/security_entity.dart';
import 'package:spendy_re_work/presentation/journey/personal/security_menu/bloc/security_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/security_menu/bloc/security_event.dart';
import 'package:spendy_re_work/presentation/journey/personal/security_menu/bloc/security_state.dart';
import 'package:spendy_re_work/presentation/journey/personal/security_menu/security_menu_screen_constants.dart';
import 'package:spendy_re_work/presentation/journey/personal/security_menu/widgets/switch_menu_item.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/primary_appbar.dart';
import 'package:spendy_re_work/common/extensions/biometric_type_extension.dart';

class SecurityMenuScreen extends StatelessWidget {
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
        title: SecurityMenuConstants.textTitle,
      ),
      body: Padding(
          padding: EdgeInsets.only(
              top: SecurityMenuConstants.paddingTop,
              left: SecurityMenuConstants.paddingLeft),
          child: BlocConsumer<SecurityBloc, SecurityState>(
            listener: (context, state) async {
              if (state is SecurityInitialState) {
                if (state.isPushToScreen && state.routeName.isNotEmpty) {
                  await pushToScreen(context,
                      settingsEntity: state.security,
                      routeName: state.routeName);
                }
              }
            },
            builder: (context, state) {
              if (state is SecurityInitialState) {
                return _buildListMenu(context, state.security,
                    biometricType: state.biometricType);
              }
              return Container(
                color: AppColor.white,
              );
            },
          )),
    );
  }

  Widget _buildListMenu(BuildContext context, SecurityEntity userSettings,
      {BiometricType? biometricType}) {
    return Column(
      children: [
        SwitchMenuItem(
            icon: IconConstants.passCodeIcon,
            title: SecurityMenuConstants.textPassCodeMenu,
            value: userSettings.isPin!,
            onChanged: (tick) =>
                _onPassCodeSwitchChanged(context, tick, userSettings),
            showBottomLine: true),
        Visibility(
          visible: biometricType != null,
          child: SwitchMenuItem(
            icon: biometricType!.icon,
            title: biometricType.name,
            value: userSettings.isBio!,
            onChanged: (tick) =>
                _onFaceIdSwitchChanged(context, tick, userSettings),
          ),
        ),
      ],
    );
  }

  void _onPassCodeSwitchChanged(
      BuildContext context, bool tick, SecurityEntity userSettings) {
    BlocProvider.of<SecurityBloc>(context).add(SecuritySwitchEvent(
        security: SecurityEntity(isPin: tick, isBio: userSettings.isBio)));
  }

  void _onFaceIdSwitchChanged(
      BuildContext context, bool tick, SecurityEntity userSettings) {
    BlocProvider.of<SecurityBloc>(context).add(SecuritySwitchEvent(
        security: SecurityEntity(isPin: userSettings.isPin, isBio: tick)));
  }

  Future<void> pushToScreen(BuildContext context,
      {SecurityEntity? settingsEntity, String? routeName}) async {
    if (routeName == RouteList.createDevicePIN) {
      final configPassCode = await Navigator.pushNamed(context, routeName!,
          arguments: {KeyConstants.userSettingsKey: settingsEntity});
      if (configPassCode == null || configPassCode == false) {
        BlocProvider.of<SecurityBloc>(context)
            .add(ConfigUserSettingsFailedEvent());
      }
    } else {
      if (settingsEntity!.isPin!) {
        final configPassCode =
            await Navigator.pushNamed(context, routeName!, arguments: {
          KeyConstants.argPreviousRouteKey: RouteList.security,
          KeyConstants.userSettingsKey: settingsEntity
        });
        if (configPassCode == null || configPassCode == false) {
          BlocProvider.of<SecurityBloc>(context)
              .add(ConfigUserSettingsFailedEvent());
        }
      } else if (settingsEntity.isBio == false) {
        final configPassCode =
            await Navigator.pushNamed(context, routeName!, arguments: {
          KeyConstants.argPreviousRouteKey: RouteList.security,
          KeyConstants.userSettingsKey: settingsEntity,
          SecurityMenuConstants.deletePassCodeKey:
              SecurityMenuConstants.isDeletePassCode
        });
        if (configPassCode == null || configPassCode == false) {
          BlocProvider.of<SecurityBloc>(context)
              .add(ConfigUserSettingsFailedEvent());
        }
      }
    }
  }
}
