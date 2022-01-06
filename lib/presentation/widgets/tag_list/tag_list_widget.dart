import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/category_name_map.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

import 'tag_list_constants.dart';

class TagListWidget extends StatelessWidget {
  final WrapAlignment alignment;
  final List<String>? tagList;
  final String? selectTag;
  final bool needAddMore;
  final Function() onTapAddMore;
  final bool? isShowMore;
  final Function(String selectTag, bool active)? onTapTag;

  const TagListWidget({
    Key? key,
    this.tagList,
    this.onTapTag,
    this.alignment = WrapAlignment.start,
    this.needAddMore = false,
    this.isShowMore = true,
    this.selectTag,
    required this.onTapAddMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Wrap(
          spacing: 7.w,
          children: List.generate(
              needAddMore ? tagList!.length + 1 : tagList!.length, (index) {
            if (index == tagList?.length) {
              return Visibility(
                  visible: isShowMore ?? false,
                  child: ActionChip(
                      onPressed: onTapAddMore,
                      label: Text(
                        TagListConstants.addMoreTagTitle,
                        style: ThemeText.getDefaultTextTheme()
                            .textDateRange
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: AppColor.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: const BorderSide(
                            width: 1, color: AppColor.hindColor),
                      )));
            }
            final bool active = selectTag == tagList![index];
            return ActionChip(
              label: Text(_mapTitle(tagList![index], index),
                  style: ThemeText.getDefaultTextTheme().textDateRange.copyWith(
                        fontWeight: FontWeight.w600,
                        color: active
                            ? AppColor.white
                            : AppColor.textFilterNonActive,
                      )),
              onPressed: () => onTapTag!(tagList![index], !active),
              backgroundColor: active ? AppColor.primaryColor : AppColor.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: const BorderSide(color: AppColor.hindColor, width: 1)),
            );
          }),
        ));
  }

  String _mapTitle(String cateKey, int index) {
    final nameCate = CategoryCommon.categoryNameMap[cateKey];

    if (nameCate == null) {
      return index == tagList!.length
          ? TagListConstants.addMoreTagTitle
          : cateKey;
    }
    return nameCate;
  }
}
