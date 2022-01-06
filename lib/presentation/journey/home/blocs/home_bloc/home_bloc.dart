import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spendy_re_work/common/configs/configurations.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/constants/shared_preference_keys_constants.dart';
import 'package:spendy_re_work/common/local_preferences/local_preferences.dart';
import 'package:spendy_re_work/common/utils/permission_helpers.dart';
import 'package:spendy_re_work/common/utils/upgrade_app/upgrade_app.dart';
import 'package:spendy_re_work/data/model/notification/push_notification_data_model.dart';
import 'package:spendy_re_work/domain/entities/user/setting_entity.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
import 'package:spendy_re_work/domain/usecases/currency_usecase.dart';
import 'package:spendy_re_work/domain/usecases/home_usecase.dart';
import 'package:spendy_re_work/domain/usecases/local_notification_usecase.dart';
import 'package:spendy_re_work/domain/usecases/noti_usecase.dart';
import 'package:spendy_re_work/domain/usecases/profile_user_usecase.dart';
import 'package:spendy_re_work/domain/usecases/settle_debt_usecase.dart';
import 'package:spendy_re_work/presentation/app.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/home/blocs/bottom_tab_bloc/bottom_tab_bloc.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthenticationBloc authenticationBloc;
  final NotificationUseCase notificationUseCase;
  final SettleDebtUseCase settleDebtUseCase;
  final HomeUseCase homeUseCase;
  final CurrencyUseCase currencyUseCase;
  final LocalNotificationUseCase localNotificationUseCase;
  final BottomTabBloc bottomTabBloc;
  final LocalPreferences localPreferences;
  final ProfileUserUseCase profileUserUseCase;

  final bool _isForceUpdate = false;
  int platformDelay = 0;
  UserEntity? _profile;

  HomeBloc(
      {required this.authenticationBloc,
      required this.settleDebtUseCase,
      required this.homeUseCase,
      required this.currencyUseCase,
      required this.localNotificationUseCase,
      required this.bottomTabBloc,
      required this.notificationUseCase,
      required this.localPreferences,
      required this.profileUserUseCase})
      : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    switch (event.runtimeType) {
      case InitialDataHome:
        yield* _mapInitialDataHomeEventToState(event as InitialDataHome);
        break;
      case OnResumeEvent:
        _mapOnResumeEventToState(event as OnResumeEvent);
        break;
      case RateAppEvent:
        yield* _mapRateAppEventToState(event as RateAppEvent);
    }
  }

  Stream<HomeState> _mapRateAppEventToState(RateAppEvent event) async* {
    _profile = _profile?.update(rateApp: event.rate);
    await profileUserUseCase.updateProfile(_profile!);
  }

  Stream<HomeState> _mapInitialDataHomeEventToState(InitialDataHome event) async* {
    yield HomeLoaded();
    final user = authenticationBloc.userEntity;
    if (user.uid == null) {
      return;
    }
    platformDelay = Platform.isIOS ? 5 : 0;
    await Future.delayed(Duration(seconds: platformDelay), () {
      _showUpdateDialogIfNecessary(event.context);
    });
    _profile = await profileUserUseCase.getUserProfile(user.uid!);
    if (!_profile!.rateApp) {
      final int rateCount = localPreferences.get(SharedPreferenceKeys.rateAppKey) ?? 0;
      if (rateCount % 5 == 0 && rateCount != 0) {
        yield HomeLoaded(showRate: true);
      } else {
        yield HomeLoaded();
      }
      await localPreferences.set(SharedPreferenceKeys.rateAppKey, rateCount + 1);
    } else {
      yield HomeLoaded();
    }
    await _setupLocalNotification();
  }

  Future<void> _setupLocalNotification() async {
    await Future.delayed(Duration(seconds: platformDelay));
    final user = authenticationBloc.userEntity;
    if (user.uid == null) {
      return;
    }
    final UserEntity? userEntity = await profileUserUseCase.getUserProfile(user.uid!);
    bool? notify = userEntity?.setting?.notification ?? false;
    await localNotificationUseCase.initLocalNotification(
      selectNotification: (String? payload) async {
        final String? uid = authenticationBloc.authenticationUseCase.getUid();
        if (uid != null) {
          final pushNotificationData = PushNotificationDataModel.fromRawJson(payload!);
          if (pushNotificationData.routeTo == RouteList.noti) {
            await App.navigator.currentState!.pushNamed(RouteList.noti);
          } else {
            await App.navigator.currentState!.pushReplacementNamed(RouteList.home);
          }
        }
      },
    );
    final bool checkNotificationPermission =
        await PermissionHelpers.isPermissionGranted(Permission.notification);
    if (checkNotificationPermission && !notify) {
      notify = true;
    } else if (!checkNotificationPermission && notify) {
      notify = false;
    }
    userEntity?.update(
        setting: SettingEntity(notification: notify, security: userEntity.setting?.security));
    await profileUserUseCase.updateProfile(userEntity!);

    // setup notification

    if (notify) {
      await localNotificationUseCase.setUpAllNotification(user.uid!);
    }
  }

  void _mapOnResumeEventToState(OnResumeEvent event) {
    if (_isForceUpdate) {
      _showUpdateDialogIfNecessary(event.context);
    }
  }

  void _showUpdateDialogIfNecessary(BuildContext context) {
    NewVersion(
            context: context,
            androidId: Configurations.androidID,
            iOSId: Configurations.iosID,
            dismissText: translate('label.dismiss_text'),
            updateText: translate('label.update_text'),
            dialogTitle: translate('label.dialog_title'),
            dialogText: translate('label.update_dialog_text'),
            optionalDialogText: translate('label.optional_update_dialog_text'),
            isForceUpdate: _isForceUpdate)
        .showAlertIfNecessary();
  }
}
