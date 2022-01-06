enum CategoryType {
  expense,
  goal,
}

extension CateogryTypeExtension on CategoryType {
  String get name {
    switch (this) {
      case CategoryType.expense:
        return 'EXPENSE';
      case CategoryType.goal:
        return 'GOAL';
      default:
        return '';
    }
  }
}
