import 'package:spendy_re_work/common/constants/firebase_storage_constants.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/repositories/category_repository.dart';

class CategoriesUseCase {
  final CategoryRepository categoryRepository;

  CategoriesUseCase({required this.categoryRepository});

  /// ===== GET =====
  Future<List<CategoryEntity>> getCategoryListCate(
    String uid,
    String categoryType,
  ) async {
    List<CategoryEntity> listExpense = [];
    if (categoryType == FirebaseStorageConstants.transactionType) {
      listExpense = await categoryRepository.getExpenseCategoryList(uid);
    } else {
      listExpense = await categoryRepository.getGoalCategoryList(uid);
    }
    return listExpense;
  }

  Future<CategoryEntity?> getCategoryByName(
      {List<CategoryEntity>? categoryList, String? currentCategoryName}) async {
    for (final CategoryEntity category in categoryList!) {
      if (category.name == currentCategoryName) {
        return category;
      }
    }
    return null;
  }

  Future<List<String>> getAllids(Map<String, CategoryEntity> categoryMap, List<String> keys) async {
    final List<String> ids = [];
    for (final String key in keys) {
      final CategoryEntity category = categoryMap[key]!;
      ids.add(category.id!);
    }
    return ids;
  }

  Future<List<String>> getidFromSuggestCategories({
    Map<String, CategoryEntity>? categoryMap,
    String? keyWord,
  }) async {
    if (keyWord == null || keyWord.isEmpty) {
      return [];
    }
    final List<String> suggestionCategoryList = [];
    for (final String categoryName in categoryMap!.keys.toList()) {
      if (categoryName.toLowerCase().contains(keyWord.toLowerCase())) {
        suggestionCategoryList.add(categoryMap[categoryName]!.id!);
      }
    }
    return suggestionCategoryList;
  }

  Future<Map<String, CategoryEntity>> getCategoryEntityFilterMap(
      {Map<String, CategoryEntity>? categoryMap, List<String>? categoryFilterList}) async {
    if (categoryFilterList == null || categoryFilterList.isEmpty) {
      return {};
    }
    final Map<String, CategoryEntity> categoryFilterMap = {};
    for (final CategoryEntity categoryEntity in categoryMap!.values.toList()) {
      if (categoryFilterList.contains(categoryEntity.id)) {
        categoryFilterMap[categoryEntity.name!] = categoryEntity;
      }
    }
    return categoryFilterMap;
  }

  /// ===== CONVERT MAP TO LIST =====
  List<String> mapCategoryListToKeyList(List<CategoryEntity> categories) {
    final List<String> keys = [];
    for (final element in categories) {
      keys.add(element.name!);
    }
    return keys;
  }

  /// ===== CREATE =====
  Future<Map<String, CategoryEntity>> addCategoryToMap({List<CategoryEntity>? categories}) async {
    final Map<String, CategoryEntity> categoryMap = {};
    for (final CategoryEntity category in categories!) {
      categoryMap[category.name!] = category;
    }
    return categoryMap;
  }

  Future createDefaultCategory(String uid, List<CategoryEntity> categories) =>
      categoryRepository.createDefaultCategory(uid, categories);

  /// ===== REMOVE =====

  Map<String, CategoryEntity> removeCategoryFilter(
      {Map<String, CategoryEntity>? categoryFilterMap, String? categoryName}) {
    categoryFilterMap!.remove(categoryName);
    return categoryFilterMap;
  }

  /// ===== OTHER =====

  Future<bool> checkNoEmptyCategorySet(Set<String> categorySet) async {
    if ( //categorySet != null &&
        categorySet.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
