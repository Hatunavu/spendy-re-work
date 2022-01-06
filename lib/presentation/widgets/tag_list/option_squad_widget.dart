import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/tag_list/tag_list_widget.dart';

import 'tag_list_constants.dart';

class OptionSquadWidget extends StatelessWidget {
  final String? optionIconPath;
  final String? optionName;
  final List<String>? tagList;
  final String? selectOption;
  final bool? useActionButton;
  final bool? needAddMore;
  final bool? isShowMore;
  final Function(String selectTag, bool active)? onSelectTag;
  final Function()? onTapActionButton;
  final Function() onTapAddMore;
  final Widget? actionButton;

  const OptionSquadWidget({
    Key? key,
    this.optionIconPath,
    this.optionName,
    this.tagList,
    this.selectOption,
    this.onSelectTag,
    this.actionButton,
    this.onTapActionButton,
    required this.onTapAddMore,
    this.needAddMore = false,
    this.useActionButton = false,
    this.isShowMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _headerOptionSquadWidget(),
        TagListConstants.spacingBetweenHeaderAndTags,
        TagListWidget(
          alignment: WrapAlignment.start,
          needAddMore: needAddMore!,
          tagList: tagList,
          selectTag: selectOption ?? '',
          onTapTag: onSelectTag,
          onTapAddMore: onTapAddMore,
          isShowMore: isShowMore,
        )
      ],
    );
  }

  Widget _headerOptionSquadWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                optionIconPath!,
                height: LayoutConstants.iconSize20,
              ),
              TagListConstants.spacingBetweenIconAndTitle,
              Text(
                optionName!,
                style: ThemeText.getDefaultTextTheme().captionSemiBold,
              )
            ],
          ),
        ),
        Visibility(
          visible: useActionButton!,
          child: GestureDetector(
            onTap: onTapActionButton,
            child: actionButton,
          ),
        )
      ],
    );
  }
}
