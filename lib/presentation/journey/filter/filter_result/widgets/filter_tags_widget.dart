import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/flutter_tag/flutter_tags.dart';

class FilterTagsWidget extends StatelessWidget {
  final Map<String, String> tagMap;
  final Function(String) removeTag;

  const FilterTagsWidget({
    Key? key,
    required this.tagMap,
    required this.removeTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Tags(
        itemCount: tagMap.length,
        horizontalScroll: true,
        itemBuilder: (index) {
          final String key = tagMap.keys.toList()[index];
          final String title = tagMap[key]!;
          return _tagItem(
            index: index,
            title: title,
            remove: () => removeTag(key),
          );
        },
      ),
    );
  }

  Widget _tagItem({int? index, String? title, Function? remove}) {
    return Chip(
      label: Text(
        title!,
        style: ThemeText.getDefaultTextTheme()
            .textDateRange
            .copyWith(fontWeight: FontWeight.w600, color: AppColor.white),
      ),
      backgroundColor: AppColor.primaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: const BorderSide(width: 1, color: AppColor.primaryColor)),
      deleteIcon: Container(
        margin: const EdgeInsets.only(left: 5),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: AppColor.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.clear, color: Colors.white, size: 12),
      ),
      onDeleted: () {
        remove!();
      },
    );
  }
}
