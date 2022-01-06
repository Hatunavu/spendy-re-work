import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spendy_re_work/domain/usecases/goal_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';

part 'bottom_tab_event.dart';

part 'bottom_tab_state.dart';

// @Singleton
class BottomTabBloc extends Bloc<BottomTabEvent, BottomTabState> {
  final GoalUseCase goalUseCase;
  final AuthenticationBloc authenticationBloc;

  BottomTabBloc({required this.goalUseCase, required this.authenticationBloc})
      : super(BottomTabInitial());

  @override
  Stream<BottomTabState> mapEventToState(
    BottomTabEvent event,
  ) async* {
    if (event is TabChangedEvent) {
      yield TabChangeState(event.index);
    }
  }
}
