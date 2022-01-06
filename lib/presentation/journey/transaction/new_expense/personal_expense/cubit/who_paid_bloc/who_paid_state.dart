import 'package:equatable/equatable.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';

enum WhoPaidStatus { initial, loading, success, failed }

class WhoPaidState extends Equatable {
  final WhoPaidStatus status;
  final CurrencyEntity? currency;
  final List<ParticipantInTransactionEntity> participants;
  final List<ParticipantInTransactionEntity> whoPaidParticipants;
  final int amount;
  final GroupEntity? group;
  final DateTime updateAt;

  WhoPaidState(
      {required this.status,
      required this.participants,
      required this.whoPaidParticipants,
      required this.amount,
      this.group,
      this.currency,
      required this.updateAt});

  factory WhoPaidState.initial() => WhoPaidState(
      status: WhoPaidStatus.initial,
      participants: const [],
      amount: 0,
      whoPaidParticipants: const [],
      updateAt: DateTime.now());

  WhoPaidState copyWith({
    WhoPaidStatus? status,
    List<ParticipantInTransactionEntity>? participants,
    List<ParticipantInTransactionEntity>? whoPaidParticipants,
    int? amount,
    CurrencyEntity? currency,
    GroupEntity? group,
  }) =>
      WhoPaidState(
          status: status ?? this.status,
          participants: participants ?? this.participants,
          amount: amount ?? this.amount,
          whoPaidParticipants: whoPaidParticipants ?? this.whoPaidParticipants,
          currency: currency ?? this.currency,
          group: group ?? this.group,
          updateAt: DateTime.now());

  @override
  List<Object?> get props => [
        status,
        participants,
        amount,
        currency,
        whoPaidParticipants,
        group,
        updateAt
      ];
}
