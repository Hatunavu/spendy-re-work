import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/participant_entity.dart';
import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/domain/usecases/currency_usecase.dart';
import 'package:spendy_re_work/domain/usecases/group_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/event_bus_bloc/bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_util.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/who_paid_bloc/who_paid_state.dart';

class WhoPaidBloc extends Cubit<WhoPaidState> {
  final GroupUseCase groupUseCase;
  final AuthenticationBloc authenticationBloc;
  final CurrencyUseCase currencyUseCase;
  final EventBusBloc eventBusBloc;

  late String uid;
  WhoPaidBloc(
      {required this.groupUseCase,
      required this.authenticationBloc,
      required this.currencyUseCase,
      required this.eventBusBloc})
      : super(WhoPaidState.initial()) {
    uid = authenticationBloc.userEntity.uid ?? '';
    getCurrency();
    eventBusBloc.stream.listen((eventBusStat) {
      if (eventBusStat is RefreshParticipantInTransactionState &&
          state.group != null) {
        getParticipants(group: state.group!);
      }
    });
  }

  Future<void> getCurrency() async {
    final currency = await currencyUseCase.getCurrentCurrency();
    emit(state.copyWith(currency: currency));
  }

  Future<void> changedMoney(int money) async {
    final participants = state.participants;
    int countSelect = 0;
    int sumEdit = 0;
    for (final participant in participants) {
      if (participant.isSelected && !participant.isEdit) {
        countSelect++;
      }
      if (participant.isSelected && participant.isEdit) {
        sumEdit += participant.amount ?? 0;
      }
    }
    if (countSelect == 0) {
      countSelect = 1;
    }
    final int shareAmount = (money - sumEdit) ~/ countSelect;
    for (final participant in participants) {
      if (participant.isSelected && !participant.isEdit) {
        participant.amount = shareAmount;
      }
    }

    emit(state.copyWith(amount: money, participants: participants));
  }

  Future<void> getParticipants(
      {GroupEntity? group, ExpenseEntity? expense}) async {
    final participants = <ParticipantInTransactionEntity>[
      ParticipantInTransactionEntity(
          name: translate('label.me'),
          uid: uid,
          amount: state.amount,
          isSelected: true)
    ];
    final groupParticipants = <ParticipantEntity>[];
    if (group != null && group.id != null) {
      final _participants =
          await groupUseCase.getDataParticipantList(uid, group.id ?? '');
      groupParticipants.addAll(_participants);
    }
    if (expense != null &&
        expense.forMe != null &&
        expense.forMe?.whoPaid != null) {
      participants[0].amount = expense.forMe!.whoPaid;
    } else {
      participants[0].isSelected = false;
      participants[0].amount = null;
    }
    if (groupParticipants.isNotEmpty) {
      final participantformGroup = <ParticipantInTransactionEntity>[];
      for (final participant in groupParticipants) {
        participantformGroup.add(ParticipantInTransactionEntity(
            name: participant.name, uid: participant.id, isSelected: false));
      }
      if (expense != null && expense.whoPaid.isNotEmpty) {
        log('expense who paid: ${expense.whoPaid}');
        final newParticipants =
            await compute(NewExpenseUtil.getAmountOfParticipant, {
          NewExpenseConstants.groupParticipantsKey: participantformGroup,
          NewExpenseConstants.expenseParticipantsKey: expense.whoPaid
        });
        participants.addAll(newParticipants);
      } else {
        participants.addAll(participantformGroup);
      }
    }

    emit(state.copyWith(participants: participants, group: group));
  }

  Future<void> editParticipantMoney(int newMoney, int participantIndex) async {
    final participants = state.participants;
    final participantLength = state.participants.length;
    participants[participantIndex]
      ..amount = newMoney
      ..isEdit = true;
    var sumEdit = 0;
    var countSelected = 0;
    for (final participant in participants) {
      if (participant.isSelected && !participant.isEdit) {
        countSelected++;
      }
      if (participant.isSelected && participant.isEdit) {
        sumEdit += participant.amount ?? 0;
      }
    }
    if (sumEdit < state.amount) {
      final amount = (state.amount - sumEdit) ~/ countSelected;
      for (var index = 0; index < participantLength; index++) {
        final participant = participants[index];
        if (participant.isSelected && !participant.isEdit) {
          participant.amount = amount;
        }
        participants[index] = participant;
      }
    }

    emit(state.copyWith(
      participants: participants,
    ));
  }

  Future<void> onSelectAParticipant(int selectIndex) async {
    final participants = state.participants;
    final participantLength = participants.length;
    participants[selectIndex].isSelected =
        !participants[selectIndex].isSelected;
    var sumEdit = 0;
    var countSelected = 0;
    for (final participant in participants) {
      if (participant.isSelected && !participant.isEdit) {
        countSelected++;
      }
      if (participant.isSelected && participant.isEdit) {
        sumEdit += participant.amount ?? 0;
      }
    }
    if (!participants[selectIndex].isSelected && countSelected == 0) {
      return;
    }
    final amount = (state.amount - sumEdit) ~/ countSelected;
    for (var index = 0; index < participantLength; index++) {
      final participant = participants[index];
      if (participant.isSelected && !participant.isEdit) {
        participant.amount = amount;
      }
      if (!participant.isSelected) {
        participant
          ..amount = null
          ..isEdit = false;
      }
      participants[index] = participant;
    }

    emit(state.copyWith(
      participants: participants,
    ));
  }

  Future<void> onSaveWhoPaid() async {
    final participents = state.participants;
    final whoPaidParticipants = <ParticipantInTransactionEntity>[];
    for (final participant in participents) {
      if (participant.amount != null) {
        whoPaidParticipants.add(participant);
      }
    }
    emit(state.copyWith(
        status: WhoPaidStatus.success,
        whoPaidParticipants: whoPaidParticipants));
  }
}
