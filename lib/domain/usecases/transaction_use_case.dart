import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';
import 'package:spendy_re_work/domain/repositories/transaction_repository.dart';
import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';
import 'package:spendy_re_work/domain/usecases/storage_usecase.dart';

class TransactionUseCase {
  final TransactionRepository _transactionRepository;
  final StorageUseCase _storageUseCase;

  TransactionUseCase(this._transactionRepository, this._storageUseCase);

  Future<ExpenseEntity?> addTransaction({
    required String uid,
    required String groupId,
    required ExpenseEntity transaction,
  }) =>
      _transactionRepository.addTransaction(
          uid: uid, groupId: groupId, transaction: transaction);

  Future<void> updateTransaction({
    required String uid,
    required String groupId,
    required ExpenseEntity transaction,
  }) =>
      _transactionRepository.updateTransaction(
          uid: uid, groupId: groupId, transaction: transaction);

  Future<ExpenseEntity?> getTransactionById({
    required String uid,
    required String groupId,
    required String transactionId,
  }) =>
      _transactionRepository.getTransactionById(
          uid: uid, groupId: groupId, transactionId: transactionId);

  Future<void> deleteTransactionById({
    required String uid,
    required String groupId,
    required String transactionId,
  }) =>
      _transactionRepository.deleteTransaction(
          uid: uid, groupId: groupId, transactionId: transactionId);

  Future<void> addPhotos({
    required String uid,
    required String groupId,
    required String transactionId,
    required List<PhotoEntity> photos,
  }) =>
      _transactionRepository.addPhotos(
        uid: uid,
        groupId: groupId,
        transactionId: transactionId,
        photos: photos,
      );

  /// ===== GET =====

  Stream listenTransactionsRealTime(
          {required String uid, required String groupId}) =>
      _transactionRepository.listenTransactionsRealTime(
          uid: uid, groupId: groupId);

  Stream listenTransactionsRecently({String? uid}) =>
      _transactionRepository.listenTransactionsRecently(uid: uid!);

  void requestMoreTransactions(
          {required String uid, required String groupId}) =>
      _transactionRepository.requestMoreTransactions(
          uid: uid, groupId: groupId);

  void clearTransactionData() => _transactionRepository.clear();

  Future<Map<int, List<ExpenseEntity>>> getExpenseByDayMapWithAds(
      List<ExpenseEntity> expenses) async {
    final Map<int, List<ExpenseEntity>> expenseMap =
        Map<int, List<ExpenseEntity>>();
    for (int i = 0; i < expenses.length; i++) {
      final DateTime dtSpendTime =
          DateTime.fromMillisecondsSinceEpoch(expenses[i].spendTime);
      if (expenseMap[dtSpendTime.intYmd] == null) {
        expenseMap[dtSpendTime.intYmd] = [expenses[i]];
      } else {
        expenseMap[dtSpendTime.intYmd]!.add(expenses[i]);
      }
    }
    return expenseMap;
  }

  Future<List<PhotoEntity>> getPhotos(
      String uid, String groupId, String transactionId) async {
    final items =
        await _transactionRepository.getPhotos(uid, groupId, transactionId);
    return getImageUriRecentList(items);
  }

  Future<List<PhotoEntity>> getImageUriRecentList(
      List<PhotoEntity> imagesList) async {
    final List<PhotoEntity> photos = [];
    for (final PhotoEntity item in imagesList) {
      if (photos.length < 3) {
        final PhotoEntity photo = await _storageUseCase.getPhotoUri(item);
        photos.add(photo);
      } else {
        photos.add(item);
      }
    }
    return photos;
  }

  Future<void> updateSearchRecent(
      String uid, String groupId, ExpenseEntity expnse) async {}
}
