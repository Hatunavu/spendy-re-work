import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendy_re_work/common/configs/default_env.dart';
import 'package:spendy_re_work/common/firebase_setup.dart';
import 'package:spendy_re_work/data/model/expense/expense_model.dart';
import 'package:spendy_re_work/domain/entities/filter/filter.dart';

class FilterDataSource {
  final SetupFirebaseDatabase setupFirebase;

  FilterDataSource({required this.setupFirebase});

  final StreamController<List<ExpenseModel>> _filterController =
      StreamController<List<ExpenseModel>>.broadcast();

  List<List<ExpenseModel>> _allFilterPageResult = <List<ExpenseModel>>[];
  DocumentSnapshot? _lastFilterDocument;
  bool _hasMoreExpenseFilters = true;
  bool _isOnlyExpenseFilter = false;

  Stream listenToFilter(String uid, String groupId, Filter filter) {
    _requestFilter(uid, groupId, filter, renew: true);
    return _filterController.stream;
  }

  // #1: Move the request posts into it's own function
  Future _requestFilter(String uid, String groupId, Filter filter,
      {bool renew = false}) async {
    if (renew) {
      _allFilterPageResult = <List<ExpenseModel>>[];
      _lastFilterDocument = null;
      _hasMoreExpenseFilters = true;
      _isOnlyExpenseFilter = false;
    }

    Query expenseQuery = setupFirebase.collectionRef!
        .doc(uid)
        .collection(DefaultConfig.groupCollection)
        .doc(groupId)
        .collection(DefaultConfig.transactions);
    // Query expenseQuery;
    if (filter.category != null && filter.category!.isNotEmpty) {
      expenseQuery = expenseQuery.where(DefaultConfig.categoryField,
          isEqualTo: filter.category);
    }
    // Range always exist
    // Can not query "where" with amount Field because it not same query "orderBy" with spendTime Field
    if (filter.dateFilter != null && filter.dateFilter!.isSafe) {
      expenseQuery = expenseQuery
          .orderBy(DefaultConfig.spendTimeField)
          .startAt([filter.dateFilter!.start]).endAt([filter.dateFilter!.end]);
    } else {
      expenseQuery =
          expenseQuery.orderBy(DefaultConfig.spendTimeField, descending: true);
    }

    // #2: split the query from the actual subscription
    var pageExpensesQuery = expenseQuery;
    // .orderBy(DefaultConfig.spendTimeField, descending: true)
    // #3: Limit the amount of results
    // .limit(DefaultConfig.limitRequest);

    // #5: If we have a document start the query after it
    if (_lastFilterDocument != null) {
      pageExpensesQuery =
          pageExpensesQuery.startAfterDocument(_lastFilterDocument!);
    }

    if (!_hasMoreExpenseFilters) {
      return;
    }

    // #7: Get and store the page index that the results belong to
    final currentRequestIndex = _allFilterPageResult.length;

    pageExpensesQuery.snapshots().listen((expensesSnapshot) {
      // If Expense List has only one expense
      if (expensesSnapshot.docs.isEmpty && _isOnlyExpenseFilter) {
        _isOnlyExpenseFilter = false;
        _filterController.add([]);
      } else if (expensesSnapshot.docs.isNotEmpty) {
        final expenses = expensesSnapshot.docs
            .map((snapshot) => ExpenseModel.fromJson(
                snapshot.data() as Map<String, dynamic>, snapshot.id))
            .toList();
        // #8: Check if the page exists or not
        final pageExists = currentRequestIndex < _allFilterPageResult.length;

        // #9: If the page exists update the posts for that page
        if (pageExists) {
          _allFilterPageResult[currentRequestIndex] = expenses;
        }
        // #10: If the page doesn't exist add the page data
        else {
          _allFilterPageResult.add(expenses);
        }

        // #11: Concatenate the full list to be shown
        final allExpenses = _allFilterPageResult.fold<List<ExpenseModel>>(
            <ExpenseModel>[],
            (initialValue, pageItems) => initialValue..addAll(pageItems));
        // #12: Broadcast all posts
        _filterController.add(allExpenses);

        // #13: Save the last document from the results only if it's the current last page
        if (currentRequestIndex == _allFilterPageResult.length - 1) {
          _lastFilterDocument = expensesSnapshot.docs.last;
        }

        // #14: Determine if there's more posts to request
        _hasMoreExpenseFilters = expenses.length == DefaultConfig.limitRequest;

        // Check is only Expense
        _isOnlyExpenseFilter = allExpenses.length == 1;
      }
    });
  }

  void requestMoreFilterData(String uid, String groupId, Filter filter) =>
      _requestFilter(uid, groupId, filter);

  void renewFilter(String uid, String groupId, Filter filter,
          {bool renew = true}) =>
      _requestFilter(uid, groupId, filter, renew: true);
}
