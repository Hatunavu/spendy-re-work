import 'package:spendy_re_work/presentation/journey/filter/filter_constants.dart';

class ExpenseRange {
  int? start;
  int? end;

  ExpenseRange({
    this.start,
    this.end,
  });

  factory ExpenseRange.toDefault() => ExpenseRange(
      start: FilterConstants.minExpenseRange.toInt(),
      end: FilterConstants.maxExpenseRange.toInt());

  bool containsDefault() {
    if (start == FilterConstants.minExpenseRange.toInt() &&
        end == FilterConstants.maxExpenseRange.toInt()) {
      return true;
    }
    return false;
  }

  bool get isSafe => start != null && end != null;

  @override
  String toString() => 'ExpenseRange(start: $start, end: $end)';
}
