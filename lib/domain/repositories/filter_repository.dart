import 'package:spendy_re_work/domain/entities/filter/filter.dart';

abstract class FilterRepository {
  Stream listenToFilter(
      {required String uid, required String groupId, required Filter filter});

  void loadMoreFilter(
      {required String uid, required String groupId, required Filter filter});

  void renewFilter(
      {required String uid, required String groupId, required Filter filter});
}
