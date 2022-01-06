import 'dart:io';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:spendy_re_work/data/datasources/remote/transaction_remote_datasource.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';
import 'package:spendy_re_work/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl extends TransactionRepository {
  final TransactionRemoteDataSource transactionRemoteDataSource;

  TransactionRepositoryImpl({required this.transactionRemoteDataSource});

  @override
  Future<List<String>> uploadImageUrls(
          {List<Asset>? imageAssets, List<File>? imageFiles, String? uid}) =>
      transactionRemoteDataSource.uploadImages(
          imageAssets: imageAssets, imageFiles: imageFiles, uid: uid);

  @override
  Future<ExpenseEntity?> addTransaction(
          {required String uid,
          required String groupId,
          required ExpenseEntity transaction}) =>
      transactionRemoteDataSource.addTransaction(
          uid: uid, groupId: groupId, transaction: transaction.toModel());

  @override
  Future<void> deleteTransaction(
          {required String uid,
          required String groupId,
          required String transactionId}) =>
      transactionRemoteDataSource.deleteTransaction(
          uid: uid, groupId: groupId, transactionId: transactionId);

  @override
  Future<ExpenseEntity?> getTransactionById(
          {required String uid,
          required String groupId,
          required String transactionId}) =>
      transactionRemoteDataSource.getTransactionById(
          uid: uid, groupId: groupId, transactionId: transactionId);

  @override
  Future<void> updateTransaction(
          {required String uid,
          required String groupId,
          required ExpenseEntity transaction}) =>
      transactionRemoteDataSource.updateTransaction(
          uid: uid, groupId: groupId, transaction: transaction.toModel());

  @override
  Future<void> addPhotos(
          {required String uid,
          required String groupId,
          required String transactionId,
          required List<PhotoEntity> photos}) =>
      transactionRemoteDataSource.addPhotos(
          uid: uid,
          groupId: groupId,
          transactionId: transactionId,
          photos: photos.map((e) => e.toModel()).toList());

  @override
  void clear() => transactionRemoteDataSource.clear();

  @override
  Future<ExpenseEntity> getExpenseWithSpendTime(String uid, bool descending) =>
      transactionRemoteDataSource.getExpenseWithSpendTime(uid, descending);

  @override
  Stream listenTransactionsRealTime(
          {required String uid, required String groupId}) =>
      transactionRemoteDataSource.listenToExpensesRealTime(
          uid: uid, groupId: groupId);

  @override
  void requestMoreTransactions(
          {required String uid, required String groupId}) =>
      transactionRemoteDataSource.requestMoreData(uid: uid, groupId: groupId);

  @override
  Stream listenTransactionsRecently({required String uid}) =>
      transactionRemoteDataSource.listenToExpensesRecently(uid: uid);

  @override
  Future<List<PhotoEntity>> getPhotos(
          String uid, String groupId, String transactionId) =>
      transactionRemoteDataSource.getPhotos(uid, groupId, transactionId);
}
