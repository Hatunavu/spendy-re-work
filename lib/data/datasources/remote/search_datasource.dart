import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendy_re_work/common/configs/default_env.dart';
import 'package:spendy_re_work/common/constants/firebase_storage_constants.dart';
import 'package:spendy_re_work/common/firebase_setup.dart';
import 'package:spendy_re_work/data/model/expense/expense_model.dart';

class SearchDataSource {
  final SetupFirebaseDatabase setupFirebase;

  SearchDataSource({required this.setupFirebase});

  ///Search Transaction - Get Expense Recently
  final StreamController<List<ExpenseModel>> _getRecentlyExpenseController =
      StreamController<List<ExpenseModel>>.broadcast();

  void dispose() {
    _getRecentlyExpenseController.close();
  }

  Future<void> updateSearchRecent(
      String uid, String groupId, ExpenseModel expense) async {
    final searchCollection = setupFirebase.collectionRef
        ?.doc(uid)
        .collection(DefaultConfig.groupCollection)
        .doc(groupId)
        .collection(DefaultConfig.searchRecent);
    await searchCollection?.doc(expense.id).set(expense.toJson());
  }

  Future<void> deleteSearchRecent(
      String uid, String groupId, String transactionId) async {
    final searchCollection = setupFirebase.collectionRef
        ?.doc(uid)
        .collection(DefaultConfig.groupCollection)
        .doc(groupId)
        .collection(DefaultConfig.searchRecent);
    await searchCollection?.doc(transactionId).delete();
  }

  Stream listenSearchRecently(String uid, String groupId) {
    _querySearchRecently(uid, groupId);
    return _getRecentlyExpenseController.stream;
  }

  void _querySearchRecently(String uid, String groupId) {
    final CollectionReference _searchRecentCollection = setupFirebase
        .collectionRef!
        .doc(uid)
        .collection(DefaultConfig.groupCollection)
        .doc(groupId)
        .collection(DefaultConfig.searchRecent);
    final _query = _searchRecentCollection
        .orderBy(FirebaseStorageConstants.updateAt, descending: true)
        .limit(DefaultConfig.searchRecentLimitRequest);
    _query.snapshots().listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        _getRecentlyExpenseController.sink.add([]);
      } else if (snapshot.docs.isNotEmpty) {
        final expense = snapshot.docs
            .map((expenseSnapshot) => ExpenseModel.fromJson(
                expenseSnapshot.data() as Map<String, dynamic>,
                expenseSnapshot.id))
            .toList();
        _getRecentlyExpenseController.sink.add(expense);
      }
    });
  }

  ///
  ///Search - Transaction ver2
  ///

  StreamController<List<ExpenseModel>> _searchController =
      StreamController<List<ExpenseModel>>.broadcast();
  List<List<ExpenseModel>> _allSearchResult = <List<ExpenseModel>>[];
  DocumentSnapshot? _searchDocument;
  bool _hasMoreSearch = true;
  bool _searchOnlyExpense = false;

  Stream listenSearchRealTime({String? uid, String? key}) {
    _searchRequest(uid!, key!);
    return _searchController.stream;
  }

  // #1: Move the request posts into it's own function
  Future _searchRequest(String uid, String key, {bool loadMore = false}) async {
    if (!loadMore) {
      _searchClear();
    }
    final CollectionReference expenseCollectionRef = setupFirebase
        .collectionRef!
        .doc(uid)
        .collection(DefaultConfig.expenseCollection);
    // #2: split the query from the actual subscription
    var pageExpensesQuery = expenseCollectionRef
        //.orderBy(FirebaseStorageConstants.spendTimeField, descending: true)
        .where(FirebaseStorageConstants.remarksField, isEqualTo: key)
        // #3: Limit the amount of results
        .limit(DefaultConfig.limitRequest);
    // #5: If we have a document start the query after it
    if (_searchDocument != null) {
      pageExpensesQuery =
          pageExpensesQuery.startAfterDocument(_searchDocument!);
    }
    // If hasMoreExpenses if false, push current expenseList to stream
    if (!_hasMoreSearch) {
      final allExpenses = _allSearchResult.fold<List<ExpenseModel>>(
          <ExpenseModel>[],
          (initialValue, pageItems) => initialValue..addAll(pageItems));
      _searchController.add(allExpenses);
      return;
    }
    // #7: Get and store the page index that the results belong to
    final currentRequestIndex = _allSearchResult.length;
    pageExpensesQuery.snapshots().listen((expensesSnapshot) {
      if (expensesSnapshot.docs.length == 0) {
        _searchOnlyExpense = false;
        _searchController.add([]);
      }
      // If Expense List has only one expense
      if (expensesSnapshot.docs.isEmpty && _searchOnlyExpense) {
        _searchOnlyExpense = false;
        _searchController.add([]);
      } else if (expensesSnapshot.docs.isNotEmpty) {
        final expenses = expensesSnapshot.docs
            .map((snapshot) => ExpenseModel.fromJson(
                snapshot.data() as Map<String, dynamic>, snapshot.id))
            .toList();
        // #8: Check if the page exists or not
        final pageExists = currentRequestIndex < _allSearchResult.length;

        // #9: If the page exists update the posts for that page
        if (pageExists) {
          _allSearchResult[currentRequestIndex] = expenses;
        }
        // #10: If the page doesn't exist add the page data
        else {
          _allSearchResult.add(expenses);
        }
        // #11: Concatenate the full list to be shown
        final allExpenses = _allSearchResult.fold<List<ExpenseModel>>(
            <ExpenseModel>[],
            (initialValue, pageItems) => initialValue..addAll(pageItems));
        // #12: Broadcase all posts
        _searchController.add(allExpenses);
        // #13: Save the last document from the results only if it's the current last page
        if (currentRequestIndex == _allSearchResult.length - 1) {
          _searchDocument = expensesSnapshot.docs.last;
        }
        // #14: Determine if there's more posts to request
        _hasMoreSearch = expenses.length == DefaultConfig.limitRequest;

        // Check is only Expense
        _searchOnlyExpense = allExpenses.length == 1;
      }
    });
  }

  void searchRequestMore({String? uid, String? key}) =>
      _searchRequest(uid!, key!, loadMore: true);

  void _searchClear() {
    _searchController = StreamController<List<ExpenseModel>>.broadcast();
    _searchDocument = null;
    _searchOnlyExpense = false;
    _hasMoreSearch = true;
    _allSearchResult = <List<ExpenseModel>>[];
  }

  final StreamController<List<ExpenseModel>> _allExpenseController =
      StreamController<List<ExpenseModel>>.broadcast();

  Stream listenAllExpense(String uid, String groupId) {
    _queryAllExpense(uid, groupId);
    return _allExpenseController.stream;
  }

  void _queryAllExpense(String uid, String groupId) {
    final collectionRef = setupFirebase.collectionRef!
        .doc(uid)
        .collection(DefaultConfig.groupCollection)
        .doc(groupId)
        .collection(DefaultConfig.transactions);
    final queryAll = collectionRef
        .orderBy(FirebaseStorageConstants.spendTimeField, descending: true);
    queryAll.snapshots().listen((snapshot) {
      if (snapshot.docs.isEmpty || snapshot.docs.length == 0) {
        _allExpenseController.add([]);
      } else if (snapshot.docs.isNotEmpty) {
        final expenses = snapshot.docs
            .map((expense) => ExpenseModel.fromJson(expense.data(), expense.id))
            .toList();
        _allExpenseController.sink.add(expenses);
      }
    });
  }
}
