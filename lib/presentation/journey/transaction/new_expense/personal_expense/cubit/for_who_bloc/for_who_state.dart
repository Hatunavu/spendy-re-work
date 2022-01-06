import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';

enum ForWhoStatus { initial, loading, success, failed }

class ForWhoState extends Equatable {
  final ForWhoStatus status;
  final GroupEntity? group;
  final List<ParticipantInTransactionEntity> participants;
  final List<ParticipantInTransactionEntity> forWhoParticipant;
  final int amount;
  final CurrencyEntity? currency;
  final DateTime updateAt;

  ForWhoState({
    required this.status,
    required this.participants,
    required this.forWhoParticipant,
    required this.amount,
    this.group,
    this.currency,
    required this.updateAt,
  });

  factory ForWhoState.initial() => ForWhoState(
        status: ForWhoStatus.initial,
        participants: const [],
        forWhoParticipant: const [],
        amount: 0,
        updateAt: DateTime.now(),
      );

  ForWhoState copyWith({
    ForWhoStatus? status,
    List<ParticipantInTransactionEntity>? participants,
    List<ParticipantInTransactionEntity>? forWhoParticipant,
    int? amount,
    CurrencyEntity? currency,
    GroupEntity? group,
  }) {
    return ForWhoState(
        status: status ?? this.status,
        participants: participants ?? this.participants,
        forWhoParticipant: forWhoParticipant ?? this.forWhoParticipant,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        group: group ?? this.group,
        updateAt: DateTime.now());
  }

  @override
  List<Object?> get props =>
      [status, participants, forWhoParticipant, amount, currency, updateAt, group];
}
