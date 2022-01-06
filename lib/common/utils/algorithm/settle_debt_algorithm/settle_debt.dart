import 'package:flutter/cupertino.dart';
import 'package:spendy_re_work/common/utils/algorithm/settle_debt_algorithm/model/settle_debt_model.dart';
import 'package:spendy_re_work/common/utils/algorithm/settle_debt_algorithm/settle_debt_algorithm_core.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/expense_participants_entity.dart';
import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
import 'package:spendy_re_work/domain/entities/transaction_entity.dart';

class SettleDebt {
  SettleDebt(
      {required this.nameUser,
      required this.listExpense,
      required this.listExpenseParticipant,
      required this.listTransaction});

  final String nameUser;
  final List<ExpenseParticipantsEntity> listExpenseParticipant;
  final List<TransactionEntity> listTransaction;
  final List<ExpenseEntity> listExpense;

  List<SettleDebtModel> _settleDebtsList = [];

  List<SettleDebtModel> get settleDebtsList => _settleDebtsList;

  double _totalExpense = 0;

  double get totalExpense => _totalExpense;

  double _totalOwed = 0;

  double get totalOwed => _totalOwed;

  Future settleDebt() async {
    final List<SettleDebtModel> tempSettleDebtsList = [];
    try {
      // identify the list of creditors and debtor for each transaction
      for (final ExpenseParticipantsEntity userTransaction
          in listExpenseParticipant) {
        tempSettleDebtsList
            .addAll(_getSettleDebtsList(transaction: userTransaction));
      }
      _settleDebtsList = await _combinedDebts(nameUser, tempSettleDebtsList);
      _setTotalExpense();
      _getTotalOwed(nameUser);
    } catch (e) {
      debugPrint('>>> SettleDebtUseCase - settleDebt - error: $e');
      rethrow;
    }
  }

  List<SettleDebtModel> _getSettleDebtsList(
      {required ExpenseParticipantsEntity transaction}) {
    final Map<String, ParticipantInTransactionEntity> payersMap = {};
    final Map<String, ParticipantInTransactionEntity> payeesMap = {};
    for (final participant in transaction.whoPaids ?? []) {
      payersMap[participant.name!] = participant;
    }
    for (final participant in transaction.forWhos ?? []) {
      payeesMap[participant.name!] = participant;
    }
    final SettleDebtAlgorithmCore settleDebtAlgorithm =
        SettleDebtAlgorithmCore(payersMap, payeesMap, transaction);

    final List<SettleDebtModel> settleDebtsList =
        settleDebtAlgorithm.debtCalculation();
    return settleDebtsList;
  }

  Future<List<SettleDebtModel>> _combinedDebts(
      String userName, List<SettleDebtModel> settleDebtsList) async {
    /// Gộp các khoản nợ
//    debugPrint('sortSettleDebtsList - settleDebtsList.length: ${settleDebtsList.length}');
    settleDebtsList.sort((settleDebtA, settleDebtsB) =>
        settleDebtA.payerName.compareTo(settleDebtsB.payerName));
    for (int i = 0; i < settleDebtsList.length - 1; i++) {
      for (int j = i + 1; j < settleDebtsList.length; j++) {
        if ((settleDebtsList[i].payerName.trim() ==
                settleDebtsList[j].payerName.trim()) &&
            (settleDebtsList[i].payeeName.trim() ==
                settleDebtsList[j].payeeName.trim())) {
          /// Nếu khoản nợ ở các giao dịch có người cho nợ và người nợ giống
          /// nhau thì tiến hành cộng gộp tiền nợ
          settleDebtsList[i].debtAmount += settleDebtsList[j].debtAmount;
          settleDebtsList.removeAt(j);
          j--;
        } else if ((settleDebtsList[i].payerName.trim() ==
                settleDebtsList[j].payeeName.trim()) &&
            (settleDebtsList[i].payeeName.trim() ==
                settleDebtsList[j].payerName.trim())) {
          /// Nếu người cho nợ và người nợ ở giao dịch này lại là người nợ và
          /// người cho nợ ở giao dịch khác thì tiến hành trừ gộp tiền nợ
          settleDebtsList[i].debtAmount -= settleDebtsList[j].debtAmount;
          settleDebtsList.removeAt(j);
          j--;
        }
      }

      /// Sau khi gộp nợ, kiểm tra số tiền nợ:
      /// - Nếu số tiền nợ là dương => giữ nguyên vị trí người nợ và người cho nợ
      /// - Nếu số tiền nợ là âm => hoán đổi vị trí của người nợ và người cho nợ
      /// - Nếu số tiền nợ bằng 0 => 2 người hết nợ
      if (settleDebtsList[i].debtAmount == 0 ||
          settleDebtsList[i].debtAmount.toString().contains('e')) {
        settleDebtsList.removeAt(i);
        i--;
      } else if (settleDebtsList[i].debtAmount < 0) {
        settleDebtsList[i] = SettleDebtModel(
            payerName: settleDebtsList[i].payeeName,
            payeeName: settleDebtsList[i].payerName,
            debtAmount: settleDebtsList[i].debtAmount.abs());
      }
    }
    return _sortSettleDebtsList(userName, settleDebtsList);
  }

  Future<List<SettleDebtModel>> _sortSettleDebtsList(
      String userName, List<SettleDebtModel> settleDebtsList) async {
    final List<SettleDebtModel> sortSettleDebtsList = [];
    for (int i = 0; i < settleDebtsList.length; i++) {
      if (settleDebtsList[i].payerName.toLowerCase() ==
          userName.toLowerCase()) {
        sortSettleDebtsList.add(settleDebtsList[i]);
        settleDebtsList.removeAt(i);
        i--;
      }
    }
    for (int i = 0; i < settleDebtsList.length; i++) {
      if (settleDebtsList[i].payeeName.toLowerCase() ==
          userName.toLowerCase()) {
        sortSettleDebtsList.add(settleDebtsList[i]);
        settleDebtsList.removeAt(i);
        i--;
      }
    }
    sortSettleDebtsList.addAll(settleDebtsList);
    return sortSettleDebtsList;
  }

  void _getTotalOwed(String nameUser) {
    for (final SettleDebtModel settleDebtModel in _settleDebtsList) {
      if (settleDebtModel.payeeName.toUpperCase() == nameUser.toUpperCase()) {
        _totalOwed -= settleDebtModel.debtAmount;
      } else if (settleDebtModel.payerName.toUpperCase() ==
          nameUser.toUpperCase()) {
        _totalOwed += settleDebtModel.debtAmount;
      }
    }
    if (_totalOwed <= 0) {
      _totalOwed = 0;
    } else {
      _totalOwed = _totalOwed.abs();
    }
  }

  void _setTotalExpense() {
    _totalExpense = 0;
    for (var i = 0; i < listTransaction.length; i++) {
      _totalExpense += listTransaction[i].amount;
    }
  }
}
