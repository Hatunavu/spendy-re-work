import 'package:equatable/equatable.dart';

abstract class EventBusState extends Equatable {}

class EventBusInitState extends EventBusState {
  @override
  List<Object?> get props => [];
}

class EventBusLoadingState extends EventBusState {
  @override
  List<Object?> get props => [];
}

class RefreshParticipantInTransactionState extends EventBusState {
  @override
  List<Object?> get props => [];
}
