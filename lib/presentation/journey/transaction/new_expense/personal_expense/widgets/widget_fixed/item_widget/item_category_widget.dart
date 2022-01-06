import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/category_name_map.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class ItemCategoryWidget extends StatelessWidget {
  const ItemCategoryWidget(
      {Key? key,
      required this.categoryEntity,
      required this.onPressed,
      required this.isCategory})
      : super(key: key);
  final CategoryEntity categoryEntity;
  final Function() onPressed;
  final bool isCategory;
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent),
        child: ActionChip(
          backgroundColor: categoryEntity.color?.withOpacity(0.3),
          shadowColor: Colors.transparent,
          label: Text(CategoryCommon.categoryNameMap[categoryEntity.name] ?? '',
              style: ThemeText.getDefaultTextTheme().textDateRange.copyWith(
                    fontWeight: FontWeight.w600,
                    color: categoryEntity.color,
                  )),
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.sp),
              side: BorderSide(
                  width: 1,
                  color: isCategory
                      ? categoryEntity.color ?? Colors.transparent
                      : Colors.transparent)),
        ));
  }
}
