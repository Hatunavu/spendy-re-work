import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:spendy_re_work/common/injector/injector_config.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'common/configs/remote_config_default.dart';
import 'common/firebase_setup.dart';
import 'common/i18n/language_constants.dart';
import 'common/injector/injector.dart';
import 'common/local_preferences/local_preferences.dart';
import 'presentation/app.dart';

Future main() async {
  // init some default data
  InjectorConfig.setup();
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  final delegate = await LocalizationDelegate.create(
    fallbackLocale: LanguageConstants.en,
    supportedLocales: [LanguageConstants.en, LanguageConstants.vi],
  );
  final setupFirebaseDB = Injector.resolve<SetupFirebaseDatabase>();
  await setupFirebaseDB.init();
  final remoteConfigDefault = Injector.resolve<RemoteConfigDefault>();
  await remoteConfigDefault.initialApp();
  final localPreferences = Injector.resolve<LocalPreferences>();
  await localPreferences.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  return runApp(LocalizedApp(
      delegate,
      App(
        authenticationBloc: Injector.resolve<AuthenticationBloc>(),
      )));
}
