import 'package:spendy_re_work/data/datasources/remote/filter_datasource.dart';
import 'package:spendy_re_work/domain/entities/filter/filter.dart';
import 'package:spendy_re_work/domain/repositories/filter_repository.dart';

class FilterRepositoryImpl extends FilterRepository {
  final FilterDataSource filterDataSource;

  FilterRepositoryImpl({required this.filterDataSource});

  @override
  Stream listenToFilter(
          {required String uid,
          required String groupId,
          required Filter filter}) =>
      filterDataSource.listenToFilter(uid, groupId, filter);

  @override
  void loadMoreFilter(
          {required String uid,
          required String groupId,
          required Filter filter}) =>
      filterDataSource.requestMoreFilterData(
        uid,
        groupId,
        filter,
      );

  @override
  void renewFilter(
          {required String uid,
          required String groupId,
          required Filter filter}) =>
      filterDataSource.renewFilter(
        uid,
        groupId,
        filter,
      );
}
