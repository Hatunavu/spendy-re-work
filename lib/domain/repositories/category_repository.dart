import 'package:spendy_re_work/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getGoalCategoryList(String uid);

  Future<List<CategoryEntity>> getExpenseCategoryList(String uid);
  Future createDefaultCategory(String uid, List<CategoryEntity> categories);
}
