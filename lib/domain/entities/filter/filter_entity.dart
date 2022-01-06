// import 'package:spendy_re_work/data/model/filter/date_filter_model.dart';
// import 'package:spendy_re_work/data/model/filter/filter_model.dart';
// import 'package:spendy_re_work/domain/entities/filter/expense_range_entity.dart';
//
// import 'date_filter_entity.dart';
//
// class FilterEntity {
//   List<String> categories;
//   List<DateFilterEntity> dateFilterList;
//   List<int> groupFilters;
//   ExpenseRangeEntity expenseRange;
//
//   FilterEntity({
//     this.categories,
//     this.dateFilterList,
//     this.groupFilters,
//     this.expenseRange,
//   });
//
//   factory FilterEntity.fromJSON(Map<String, dynamic> json) => FilterEntity(
//     categories: json['categoryIds'],
//         dateFilterList: json['dateFilterList'],
//         groupFilters: json['groupFilters'],
//         expenseRange: json['expenseRange'],
//       );
//
//   factory FilterEntity.toDefault() => FilterEntity(
//     categories: [],
//         dateFilterList: [],
//         groupFilters: [],
//         expenseRange: ExpenseRangeEntity.toDefault(),
//       );
//
//   FilterModel toModel() {
//     final List<DateFilterModel> dateFilterModels = [];
//     for (final DateFilterEntity dateFilterEntity in this.dateFilterList) {
//       dateFilterModels.add(dateFilterEntity.toModel());
//     }
//     return FilterModel(
//       categoryIds: categories,
//       dateFilterList: dateFilterModels,
//       groupFilters: groupFilters,
//       expenseRange: expenseRange.toModel(),
//     );
//   }
//
//   @override
//   String toString() {
//     return super.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     Map<String, dynamic> data = {};
//     data['categoryIds'] = categories;
//     data['dateFilterList'] = dateFilterList;
//     data['groupFilters'] = groupFilters;
//     data['expenseRange'] = expenseRange;
//     return data;
//   }
// }
