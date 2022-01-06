import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:spendy_re_work/common/configs/default_env.dart';
import 'package:spendy_re_work/common/constants/firebase_storage_constants.dart';
import 'package:spendy_re_work/common/firebase_setup.dart';
import 'package:spendy_re_work/data/model/expense/expense_model.dart';
import 'package:spendy_re_work/data/model/photo_model.dart';

class TransactionRemoteDataSource {
  final SetupFirebaseDatabase _firebaseDatabase;

  TransactionRemoteDataSource(this._firebaseDatabase);

  Future<ExpenseModel?> addTransaction(
      {required String uid,
      required String groupId,
      required ExpenseModel transaction}) async {
    final transactionCollections = _firebaseDatabase.collectionRef
        ?.doc(uid)
        .collection(DefaultConfig.groupCollection)
        .doc(groupId)
        .collection(DefaultConfig.transactions);
    final transactionDoc =
        await transactionCollections?.add(transaction.toJson());
    ExpenseModel? expenseModel;
    if (transactionDoc != null) {
      final transactionSnapshot = await transactionDoc.get();
      expenseModel = ExpenseModel.fromJson(
          transactionSnapshot.data() as Map<String, dynamic>,
          transactionSnapshot.id);
    }
    return expenseModel;
  }

  Future<void> addPhotos(
      {required String uid,
      required String groupId,
      required String transactionId,
      required List<PhotoModel> photos}) async {
    final photoCollection = _firebaseDatabase.collectionRef
        ?.doc(uid)
        .collection(DefaultConfig.groupCollection)
        .doc(groupId)
        .collection(DefaultConfig.transactions)
        .doc(transactionId)
        .collection(DefaultConfig.photos);
    final batch = FirebaseFirestore.instance.batch();
    for (final photo in photos) {
      await photoCollection?.doc().set(photo.toJson());
    }
    await batch.commit();
  }

  Future<void> updateTransaction(
      {required String uid,
      required String groupId,
      required ExpenseModel transaction}) async {
    await _firebaseDatabase.collectionRef
        ?.doc(uid)
        .collection(DefaultConfig.groupCollection)
        .doc(groupId)
        .collection(DefaultConfig.transactions)
        .doc(transaction.id)
        .update(transaction.toJson());
  }

  Future<List<String>> uploadImages(
      {List<Asset>? imageAssets, List<File>? imageFiles, String? uid}) async {
    final List<String> imageUrls = [];
    List<String> imageAssetUrls = [];
    List<String> imageFileUrls = [];
    if (imageAssets != null && imageAssets.isNotEmpty) {
      imageAssetUrls = await uploadImageAssets(imageAssets, uid!);
    }
    if (imageFiles != null && imageFiles.isNotEmpty) {
      imageFileUrls = await uploadImageFiles(imageFiles, uid!);
    }
    imageUrls
      ..addAll(imageAssetUrls)
      ..addAll(imageFileUrls);
    return imageUrls;
  }

  Future<List<String>> uploadImageAssets(
      List<Asset> imageAssets, String uid) async {
    final List<String> imageUrls = [];
    try {
      for (final Asset item in imageAssets) {
        final ByteData byteData = await item.getByteData(quality: 80);
        final Uint8List imageData = byteData.buffer.asUint8List();
        final firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('images/$uid/${basename(item.name!)}');
        final firebase_storage.UploadTask task = ref.putData(imageData);
        final TaskSnapshot taskSnapshot = await task.whenComplete(() => null);
        final String url = await taskSnapshot.ref.getDownloadURL();
        imageUrls.add(url);
      }
    } on Exception catch (e) {
      throw FirebaseException(
          plugin: 'Spendy',
          message:
              'TransactionRemoteDataSource - uploadImageAssets - error: ${e.toString()}');
    }
    return imageUrls;
  }

  Future<List<String>> uploadImageFiles(
      List<File> imageFiles, String uid) async {
    final List<String> imageUrls = [];
    try {
      for (final File item in imageFiles) {
        final firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('images/$uid/${basename(item.path)}');
        final firebase_storage.UploadTask task = ref.putFile(item);
        final TaskSnapshot taskSnapshot = await task.whenComplete(() => null);
        final String url = await taskSnapshot.ref.getDownloadURL();
        imageUrls.add(url);
      }
    } on Exception catch (e) {
      throw FirebaseException(
          plugin: 'Spendy',
          message:
              'TransactionRemoteDataSource - uploadImageFiles - error: ${e.toString()}');
    }
    return imageUrls;
  }

