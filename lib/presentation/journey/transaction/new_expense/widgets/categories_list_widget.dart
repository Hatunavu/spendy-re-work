import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/category_name_map.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class CategoriesListWidget extends StatelessWidget {
  final Function(CategoryEntity)? onTapCategoryTags;
  final CategoryEntity? selectCategory;
  final List<CategoryEntity>? categories;

  const CategoriesListWidget(
      {Key? key, this.onTapCategoryTags, this.selectCategory, this.categories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: NewExpenseConstants.newExpensePaddingHorizontal,
          top: NewExpenseConstants.categoryPaddingTop,
          right: NewExpenseConstants.newExpensePaddingHorizontal),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          const SizedBox(height: 18.5),
          _categoriesWidget()
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Row(
      children: <Widget>[
        Image.asset(IconConstants.categoryIcon,
            height: NewExpenseConstants.categoryIconHeight,
            width: NewExpenseConstants.categoryIconWidth),
        const SizedBox(
          width: NewExpenseConstants.categoriesListSpacing,
        ),
        Text(
          NewExpenseConstants.categoriesTitle,
          style: ThemeText.getDefaultTextTheme().textMenu,
        )
      ],
    );
  }

  Widget _categoriesWidget() {
    return Container(
        width: double.infinity,
        child: Wrap(
          spacing: 7.w,
          children: List.generate(categories!.length, (index) {
            return ActionChip(
              label: Text(
                CategoryCommon.categoryNameMap[categories![index].name]!,
                style: ThemeText.getDefaultTextTheme().textDateRange.copyWith(
                    fontWeight: FontWeight.w600,
                    color: categories![index].color),
              ),
              backgroundColor: categories![index].color!.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(
                      width: 1,
                      color: (selectCategory != null &&
                              selectCategory!.name! == categories![index].name!)
                          ? categories![index].color!
                          : AppColor.transparent)),
              onPressed: () {
                if (onTapCategoryTags != null) {
                  onTapCategoryTags!(categories![index]);
                }
              },
            );
          }),
        ));
  }
}
