import 'dart:io';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';

abstract class TransactionRepository {
  Future<ExpenseEntity?> addTransaction({
    required String uid,
    required String groupId,
    required ExpenseEntity transaction,
  });

  Future<List<String>> uploadImageUrls({
    List<Asset>? imageAssets,
    List<File>? imageFiles,
    String? uid,
  });

  Future<ExpenseEntity?> getTransactionById({
    required String uid,
    required String groupId,
    required String transactionId,
  });

  Future<void> deleteTransaction({
    required String uid,
    required String groupId,
    required String transactionId,
  });

  Future<void> updateTransaction({
    required String uid,
    required String groupId,
    required ExpenseEntity transaction,
  });

  Future<void> addPhotos({
    required String uid,
    required String groupId,
    required String transactionId,
    required List<PhotoEntity> photos,
  });

  Stream listenTransactionsRealTime({
    required String uid,
    required String groupId,
  });

  Stream listenTransactionsRecently({required String uid});

  void requestMoreTransactions({
    required String uid,
    required String groupId,
  });

  void clear();

  Future<ExpenseEntity> getExpenseWithSpendTime(String uid, bool descending);
  Future<List<PhotoEntity>> getPhotos(
      String uid, String groupId, String transactionId);
}
