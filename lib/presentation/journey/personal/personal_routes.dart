import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/firebase_storage_constants.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/domain/usecases/categories_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/category_menu/blocs/list_category_bloc/list_category_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/category_menu/category_list_cate/category_list_screen.dart';
import 'package:spendy_re_work/presentation/journey/personal/category_menu/category_menu_screen_constants.dart';
import 'package:spendy_re_work/presentation/journey/personal/notification_menu/bloc/notify_settings_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/notification_menu/bloc/notify_settings_event.dart';
import 'package:spendy_re_work/presentation/journey/personal/payments/bloc/payments_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/payments/bloc/payments_event.dart';
import 'package:spendy_re_work/presentation/journey/personal/payments/payments_screen.dart';
import 'package:spendy_re_work/presentation/journey/personal/security_menu/bloc/security_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/security_menu/bloc/security_event.dart';
import 'package:spendy_re_work/presentation/journey/personal/security_menu/security_menu_screen.dart';

import '../../../common/constants/route_constants.dart';
import 'category_menu/category_menu_screen.dart';
import 'currency_menu/bloc/choose_currency_bloc.dart';
import 'currency_menu/currency_screen.dart';
import 'group_menu/group_menu_screen.dart';
import 'notification_menu/notification_menu_screen.dart';

class PersonalRoutes {
  static Map<String, WidgetBuilder> getAll() {
    return {
      RouteList.categories: (context) {
        return CategoriesMenuScreen();
      },
      RouteList.chooseCurrency: (context) {
        return BlocProvider(
            create: (_) => Injector.container<ChooseCurrencyBloc>()..add(FetchCurrencyEvent()),
            child: ChooseCurrencyScreen());
      },
      RouteList.security: (context) {
        return BlocProvider<SecurityBloc>(
            create: (_) => Injector.resolve<SecurityBloc>()..add(SecurityInitialEvent()),
            child: SecurityMenuScreen());
      },
      RouteList.notificationMenu: (context) {
        return BlocProvider<NotifySettingsBloc>(
            create: (_) => Injector.resolve<NotifySettingsBloc>()..add(NotifyInitialEvent()),
            child: NotificationMenuScreen());
      },
      RouteList.payments: (_) {
        return BlocProvider<PaymentsBloc>(
            create: (_) => Injector.resolve<PaymentsBloc>()..add(InitialPaymentsEvent()),
            child: const PaymentsScreen());
      },
      RouteList.group: (_) {
        return const GroupMenuScreen();
      }
    };
  }

  static Map<String, WidgetBuilder> getRoutesWithSettings(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>;

    return {
      RouteList.categoriesList: (context) {
        final categoryType = args[KeyConstants.categoryTypeKey];
        return BlocProvider<ListCategoryBloc>(
            create: (_) => ListCategoryBloc(
                Injector.resolve<CategoriesUseCase>(), Injector.resolve<AuthenticationBloc>())
              ..add(FetchListCategory(categoryType: categoryType)),
            child: CategoryListScreen(
              title: categoryType == FirebaseStorageConstants.transactionType
                  ? CategoriesMenuScreenConstant.textExpense
                  : CategoriesMenuScreenConstant.textGoal,
            ));
      },
    };
  }
}
