import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_option/bloc/filter_event.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_option/filter_screen.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_result/bloc/filter_result_bloc.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_result/bloc/fliter_result_event.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_result/filter_result_screen.dart';

import 'filter_option/bloc/filter_bloc.dart';

class FilterRoutes {
  static Map<String, WidgetBuilder> getAll() {
    return {};
  }

  static Map<String, WidgetBuilder> getRoutesWithSettings(
      RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>;

    return {
      RouteList.filterResult: (context) {
        final filter = args[KeyConstants.filterKey];
        return BlocProvider(
          create: (_) => Injector.resolve<FilterResultBloc>()
            ..add(ListenToFilter(
                filter: filter,
                group: args[KeyConstants.groupKey],
                languageCode: Localizations.localeOf(context).languageCode)),
          child: FilterResultScreen(
            group: args[KeyConstants.groupKey],
          ),
        );
      },
      RouteList.filter: (context) {
        final args = settings.arguments as Map<String, dynamic>?;
        return BlocProvider(
            create: (_) => Injector.resolve<FilterBloc>()
              ..add(FilterInitialEvent(
                  languageCode: Localizations.localeOf(context).languageCode)),
            child: FilterScreen(
              group: args?[KeyConstants.groupKey],
            ));
      },
    };
  }
}
