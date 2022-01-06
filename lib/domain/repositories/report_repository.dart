abstract class ReportRepository {
  Stream listenToHomeReport(
      {required String uid, required int startDay, required int endDate});

  void loadMoreReportYearData({String? uid, int? startDay, int? endDate});
  void clear();
}
