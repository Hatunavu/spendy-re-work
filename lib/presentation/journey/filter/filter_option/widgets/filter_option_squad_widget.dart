import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/tag_list/option_squad_widget.dart';
import 'package:spendy_re_work/presentation/theme/font_size_constants.dart';

class FilterOptionSquadWidget extends StatelessWidget {
  final String? optionIconPath;
  final String? optionName;
  final List<String>? optionItemList;
  final String? selectOption;
  final Function(String selectOptionTag, bool active) onSelectOptionTag;
  final Function() onPressDeleteButton;
  final Function() onTapAddMore;
  final bool? isShowMore;
  final bool needAddMore;
  final bool showDeleteButton;

  const FilterOptionSquadWidget({
    Key? key,
    this.optionIconPath,
    this.optionName,
    this.optionItemList,
    this.selectOption,
    required this.onSelectOptionTag,
    required this.onTapAddMore,
    this.needAddMore = false,
    this.showDeleteButton = false,
    this.isShowMore,
    required this.onPressDeleteButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: FilterConstants.spacingBetweenOptions),
      child: OptionSquadWidget(
        selectOption: selectOption ?? '',
        optionName: optionName,
        optionIconPath: optionIconPath,
        tagList: optionItemList,
        onSelectTag: onSelectOptionTag,
        needAddMore: needAddMore,
        onTapAddMore: onTapAddMore,
        isShowMore: isShowMore,
        actionButton: Text(
          FilterConstants.deleteButton,
          style: ThemeText.getDefaultTextTheme().caption?.copyWith(
              color: AppColor.primaryColor,
              fontSize: FontSizeConstants.fzCaption),
        ),
        useActionButton: showDeleteButton,
        onTapActionButton: onPressDeleteButton,
      ),
    );
  }
}
