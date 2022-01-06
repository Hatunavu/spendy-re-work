import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendy_re_work/common/configs/default_env.dart';
import 'package:spendy_re_work/common/constants/firebase_storage_constants.dart';
import 'package:spendy_re_work/common/firebase_setup.dart';
import 'package:spendy_re_work/data/model/goal_model.dart';

class GoalRemoteDataSource {
  final SetupFirebaseDatabase setupFirebase;

  StreamController<List<GoalModel>> _goalController = StreamController<List<GoalModel>>.broadcast();

  List<List<GoalModel>> _allGoalPageResult = [];
  DocumentSnapshot? _lastDocument;
  bool _hasMoreGoals = true;
  bool _isOnlyGoal = false;

  GoalRemoteDataSource({required this.setupFirebase});

  ///  CREATE
  Future<String?> createGoal({String? uid, GoalModel? goal}) async {
    final CollectionReference goalCollectionRef =
        setupFirebase.collectionRef!.doc(uid).collection(FirebaseStorageConstants.goalCollection);
    final goalDocRef = await goalCollectionRef.add(goal!.toJson());
    return goalDocRef.id;
  }

  /// GET
  Future<GoalModel> getGoalById(String uid, String id) async {
    final document = await setupFirebase.collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.goalCollection)
        .doc(id)
        .get();
    final goalModel =
        GoalModel.fromJson(json: document.data() as Map<String, dynamic>, id: document.id);
    return goalModel;
  }

  /// ===== UPDATE =====
  Future<bool> updateGoal({String? uid, GoalModel? goal}) async {
    final CollectionReference goalCollectionRef =
        setupFirebase.collectionRef!.doc(uid).collection(FirebaseStorageConstants.goalCollection);
    await goalCollectionRef.doc(goal!.id).update(goal.toJson());
    return false;
  }

  /// ===== REMOVE =====
  Future<bool> removeGoal({String? uid, String? goalID}) async {
    final CollectionReference goalCollectionRef =
        setupFirebase.collectionRef!.doc(uid).collection(FirebaseStorageConstants.goalCollection);
    await goalCollectionRef.doc(goalID).delete();
    return false;
  }

  Stream listenToExpensesRealTime({String? uid}) {
    _requestGoals(uid!);
    return _goalController.stream;
  }

  // #1: Move the request posts into it's own function
  Future _requestGoals(String uid) async {
    final CollectionReference goalCollectionRef =
        setupFirebase.collectionRef!.doc(uid).collection(FirebaseStorageConstants.goalCollection);
    // #2: split the query from the actual subscription
    var pageExpensesQuery = goalCollectionRef
        .orderBy(FirebaseStorageConstants.dateField, descending: true)
        // #3: Limit the amount of results
        .limit(DefaultConfig.limitRequest);

    // #5: If we have a document start the query after it
    if (_lastDocument != null) {
      pageExpensesQuery = pageExpensesQuery.startAfterDocument(_lastDocument!);
    }

    if (!_hasMoreGoals) {
      final allGoals = _allGoalPageResult.fold<List<GoalModel>>(
          <GoalModel>[], (initialValue, pageItems) => initialValue..addAll(pageItems));
      _goalController.add(allGoals);
      return;
    }

    // #7: Get and store the page index that the results belong to
    final currentRequestIndex = _allGoalPageResult.length;

    pageExpensesQuery.snapshots().listen((expensesSnapshot) {
      // If Expense List has only one expense
      if (expensesSnapshot.docs.isEmpty && _isOnlyGoal) {
        _isOnlyGoal = false;
        _goalController.add([]);
      } else if (expensesSnapshot.docs.isNotEmpty) {
        final expenses = expensesSnapshot.docs
            .map((snapshot) =>
                GoalModel.fromJson(json: snapshot.data() as Map<String, dynamic>, id: snapshot.id))
            .toList();

        // #8: Check if the page exists or not
        final pageExists = currentRequestIndex < _allGoalPageResult.length;

        // #9: If the page exists update the posts for that page
        if (pageExists) {
          _allGoalPageResult[currentRequestIndex] = expenses;
        }
        // #10: If the page doesn't exist add the page data
        else {
          _allGoalPageResult.add(expenses);
        }

        // #11: Concatenate the full list to be shown
        final allGoals = _allGoalPageResult.fold<List<GoalModel>>(
            <GoalModel>[], (initialValue, pageItems) => initialValue..addAll(pageItems));
        // #12: Broadcase all posts
        _goalController.add(allGoals);

        // #13: Save the last document from the results only if it's the current last page
        if (currentRequestIndex == _allGoalPageResult.length - 1) {
          _lastDocument = expensesSnapshot.docs.last;
        }

        // #14: Determine if there's more posts to request
        _hasMoreGoals = expenses.length == DefaultConfig.limitRequest;

        // Check is only Expense
        _isOnlyGoal = allGoals.length == 1;
      }
    });
  }

  void requestMoreData({String? uid}) => _requestGoals(uid!);

  void clear() {
    _goalController = StreamController<List<GoalModel>>.broadcast();
    _lastDocument = null;
    _allGoalPageResult = <List<GoalModel>>[];
    _hasMoreGoals = true;
    _isOnlyGoal = false;
  }
}
