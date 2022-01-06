import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendy_re_work/common/configs/default_env.dart';
import 'package:spendy_re_work/common/firebase_setup.dart';
import 'package:spendy_re_work/data/model/expense/expense_model.dart';

class ReportDataSource {
  final SetupFirebaseDatabase setupFirebase;
  List<List<ExpenseModel>> _allExpenseHomeReportPageResult =
      <List<ExpenseModel>>[];
  StreamController<List<ExpenseModel>> _expenseHomeReportController =
      StreamController<List<ExpenseModel>>.broadcast();

  bool _isOnlyExpenseHomeReport = false;

  ReportDataSource({required this.setupFirebase});

  /// ===== HOME REPORT =====
  Stream listenToExpensesHomeReport(
      {String? uid, int? startDay, int? endDate}) {
    _requestExpensesHomeReport(
        uid: uid!, startDay: startDay!, endDate: endDate!);
    return _expenseHomeReportController.stream;
  }

  Future _requestExpensesHomeReport(
      {String? uid, int? startDay, int? endDate, bool loadMore = false}) async {
    final CollectionReference expenseCollectionRef = setupFirebase
        .collectionRef!
        .doc(uid)
        .collection(DefaultConfig.expenseCollection);
    final pageExpensesQuery = expenseCollectionRef
        .where(DefaultConfig.spendTimeField,
            isGreaterThanOrEqualTo: startDay, isLessThanOrEqualTo: endDate)
        .orderBy(DefaultConfig.spendTimeField, descending: true);

    final currentRequestIndex = _allExpenseHomeReportPageResult.length;
    pageExpensesQuery.snapshots().listen((expensesSnapshot) {
      if (expensesSnapshot.docs.isEmpty && _isOnlyExpenseHomeReport) {
        _isOnlyExpenseHomeReport = false;
        _expenseHomeReportController.add([]);
      } else if (expensesSnapshot.docs.isEmpty && loadMore) {
        final allExpenses = _allExpenseHomeReportPageResult
            .fold<List<ExpenseModel>>(<ExpenseModel>[],
                (initialValue, pageItems) => initialValue..addAll(pageItems));
        _expenseHomeReportController.add(allExpenses);
        _isOnlyExpenseHomeReport = allExpenses.length == 1;
      }
      if (expensesSnapshot.docs.isNotEmpty) {
        final expenses = expensesSnapshot.docs
            .map((snapshot) => ExpenseModel.fromJson(
                snapshot.data() as Map<String, dynamic>, snapshot.id))
            .toList();

        final pageExists =
            currentRequestIndex < _allExpenseHomeReportPageResult.length;

        if (pageExists) {
          _allExpenseHomeReportPageResult[currentRequestIndex] = expenses;
        } else {
          _allExpenseHomeReportPageResult.add(expenses);
        }

        final allExpenses = _allExpenseHomeReportPageResult
            .fold<List<ExpenseModel>>(<ExpenseModel>[],
                (initialValue, pageItems) => initialValue..addAll(pageItems));
        _expenseHomeReportController.add(allExpenses);
        _isOnlyExpenseHomeReport = allExpenses.length == 1;
      }
    });
  }

  void requestMoreReportDataByYear(
          {String? uid, int? startDay, int? endDate}) =>
      _requestExpensesHomeReport(
          uid: uid, startDay: startDay, endDate: endDate, loadMore: true);

  void clear() {
    _allExpenseHomeReportPageResult = <List<ExpenseModel>>[];
    _expenseHomeReportController =
        StreamController<List<ExpenseModel>>.broadcast();
    _isOnlyExpenseHomeReport = false;
  }
}
