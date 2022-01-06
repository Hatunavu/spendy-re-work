import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/category_name_map.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/goal_entity.dart';
import 'package:spendy_re_work/domain/repositories/search_repository.dart';

import 'expense_usecase.dart';

class SearchUseCase {
  final SearchRepository searchRepository;
  final ExpenseUseCase expenseUseCase;

  SearchUseCase({required this.searchRepository, required this.expenseUseCase});

  Future<List<String>> getCategoryNameList(
      {List<CategoryEntity>? categoryList}) async {
    final List<String> categoryNames = [];
    for (final category in categoryList ?? []) {
      categoryNames.add(category.name!);
    }
    return categoryNames;
  }

  Future<List<String>> getCategoryNameWithKey(
      {Map<String, String>? categoryNameMap, String? key}) async {
    final List<String> result = [];
    categoryNameMap!.values.toList().forEach((name) async {
      if (name.toLowerCase().contains(key!.toLowerCase())) {
        final String mapKey =
            await getCategoryKey(value: name, categoryMapName: categoryNameMap);
        result.add(mapKey);
      }
    });
    return result;
  }

  Stream listenSearchRecently(String uid, String groupId) {
    return searchRepository.listenSearchRecent(uid, groupId);
  }

  Stream listenSearchResult({String? uid, String? key}) =>
      searchRepository.listenSearchResult(uid: uid, key: key);

  void searchRequestMore({String? uid, String? key}) =>
      searchRepository.searchRequestMore(uid: uid, key: key);

  Stream listenAllExpense(String uid, String groupId) =>
      searchRepository.listenAllExpense(uid, groupId);

  Future<Map<String, String>> getMapCategory(
      {List<CategoryEntity>? categories}) async {
    final Map<String, String> categoryMap = {};
    for (final category in categories ?? []) {
      categoryMap[category.name!] =
          CategoryCommon.categoryNameMap[category.name]!;
    }
    return categoryMap;
  }

  Future<String> getCategoryKey(
      {String? value, Map<String, String>? categoryMapName}) async {
    return categoryMapName!.keys
        .firstWhere((key) => categoryMapName[key] == value, orElse: () => '');
  }

  Future<List<GoalEntity>> searchGoal(
      {String? keyword, List<GoalEntity>? goals}) async {
    final List<GoalEntity> result = [];
    //String key = CategoryCommon.getKey(value: keyword);
    for (final goal in goals ?? []) {
      if (goal.name!.toLowerCase().contains(keyword!.toLowerCase()) ||
          translate('category.${goal.category}')
              .toLowerCase()
              .contains(keyword.toLowerCase())) {
        result.add(goal);
      }
    }
    return result;
  }

  Future<List<ExpenseEntity>> searchExpense(
      {String? keyword, List<ExpenseEntity>? allExpense}) async {
    final List<ExpenseEntity> result = [];
    for (final expense in allExpense ?? <ExpenseEntity>[]) {
      if (keyword != null &&
          (expense.note!.toLowerCase().contains(keyword.toLowerCase()) ||
              translate('category.${expense.category}')
                  .toLowerCase()
                  .contains(keyword.toLowerCase()))) {
        result.add(expense);
      }
    }
    return result;
  }
}
