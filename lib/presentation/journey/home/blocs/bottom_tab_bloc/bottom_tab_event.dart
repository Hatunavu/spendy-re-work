part of 'bottom_tab_bloc.dart';

abstract class BottomTabEvent extends Equatable {
  const BottomTabEvent();
}

class TabChangedEvent extends BottomTabEvent {
  final int index;

  TabChangedEvent(this.index);

  @override
  List<Object> get props => [index];
}
