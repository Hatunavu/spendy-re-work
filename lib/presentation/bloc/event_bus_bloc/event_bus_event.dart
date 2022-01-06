import 'package:equatable/equatable.dart';

abstract class EventBusEvent extends Equatable {}

class RefreshParticipantInTransactionEvent extends EventBusEvent {
  @override
  List<Object?> get props => [];

}
