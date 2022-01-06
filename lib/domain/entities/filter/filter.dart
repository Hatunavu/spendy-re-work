import 'package:spendy_re_work/domain/entities/filter/date_filter_entity.dart';
import 'package:spendy_re_work/domain/entities/filter/expense_range_entity.dart';

class Filter {
  String? category;
  DateFilter? dateFilter;
  ExpenseRange? range;

  Filter({this.category, this.dateFilter, this.range});

  factory Filter.toDefault() => Filter(
      category: '', dateFilter: DateFilter(), range: ExpenseRange.toDefault());

  bool get isCategorySafe => category != null && category!.isNotEmpty;

  @override
  String toString() =>
      'Filter(category: $category, dateFilter: $dateFilter, range: $range)';
}
