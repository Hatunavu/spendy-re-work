part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class GetDataHome extends HomeEvent {
  @override
  List<Object> get props => [];
}

class InitialDataHome extends HomeEvent {
  final BuildContext context;

  InitialDataHome(this.context);

  @override
  List<Object> get props => [context];
}

class OnResumeEvent extends HomeEvent {
  final BuildContext context;

  OnResumeEvent(this.context);

  @override
  List<Object> get props => [context];
}

class ListenLocalNotificationEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class RateAppEvent extends HomeEvent {
  final bool rate;

  RateAppEvent(this.rate);

  @override
  List<Object> get props => [rate];
}
