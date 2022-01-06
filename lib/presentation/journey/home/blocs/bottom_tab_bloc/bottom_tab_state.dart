part of 'bottom_tab_bloc.dart';

abstract class BottomTabState extends Equatable {
  const BottomTabState();
}

class BottomTabInitial extends BottomTabState {
  @override
  List<Object> get props => [];
}

class TabChangeState extends BottomTabState {
  final int index;

  TabChangeState(this.index);

  @override
  List<Object> get props => [index];
}
