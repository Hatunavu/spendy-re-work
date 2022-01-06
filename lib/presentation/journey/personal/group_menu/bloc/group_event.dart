import 'package:equatable/equatable.dart';

abstract class GroupEvent extends Equatable {}

class GroupInitEvent extends GroupEvent {
  @override
  List<Object?> get props => [];
}

class GroupRefreshEvent extends GroupEvent {
  @override
  List<Object?> get props => [];
}

class GroupDeleteEvent extends GroupEvent {
  final String? id;

  GroupDeleteEvent({
    this.id,
  });
  @override
  List<Object?> get props => [
        id,
      ];
}
