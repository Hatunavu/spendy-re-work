class DateFilter {
  int? start;
  int? end;

  DateFilter({
    this.start,
    this.end,
  });

  bool get isSafe => start != null && end != null;

  @override
  String toString() => 'DateFilter(start: $start, end: $end)';
}