  Future<ExpenseModel?> getTransactionById({
    required String uid,
    required String groupId,
    required String transactionId,
  }) async {
    ExpenseModel? transaction;
    final transactionDoc = await _firebaseDatabase.collectionRef
        ?.doc(uid)
        .collection(DefaultConfig.groupCollection)
        .doc(groupId)
        .collection(DefaultConfig.transactions)
        .doc(transactionId)
        .get();
    if (transactionDoc != null && transactionDoc.exists) {
      transaction = ExpenseModel.fromJson(
          transactionDoc.data() as Map<String, dynamic>, transactionDoc.id);
    }
    return transaction;
  }

  Future<void> deleteTransaction({
    required String uid,
    required String groupId,
    required String transactionId,
  }) async {
    await _firebaseDatabase.collectionRef
        ?.doc(uid)
        .collection(DefaultConfig.groupCollection)
        .doc(groupId)
        .collection(DefaultConfig.transactions)
        .doc(transactionId)
        .delete();
  }

  /// Home - Transaction Recently
  final StreamController<List<ExpenseModel>> _expenseRecentlyController =
      StreamController<List<ExpenseModel>>.broadcast();
  final _allExpenseRecentResult = <List<ExpenseModel>>[];

  Stream listenToExpensesRecently({String? uid}) {
    _requestExpensesRecently(uid!);
    return _expenseRecentlyController.stream;
  }

  Future _requestExpensesRecently(String uid) async {
    final CollectionReference expenseCollectionRef = _firebaseDatabase
        .collectionRef!
        .doc(uid)
        .collection(DefaultConfig.expenseCollection);
    // #2: split the query from the actual subscription
    final pageExpensesQuery = expenseCollectionRef
        .orderBy(FirebaseStorageConstants.spendTimeField, descending: true)
        .limit(DefaultConfig.limitRequest);

    final currentRequestIndex = _allExpensePageResult.length;

    pageExpensesQuery.snapshots().listen(
      (expensesSnapshot) {
        // If Expense List has only one expense
        if (expensesSnapshot.docs.isEmpty && _isOnlyExpense) {
          _isOnlyExpense = false;
          _expenseRecentlyController.add([]);
        } else if (expensesSnapshot.docs.isNotEmpty) {
          final expenses = expensesSnapshot.docs
              .map((snapshot) => ExpenseModel.fromJson(
                  snapshot.data() as Map<String, dynamic>, snapshot.id))
              .toList();

          final pageExists =
              currentRequestIndex < _allExpenseRecentResult.length;

          if (pageExists) {
            _allExpenseRecentResult[currentRequestIndex] = expenses;
          } else {
            _allExpenseRecentResult.add(expenses);
          }

          final allExpenses = _allExpenseRecentResult.fold<List<ExpenseModel>>(
              [], (initialValue, pageItems) => initialValue..addAll(pageItems));
          // #12: Broadcast all expenses
          _expenseRecentlyController.add(allExpenses);
          // Check is only Expense
          _isOnlyExpense = allExpenses.length == 1;
        }
      },
    );
  }

  /// Transaction List
  StreamController<List<ExpenseModel>> _expenseController =
      StreamController<List<ExpenseModel>>.broadcast();

  List<List<ExpenseModel>> _allExpensePageResult = [];
  DocumentSnapshot? _lastDocument;
  bool _hasMoreExpenses = true;
  bool _isOnlyExpense = false;

  Stream listenToExpensesRealTime(
      {required String uid, required String groupId}) {
    _requestExpenses(uid, groupId);
    return _expenseController.stream;
  }

