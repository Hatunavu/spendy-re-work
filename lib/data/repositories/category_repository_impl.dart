import 'package:spendy_re_work/common/enums/category_type.dart';
import 'package:spendy_re_work/data/datasources/remote/category_datasource.dart';
import 'package:spendy_re_work/data/model/catergory_model.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  final CategoryDataSource categoryDataSource;

  CategoryRepositoryImpl({required this.categoryDataSource});

  @override
  Future<List<CategoryEntity>> getExpenseCategoryList(String uid) =>
      categoryDataSource.getCategoryList(uid, CategoryType.expense.name);

  @override
  Future<List<CategoryEntity>> getGoalCategoryList(String uid) =>
      categoryDataSource.getCategoryList(uid, CategoryType.goal.name);

  @override
  Future createDefaultCategory(
      String uid, List<CategoryEntity> categories) async {
    final List<CategoryModel> categoryModels = [];
    for (final category in categories) {
      categoryModels.add(category.toModel());
    }
    await categoryDataSource.createDefaultCategory(uid, categoryModels);
  }
}
