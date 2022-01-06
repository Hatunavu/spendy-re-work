part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class HomeFailureDialogState extends HomeState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class HomeFailure extends HomeState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class HomeLoaded extends HomeState {
  final bool showRate;

  HomeLoaded({this.showRate = false});
  @override
  List<Object> get props => [showRate];
}