  // #1: Move the request posts into it's own function
  Future _requestExpenses(String uid, String groupId,
      {bool loadMore = false}) async {
    final CollectionReference expenseCollectionRef = _firebaseDatabase
        .collectionRef!
        .doc(uid)
        .collection(DefaultConfig.groupCollection)
        .doc(groupId)
        .collection(DefaultConfig.transactions);
    // #2: split the query from the actual subscription
    var pageExpensesQuery = expenseCollectionRef
        .orderBy(FirebaseStorageConstants.spendTimeField, descending: true)
        // #3: Limit the amount of results
        .limit(DefaultConfig.limitRequest);

    // #5: If we have a document start the query after it
    if (_lastDocument != null) {
      pageExpensesQuery = pageExpensesQuery.startAfterDocument(_lastDocument!);
    }

    // If hasMoreExpenses if false, push current expenseList to stream
    if (!_hasMoreExpenses) {
      final allExpenses = _allExpensePageResult.fold<List<ExpenseModel>>(
          [], (initialValue, pageItems) => initialValue..addAll(pageItems));
      _expenseController.add(allExpenses);
      return;
    }

    // #7: Get and store the page index that the results belong to
    final currentRequestIndex = _allExpensePageResult.length;

    pageExpensesQuery.snapshots().listen((expensesSnapshot) {
      // If Expense List has only one expense
      if (expensesSnapshot.docs.isEmpty && _isOnlyExpense) {
        _isOnlyExpense = false;
        _expenseController.add([]);
      } else if (expensesSnapshot.docs.isNotEmpty) {
        final expenses = expensesSnapshot.docs
            .map((snapshot) => ExpenseModel.fromJson(
                snapshot.data() as Map<String, dynamic>, snapshot.id))
            .toList();

        // #8: Check if the page exists or not
        final pageExists = currentRequestIndex < _allExpensePageResult.length;

        // #9: If the page exists update the posts for that page
        if (pageExists) {
          _allExpensePageResult[currentRequestIndex] = expenses;
        }
        // #10: If the page doesn't exist add the page data
        else {
          _allExpensePageResult.add(expenses);
        }

        // #11: Concatenate the full list to be shown
        final allExpenses = _allExpensePageResult.fold<List<ExpenseModel>>(
            [], (initialValue, pageItems) => initialValue..addAll(pageItems));
        // #12: Broadcase all posts
        _expenseController.add(allExpenses);

        // #13: Save the last document from the results only if it's the current last page
        if (currentRequestIndex == _allExpensePageResult.length - 1) {
          _lastDocument = expensesSnapshot.docs.last;
        }

        // #14: Determine if there's more posts to request
        _hasMoreExpenses = expenses.length == DefaultConfig.limitRequest;

        // Check is only Expense
        _isOnlyExpense = allExpenses.length == 1;
      }
    });
  }

  void requestMoreData({required String uid, required String groupId}) =>
      _requestExpenses(uid, groupId, loadMore: true);

  void clear() {
    _expenseController = StreamController<List<ExpenseModel>>.broadcast();
    _allExpensePageResult = [];
    _lastDocument = null;
    _hasMoreExpenses = true;
    _isOnlyExpense = false;
  }

  Future<ExpenseModel> getExpenseWithSpendTime(
      String uid, bool descending) async {
    final CollectionReference expenseCollection = _firebaseDatabase
        .collectionRef!
        .doc(uid)
        .collection(DefaultConfig.expenseCollection);
    final expenseQuery = await expenseCollection
        .orderBy(FirebaseStorageConstants.spendTimeField,
            descending: descending)
        .limit(1)
        .get();
    if (expenseQuery.docs.isNotEmpty) {
      final expenseDoc = expenseQuery.docs[0];
      final expenseModel = ExpenseModel.fromJson(
          expenseDoc.data() as Map<String, dynamic>, expenseDoc.id);
      return expenseModel;
    }
    return ExpenseModel.normalSpendTime();
  }

  Future<List<PhotoModel>> getPhotos(
      String uid, String groupId, String transactionId) async {
    final photoCollection = await _firebaseDatabase.collectionRef
        ?.doc(uid)
        .collection(DefaultConfig.groupCollection)
        .doc(groupId)
        .collection(DefaultConfig.transactions)
        .doc(transactionId)
        .collection(DefaultConfig.photos)
        .get();
    if (photoCollection != null && photoCollection.docs.isNotEmpty) {
      final photots = photoCollection.docs
          .map((e) => PhotoModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return photots;
    } else {
      return [];
    }
  }
}
