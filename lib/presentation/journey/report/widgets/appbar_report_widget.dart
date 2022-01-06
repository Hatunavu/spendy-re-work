import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/presentation/journey/report/blocs/report_navigator_bloc/report_navigator_bloc.dart';
import 'package:spendy_re_work/presentation/journey/report/report_page_constants.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/appbar_constants.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/appbar_widget.dart';

import 'navigator_bar.dart';

class AppbarReportWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final Function(DateTime) reportChartCallback;

  const AppbarReportWidget({Key? key, required this.reportChartCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return AppBar(
    //   title: BlocProvider<ReportNavigatorBloc>(
    //       create: (_) => ReportNavigatorBloc(
    //           reportBloc: BlocProvider.of<ReportBloc>(context)),
    //       child: ReportNavigatorWidget()),
    //   centerTitle: true,
    // );
    return AppBarWidget(
      title: ReportPageConstants.titleReport,
      actions: [
        BlocProvider<ReportNavigatorBloc>(
            create: (_) => ReportNavigatorBloc(),
            child: ReportNavigatorWidget(
              reportChartCallBack: reportChartCallback,
            )),
      ],
    );
  }

  @override
  Size get preferredSize => AppbarConstants.heightAppbar;
}
