import 'package:spendy_re_work/common/enums/category_type.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';

class DefaultCategory {
  static List<CategoryEntity> getDefault(int createAt) {
    final List<CategoryEntity> categories = [
      CategoryEntity(
          name: 'TRAVEL',
          type: CategoryType.expense,
          color: 'ff1ab8fe'.toColor(),
          createAt: createAt),
      CategoryEntity(
          name: 'HEALTH',
          type: CategoryType.expense,
          color: 'fffd7e7e'.toColor(),
          createAt: createAt),
      CategoryEntity(
          name: 'BEAUTY',
          type: CategoryType.expense,
          color: 'fffc5a99'.toColor(),
          createAt: createAt),
      CategoryEntity(
          name: 'BILL_FEES',
          type: CategoryType.expense,
          color: 'ffa161eb'.toColor(),
          createAt: createAt),
      CategoryEntity(
          name: 'OTHER',
          type: CategoryType.expense,
          color: 'ffa161eb'.toColor(),
          createAt: createAt),
      CategoryEntity(
          name: 'ENTERTAINMENT',
          type: CategoryType.expense,
          color: 'ff3082c9'.toColor(),
          createAt: createAt),
      CategoryEntity(
          name: 'OFFICE',
          type: CategoryType.expense,
          color: 'fff08d45'.toColor(),
          createAt: createAt),
      CategoryEntity(
          name: 'TRANSPORT',
          type: CategoryType.expense,
          color: 'ff02b3b3'.toColor(),
          createAt: createAt),
      CategoryEntity(
          name: 'GROCERIES',
          type: CategoryType.expense,
          color: 'ffffc657'.toColor(),
          createAt: createAt),
      CategoryEntity(
          name: 'FOOD_DRINK',
          type: CategoryType.expense,
          color: 'ff7077ea'.toColor(),
          createAt: createAt),
      CategoryEntity(
          name: 'EDUCATION_PLAN',
          type: CategoryType.goal,
          color: 'fffd7e7e'.toColor(),
          createAt: createAt),
      CategoryEntity(
          name: 'BUY_HOUSE',
          type: CategoryType.goal,
          color: 'ffffc657'.toColor(),
          createAt: createAt),
      CategoryEntity(
          name: 'SHOPPING',
          type: CategoryType.goal,
          color: 'ff7077ea'.toColor(),
          createAt: createAt),
      CategoryEntity(
          name: 'BUY_CAR',
          type: CategoryType.goal,
          color: 'ffb2e8e8'.toColor(),
          createAt: createAt),
      CategoryEntity(
          name: 'HAVE_A_VACATION',
          type: CategoryType.goal,
          color: 'ff1ab8fe'.toColor(),
          createAt: createAt),
      CategoryEntity(
          name: 'OTHER',
          type: CategoryType.goal,
          color: 'ffa161eb'.toColor(),
          createAt: createAt),
    ];
    return categories;
  }
}
