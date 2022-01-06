import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
import 'package:spendy_re_work/domain/entities/expense_participants_entity.dart';
import 'model/settle_debt_model.dart';

class SettleDebtAlgorithmCore {
  // Variable names are being reversed from the function :v
  final Map<String, int> _payersMap = {};
  final Map<String, int> _payeesMap = {};
  double _totalPayeesAmount = 0;

  SettleDebtAlgorithmCore(
      Map<String, ParticipantInTransactionEntity> payersMap,
      Map<String, ParticipantInTransactionEntity> payeesMap,
      ExpenseParticipantsEntity transaction) {
    setPayeesMap(payersMap, transaction);
    setPayersMap(payeesMap, transaction);
  }

  Map<String, int> get payersMap => _payersMap;

  Map<String, int> get payeesMap => _payeesMap;

  double get totalPayeesAmount => _totalPayeesAmount;

  void setPayeesMap(Map<String, ParticipantInTransactionEntity> payersMap,
      ExpenseParticipantsEntity transaction) {
    for (final participant in transaction.forWhos ?? []) {
      if (payersMap[participant.name] != null &&
          payersMap[participant.name]!.amount!.abs() != 0) {
        if (participant.amount! < payersMap[participant.name]!.amount!) {
          _payeesMap[participant.name!] = 0;
        } else if (participant.amount! > payersMap[participant.name]!.amount!) {
          _payeesMap[participant.name!] =
              participant.amount! - payersMap[participant.name]!.amount!;
        } else {
          _payeesMap[participant.name!] = 0;
        }
        _totalPayeesAmount += _payeesMap[participant.name]!;
      } else {
        _payeesMap[participant.name!] = participant.amount!;
        _totalPayeesAmount += participant.amount!;
      }
    }
  }

  void setPayersMap(Map<String, ParticipantInTransactionEntity> payeesMap,
      ExpenseParticipantsEntity transaction) {
    for (final participant in transaction.whoPaids ?? []) {
      if (payeesMap[participant.name] != null &&
          payeesMap[participant.name]!.amount!.abs() != 0) {
        if (participant.amount! < payeesMap[participant.name]!.amount!) {
          _payersMap[participant.name!] = 0;
        } else if (participant.amount! > payeesMap[participant.name]!.amount!) {
          _payersMap[participant.name!] =
              participant.amount! - payeesMap[participant.name]!.amount!;
        } else {
          _payersMap[participant.name!] = 0;
        }
      } else {
        _payersMap[participant.name!] = participant.amount!;
      }
    }
  }

  List<SettleDebtModel> debtCalculation() {
    final List<SettleDebtModel> settleDebtsList = [];
    payersMap.keys.toList().forEach((payerName) {
      if (payersMap[payerName]! > 0) {
        payeesMap.keys.toList().forEach((payeeName) {
          if (payeesMap[payeeName]! > 0) {
            final double debtAmount = payersMap[payerName]! *
                (payeesMap[payeeName]! / _totalPayeesAmount);
            settleDebtsList.add(SettleDebtModel(
                payerName: payerName,
                payeeName: payeeName,
                debtAmount: debtAmount));
          }
        });
      }
    });
    return settleDebtsList;
  }
}
