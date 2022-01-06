import 'package:spendy_re_work/data/datasources/remote/search_datasource.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/repositories/search_repository.dart';

class SearchRepositoryImpl extends SearchRepository {
  final SearchDataSource searchDataSource;

  SearchRepositoryImpl({required this.searchDataSource});

  @override
  Stream listenSearchRecent(String uid, String groupId) {
    return searchDataSource.listenSearchRecently(uid, groupId);
  }

  @override
  Stream listenSearchResult({String? uid, String? key}) =>
      searchDataSource.listenSearchRealTime(uid: uid, key: key);

  @override
  void searchRequestMore({String? uid, String? key}) =>
      searchDataSource.searchRequestMore(uid: uid, key: key);

  @override
  Stream listenAllExpense(String uid, String groupId) =>
      searchDataSource.listenAllExpense(uid, groupId);

  @override
  Future<void> deleteSearchRecent(
          String uid, String groupId, String transactionId) =>
      searchDataSource.deleteSearchRecent(uid, groupId, transactionId);

  @override
  Future<void> updateSearchRecent(
          String uid, String groupId, ExpenseEntity expense) =>
      searchDataSource.updateSearchRecent(uid, groupId, expense.toModel());
}
