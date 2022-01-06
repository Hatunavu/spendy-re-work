import 'package:spendy_re_work/domain/entities/category_entity.dart';

class ReportTotalCateEntity {
  CategoryEntity? categoryEntity;
  double total;

  ReportTotalCateEntity({this.categoryEntity, this.total = 0});

  String getPercent(int totalExpense) {
    return (total / totalExpense * 100).toStringAsFixed(1);
  }
}
