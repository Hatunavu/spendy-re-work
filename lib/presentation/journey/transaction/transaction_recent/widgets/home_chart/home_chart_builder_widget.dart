import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendy_re_work/presentation/journey/transaction/transaction_recent/widgets/home_chart/chart_data_bloc/home_chart_data_bloc.dart';
import 'bloc/home_chart_bloc.dart';
import 'home_chart_container_widget.dart';

class HomeChartBuilderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeChartDataBloc, HomeChartDataState>(
        builder: (context, state) {
      return BlocProvider<HomeChartBloc>(
          create: (_) => HomeChartBloc(),
          child: HomeChartWidget(
            reportWeekMap: state.reportWeekMap,
            reportDailyMap: state.reportDailyMap,
            homeChartDataState: state,
            totalAmount: state is HomeChartDataLoaded ? state.totalAmount : 0,
          ));
    });
  }
}
