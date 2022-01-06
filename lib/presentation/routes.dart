import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/domain/entities/goal_detail_entity.dart';
import 'package:spendy_re_work/presentation/journey/devmode/devmode_screen.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_routes.dart';
import 'package:spendy_re_work/presentation/journey/login/login_routes.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/group_menu_routes.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_routes.dart';
import 'package:spendy_re_work/presentation/journey/welcome/welcome_routes.dart';
import 'journey/goal/goal_routes.dart';
import 'journey/home/home_routes.dart';
import 'journey/login/device_pin/enter_pin/bloc/enter_pin_bloc.dart';
import 'journey/login/device_pin/enter_pin/enter_pin_screen.dart';
import 'journey/personal/personal_routes.dart';

class Routes {
  static Map<String, WidgetBuilder> _getCombinedRoutes() => {
        ...TransactionRoutes.getAll(),
        ...WelcomeRoutes.getAll(),
        ...LoginRoutes.getAll(),
        ...HomeRoutes.getAll(),
        ...PersonalRoutes.getAll(),
        ...FilterRoutes.getAll(),
//        ...GoalRoutes.getAll(),
        ...GroupMenuRoutes.getAll(),
        RouteList.devMode: (context) => DevModeScreen()
      };

  static Map<String, WidgetBuilder> getAll() => _getCombinedRoutes();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteList.loginVerifyCode:
      case RouteList.createDevicePIN:
      case RouteList.createProfile:
        return MaterialPageRoute(
            builder:
                LoginRoutes.getRoutesWithSettings(settings)[settings.name]!,
            settings: settings);
      case RouteList.enterPIN:
        if (settings.arguments != null) {
          return MaterialPageRoute(
              builder:
                  LoginRoutes.getRoutesWithSettings(settings)[settings.name]!,
              settings: settings);
        }
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                BlocProvider(
                    create: (_) => Injector.resolve<EnterPinBloc>()
                      ..add(EnterPinInitialEvent()),
                    child: EnterPINScreen()));
      case RouteList.categoriesList:
        return MaterialPageRoute(
            builder:
                PersonalRoutes.getRoutesWithSettings(settings)[settings.name]!,
            settings: settings);
      case RouteList.addGoal:
        return MaterialPageRoute<GoalDetailEntity>(
            builder:
                GoalRoutes.getRoutesWithSettings(settings)![settings.name]!,
            settings: settings);
      case RouteList.personalExpense:
      case RouteList.whoPaid:
      case RouteList.forWho:
      case RouteList.showImage:
      case RouteList.showItemImage:
      case RouteList.debt:
        return MaterialPageRoute(
            builder: TransactionRoutes.getRoutesWithSettings(
                settings)[settings.name]!,
            settings: settings);
      case RouteList.noti:
      case RouteList.home:
        return MaterialPageRoute(
            builder: HomeRoutes.getRoutesWithSettings(settings)[settings.name]!,
            settings: settings);
      case RouteList.filterResult:
        return MaterialPageRoute(
            builder:
                FilterRoutes.getRoutesWithSettings(settings)[settings.name]!,
            settings: settings);
      case RouteList.createGroup:
        return MaterialPageRoute(
            builder:
                GroupMenuRoutes.getRoutesWithSettings(settings)[settings.name]!,
            settings: settings);
      case RouteList.selectGroup:
        return MaterialPageRoute(
            builder: TransactionRoutes.getRoutesWithSettings(
                settings)[settings.name]!);
      case RouteList.transactionList:
        return MaterialPageRoute(
            builder: TransactionRoutes.getRoutesWithSettings(
                settings)[settings.name]!);
      case RouteList.search:
        return MaterialPageRoute(
            builder: TransactionRoutes.getRoutesWithSettings(
                settings)[settings.name]!);
      case RouteList.filter:
        return MaterialPageRoute(
            builder:
                FilterRoutes.getRoutesWithSettings(settings)[settings.name]!);
    }
  }
}
