import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/column_chart_value_type_constants.dart';
import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_recent/widgets/home_chart/chart_data_bloc/home_chart_data_bloc.dart';
import 'package:spendy_re_work/presentation/widgets/pageview_indicator/shape.dart';
import 'package:spendy_re_work/presentation/widgets/skeleton_widget/chart_skeleton_widget.dart';

import '../../transaction_recent_constants.dart';
import 'bloc/home_chart_bloc.dart';
import 'home_chart_page_view_widget.dart';

class HomeChartWidget extends StatefulWidget {
  final Map<int, int>? reportDailyMap;
  final Map<int, int>? reportWeekMap;
  final HomeChartDataState? homeChartDataState;
  final int? totalAmount;

  HomeChartWidget(
      {this.reportWeekMap,
      this.reportDailyMap,
      this.homeChartDataState,
      this.totalAmount});

  @override
  _HomeChartWidgetState createState() => _HomeChartWidgetState();
}

class _HomeChartWidgetState extends State<HomeChartWidget> {
  final circleShape = Shape(
    size: 8,
    shape: DotShape.circle,
    spacing: 6,
  );

  final PageController _controller = PageController();

  Widget? _chartSkeletonWidget;
  double? chartHeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    chartHeight = MediaQuery.of(context).size.height * 0.33;
    _chartSkeletonWidget = Padding(
      padding: TransactionRecentConstants.paddingChartPage,
      child: ChartSkeletonWidget(
        chartHeight!,
      ),
    );
    return BlocBuilder<HomeChartBloc, HomeChartState>(
        builder: (context, state) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: chartHeight,
            child: PageView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                scrollDirection: Axis.horizontal,
                controller: _controller,
                children: _chartWidget(widget.homeChartDataState!,
                    listTypeName: state.listTypeName)),
          ),
          // buildExampleIndicatorWithShapeAndBottomPos(circleShape),
        ],
      );
    });
  }

  List<Widget> _chartWidget(HomeChartDataState state,
      {List<ColumnChartValueTypeEnum>? listTypeName}) {
    if (state.dataState == DataState.loading) {
      return [_chartSkeletonWidget!];
    }
    return [
      HomeChartPageViewWidget(
        title: TransactionRecentConstants.textTotal,
        reportWeekMap: widget.homeChartDataState!.reportWeekMap,
        reportDailyMap: widget.homeChartDataState!.reportDailyMap,
        index: 0,
        typeEnum: listTypeName![0],
        totalAmount: widget.totalAmount!,
      ),
    ];
  }
}
