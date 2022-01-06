import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/presentation/journey/report/blocs/report_data_bloc/report_data_bloc.dart';
import 'package:spendy_re_work/presentation/journey/report/blocs/report_data_bloc/report_data_event.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_recent/widgets/home_chart/chart_data_bloc/home_chart_data_bloc.dart';
import 'package:spendy_re_work/presentation/journey/goal/goal_list/goal_list_bloc/goal_list_bloc.dart';
import 'package:spendy_re_work/presentation/journey/home/home_screen.dart';
import 'package:spendy_re_work/presentation/journey/home/notification/noti_bloc.dart';
import 'package:spendy_re_work/presentation/journey/home/notification/noti_event.dart';
import 'package:spendy_re_work/presentation/journey/home/notification/notification_screen.dart';
import 'blocs/bottom_tab_bloc/bottom_tab_bloc.dart';
import 'blocs/home_bloc/home_bloc.dart';

class HomeRoutes {
  static Map<String, WidgetBuilder> getAll() {
    return {};
  }

  static Map<String, WidgetBuilder> getRoutesWithSettings(RouteSettings settings) {
    return {
      RouteList.noti: (context) {
        final args = settings.arguments as Map<String, dynamic>;
        final goalListBloc = args[KeyConstants.blocArgKey];
        return MultiBlocProvider(
          providers: [
            BlocProvider<NotificationBloc>(
              create: (_) => Injector.resolve<NotificationBloc>()..add(NotiInitialEvent()),
            ),
            if (goalListBloc != null)
              BlocProvider<GoalListBloc>.value(
                value: goalListBloc,
              )
          ],
          child: NotiScreen(),
        );
      },
      RouteList.home: (context) {
        final args = settings.arguments as Map;

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => Injector.resolve<HomeBloc>()
                ..add(
                  InitialDataHome(context),
                ),
            ),
            BlocProvider<BottomTabBloc>.value(
              value: Injector.resolve<BottomTabBloc>()
                ..add(
                  TabChangedEvent(args[KeyConstants.tabIndexArg] ?? 0),
                ),
            ),
            BlocProvider<GoalListBloc>(
                create: (_) => Injector.resolve<GoalListBloc>()..add(GoalListInitialEvent())),
            BlocProvider<HomeChartDataBloc>(
              create: (_) => Injector.resolve<HomeChartDataBloc>()..add(ListenHomeChartDataEvent()),
            ),
            BlocProvider<ReportDataBloc>(
              create: (_) => Injector.resolve<ReportDataBloc>()
                ..add(ListenToReportEvent(
                  selectTime: DateTime.now(),
                )),
            ),
          ],
          child: HomeScreen(),
        );
      }
    };
  }
}
