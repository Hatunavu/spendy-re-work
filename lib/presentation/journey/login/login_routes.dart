import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/presentation/journey/login/device_pin/enter_pin/enter_pin_screen.dart';
import 'package:spendy_re_work/presentation/journey/login/login_verify_otp/verify_otp_screen.dart';
import 'package:spendy_re_work/presentation/journey/login/profile/bloc/profile_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/profile/create_profile_screen.dart';
import 'package:spendy_re_work/presentation/journey/personal/security_menu/security_menu_screen_constants.dart';
import 'package:spendy_re_work/presentation/widgets/otp_box_widget/bloc/otp_box_bloc.dart';

import 'device_pin/create_pin/bloc/create_pin_bloc.dart';
import 'device_pin/create_pin/create_pin_screen.dart';
import 'device_pin/enter_pin/bloc/enter_pin_bloc.dart';
import 'login_phone_number/login_phone_num_screen.dart';
import 'login_verify_otp/verify_otp_constants.dart';

class LoginRoutes {
  static Map<String, WidgetBuilder> getAll() {
    return {
      RouteList.loginPhone: (context) => LoginPhoneNumberScreen(),
    };
  }

  static Map<String, WidgetBuilder> getRoutesWithSettings(
      RouteSettings settings) {
    // final args = settings.arguments as Map<String, dynamic>;

    return {
      RouteList.loginVerifyCode: (context) {
        final args = settings.arguments as Map<String, dynamic>;
        final phone = args[VerifyOtpConstant.keyArgPhone];
        final phoneCode = args[VerifyOtpConstant.keyArgPhoneCode];
        final id = args[VerifyOtpConstant.keyArgVerifyId];
        return BlocProvider(
          create: (_) => OtpBoxBloc(),
          child: VerifyOTPScreen(phone, id, phoneCode),
        );
      },
      RouteList.createDevicePIN: (context) {
        final args = settings.arguments as Map<String, dynamic>;
        return BlocProvider(
            create: (_) => Injector.resolve<CreatePinBloc>(),
            child: CreatePINScreen(
                settingsEntity: args[KeyConstants.userSettingsKey]));
      },
      RouteList.enterPIN: (context) {
        final args = settings.arguments as Map<String, dynamic>;

        final isDeletePassCode = args[SecurityMenuConstants.deletePassCodeKey];
        final previousRoute = args[KeyConstants.argPreviousRouteKey];
        final userSettings = args[KeyConstants.userSettingsKey];

        return BlocProvider(
            create: (_) => Injector.resolve<EnterPinBloc>()
              ..add(EnterPinInitialEvent(previousRoute: previousRoute)),
            child: EnterPINScreen(
                previousRoute: previousRoute,
                newSettings: userSettings,
                isDeletePassCode: isDeletePassCode));
      },
      RouteList.createProfile: (context) {
        return BlocProvider(
          create: (_) => Injector.resolve<ProfileBloc>(),
          child: CreateProfileScreen(),
        );
      }
    };
  }
}
