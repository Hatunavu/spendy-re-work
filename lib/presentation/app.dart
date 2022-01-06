import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/enums/auth_pincode_permission.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/common/navigation/lifecycle_event_handler.dart';
import 'package:spendy_re_work/common/utils/screen_utils.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/language_bloc/bloc.dart';
import 'package:spendy_re_work/presentation/bloc/loader_bloc/bloc.dart';
import 'package:spendy_re_work/presentation/bloc/notification_manager_bloc/notification_manager_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/snackbar_bloc/bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/blocs/login_bloc/login_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/blocs/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_bloc.dart';
import 'package:spendy_re_work/presentation/routes.dart';
import 'package:spendy_re_work/presentation/theme/theme_data.dart';
import 'package:spendy_re_work/presentation/widgets/loading_widget/loading_widget.dart';
import 'package:spendy_re_work/presentation/widgets/screen_size/screen_init.dart';
import 'package:spendy_re_work/presentation/widgets/snackbar_widget/snackbar_widget.dart';

import 'bloc/push_notification_bloc/push_notification_bloc.dart';
import 'bloc/snackbar_bloc/snackbar_type.dart';

class App extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;
  static final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

  App({required this.authenticationBloc});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  List<BlocProvider> _getProviders() => [
        BlocProvider<LanguageBloc>(
          create: (BuildContext context) =>
              Injector.resolve<LanguageBloc>()..add(LoadLanguageFromSharedPreferenceEvent()),
        ),
        BlocProvider<LoaderBloc>(create: (BuildContext context) => Injector.resolve<LoaderBloc>()),
        BlocProvider<AuthenticationBloc>(
            create: (BuildContext context) =>
                widget.authenticationBloc..add(AuthenticationStarted())),
        BlocProvider<LoginBloc>(create: (BuildContext context) => Injector.resolve<LoginBloc>()),
        BlocProvider<VerifyOtpBloc>(
            create: (BuildContext context) => Injector.resolve<VerifyOtpBloc>()),
        BlocProvider<SnackbarBloc>(create: (context) => Injector.resolve<SnackbarBloc>()),
        BlocProvider<PushNotificationBloc>(
            create: (BuildContext context) => Injector.container<PushNotificationBloc>()),
        BlocProvider<NotificationManagerBloc>(
            create: (BuildContext context) => Injector.container<NotificationManagerBloc>()),
        BlocProvider<GroupBloc>(create: (_) => Injector.resolve<GroupBloc>())
      ];

  /// ==== INITIAL SCREEN ====
  /// when have multi splash screen
  String get initialRoute {
    return RouteList.welcome;
  }

  /// ==== INIT LISTENER OF APPLICATION
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(LifecycleEventHandler(onPaused: _onPause));
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    final localizationDelegate = LocalizedApp.of(context).delegate;

    return MultiBlocProvider(
      providers: _getProviders(),
      child: BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
        if (state is StartAppState) {
          return Container();
        }
        return GestureDetector(
          onTap: () {
            // unFocus text field
            final FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          },
          child: ScreenInit(
            designSize: ScreenUtil.defaultSize,
            builder: () => MaterialApp(
              navigatorKey: App.navigator,
              builder: (context, widget) {
                return LoadingWidget(
                  key: const ValueKey('LoadingWidget'),
                  navigator: App.navigator,
                  child: _buildSnackBar(widget!, context),
                );
              },
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                localizationDelegate
              ],
              supportedLocales: localizationDelegate.supportedLocales,
              locale: localizationDelegate.currentLocale,
              title: 'Spendy',
              theme: appTheme(buildContext),
              initialRoute: initialRoute,
              onGenerateRoute: Routes.generateRoute,
              routes: Routes.getAll(),
            ),
          ),
        );
      }),
    );
  }

  Future<void> _onPause() async {
    // check settings and has pin -> show enter pin code screen
//    print('iOS: onPause');
    final security = widget.authenticationBloc.userEntity.setting?.security;
    final hasPin = widget.authenticationBloc.checkHasPin() ?? false;

    // get state of pin code screen -> handle for duplicate pin code screen
    final showing = await widget.authenticationBloc.checkPinAuthIsShowing();
    final isAuthPinEnable = widget.authenticationBloc.checkAuthPinCodeEnable();

    if (isAuthPinEnable) {
      // auth pin enable
      if ((security?.isPin ?? false) && hasPin && !showing) {
        await App.navigator.currentState!.pushNamed(
          RouteList.enterPIN,
        );
        await widget.authenticationBloc.savePinAuthState(true);
      }
    } else {
      widget.authenticationBloc.authPinCodePermission = AuthPinCodePermission.enable;
    }
  }

  BlocListener<SnackbarBloc, SnackbarState> _buildSnackBar(Widget child, BuildContext context) {
    return BlocListener<SnackbarBloc, SnackbarState>(
      listener: (context, state) {
        if (state is ShowSnackBarState) {
          TopSnackBar(
            title: state.title ?? '',
            key: state.key ?? const Key(''),
            type: state.type ?? SnackBarType.success,
          ).showWithNavigator(App.navigator.currentState ?? NavigatorState(), context);
        }
      },
      child: child,
    );
  }
}
