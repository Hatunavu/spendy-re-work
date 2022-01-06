import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/presentation/journey/goal/goal_list/goal_page.dart';
import 'package:spendy_re_work/presentation/journey/home/blocs/bottom_tab_bloc/bottom_tab_bloc.dart';
import 'package:spendy_re_work/presentation/journey/home/notification/notification_constants.dart';
import 'package:spendy_re_work/presentation/journey/personal/dashboard/personal_page.dart';
import 'package:spendy_re_work/presentation/journey/report/report_page.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_recent/transaction_recent_page.dart';

import '../home_screen_constants.dart';

class PagesViewHome extends StatefulWidget {
  @override
  _PagesViewHomeState createState() => _PagesViewHomeState();
}

class _PagesViewHomeState extends State<PagesViewHome> {
  int _indexTab = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomTabBloc, BottomTabState>(
        builder: (context, state) {
      if (state is BottomTabInitial) {
        _indexTab = 0;
      } else if (state is TabChangeState) {
        _indexTab = state.index;
      }
      return Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _indexTab,
              children: [
                TransactionRecentPage(
                  notiPushToScreen: (values) => _pushToScreen(context, values),
                ),
                GoalPage(),
                ReportPage(),
                PersonalPage()
              ],
            ),
          ),
          SizedBox(
            height: HomeScreenConstants.heightTab,
          )
        ],
      );
    });
  }

  void _pushToScreen(BuildContext context, List<String> values) {
    if (values[0] == NotificationConstants.spentType ||
        values[0] == NotificationConstants.debtType) {
      BlocProvider.of<BottomTabBloc>(context).add(TabChangedEvent(2));
    }
  }
}
