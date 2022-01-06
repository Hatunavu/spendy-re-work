import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spendy_re_work/common/constants/column_chart_value_type_constants.dart';

part 'home_chart_event.dart';

part 'home_chart_state.dart';

class HomeChartBloc extends Bloc<HomeChartEvent, HomeChartState> {
  HomeChartBloc()
      : super(HomeChartInitial(const [
          ColumnChartValueTypeEnum.daily,
          ColumnChartValueTypeEnum.daily
        ]));

  @override
  Stream<HomeChartState> mapEventToState(
    HomeChartEvent event,
  ) async* {
    if (event is ChangeExpenseTypeData) {
      final currentState = state;
      if (currentState is HomeChartInitial) {
        final newListType = state.listTypeName
          ..replaceRange(0, 1, [event.typeName]);
        yield currentState.copyWith(listTypeName: newListType);
      }
    } else if (event is ChangeOwedTypeData) {
      final currentState = state;
      if (currentState is HomeChartInitial) {
        final newListType = state.listTypeName
          ..replaceRange(1, 2, [event.typeName]);
        yield currentState.copyWith(listTypeName: newListType);
      }
    }
  }
}
