import 'package:spendy_re_work/data/datasources/remote/report_datasource.dart';
import 'package:spendy_re_work/domain/repositories/report_repository.dart';

class ReportRepositoryImpl extends ReportRepository {
  final ReportDataSource reportDataSource;

  ReportRepositoryImpl({required this.reportDataSource});

  @override
  Stream listenToHomeReport(
          {required String uid, required int startDay, required int endDate}) =>
      reportDataSource.listenToExpensesHomeReport(
        uid: uid,
        startDay: startDay,
        endDate: endDate,
      );

  @override
  void loadMoreReportYearData({String? uid, int? startDay, int? endDate}) =>
      reportDataSource.requestMoreReportDataByYear(
          uid: uid, startDay: startDay, endDate: endDate);

  @override
  void clear() => reportDataSource.clear();
}
