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
    /// G???p c??c kho???n n???
//    debugPrint('sortSettleDebtsList - settleDebtsList.length: ${settleDebtsList.length}');
    settleDebtsList.sort((settleDebtA, settleDebtsB) =>
        settleDebtA.payerName.compareTo(settleDebtsB.payerName));
    for (int i = 0; i < settleDebtsList.length - 1; i++) {
      for (int j = i + 1; j < settleDebtsList.length; j++) {
        if ((settleDebtsList[i].payerName.trim() ==
                settleDebtsList[j].payerName.trim()) &&
            (settleDebtsList[i].payeeName.trim() ==
                settleDebtsList[j].payeeName.trim())) {
          /// N???u kho???n n??? ??? c??c giao d???ch c?? ng?????i cho n??? v?? ng?????i n??? gi???ng
          /// nhau th?? ti???n h??nh c???ng g???p ti???n n???
          settleDebtsList[i].debtAmount += settleDebtsList[j].debtAmount;
          settleDebtsList.removeAt(j);
          j--;
        } else if ((settleDebtsList[i].payerName.trim() ==
                settleDebtsList[j].payeeName.trim()) &&
            (settleDebtsList[i].payeeName.trim() ==
                settleDebtsList[j].payerName.trim())) {
          /// N???u ng?????i cho n??? v?? ng?????i n??? ??? giao d???ch n??y l???i l?? ng?????i n??? v??
          /// ng?????i cho n??? ??? giao d???ch kh??c th?? ti???n h??nh tr??? g???p ti???n n???
          settleDebtsList[i].debtAmount -= settleDebtsList[j].debtAmount;
          settleDebtsList.removeAt(j);
          j--;
        }
      }

      /// Sau khi g???p n???, ki???m tra s??? ti???n n???:
      /// - N???u s??? ti???n n??? l?? d????ng => gi??? nguy??n v??? tr?? ng?????i n??? v?? ng?????i cho n???
      /// - N???u s??? ti???n n??? l?? ??m => ho??n ?????i v??? tr?? c???a ng?????i n??? v?? ng?????i cho n???
      /// - N???u s??? ti???n n??? b???ng 0 => 2 ng?????i h???t n???
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
