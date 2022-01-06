import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';

abstract class SearchRepository {
  Stream listenSearchRecent(String uid, String groupId);
  Stream listenSearchResult({String? uid, String? key});
  void searchRequestMore({String? uid, String? key});
  Stream listenAllExpense(String uid, String groupId);
  Future<void> updateSearchRecent(
      String uid, String groupId, ExpenseEntity expense);
  Future<void> deleteSearchRecent(
      String uid, String groupId, String transactionId);
}
