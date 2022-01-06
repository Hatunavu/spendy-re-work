import 'package:flutter/material.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/presentation/journey/personal/currency_menu/currency_screen_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class ItemRadioGroup extends StatelessWidget {
  const ItemRadioGroup({
    Key? key,
    required this.group,
    required this.onChangeGroup,
    this.selectedGroup,
  }) : super(key: key);

  final GroupEntity group;
  final GroupEntity? selectedGroup;
  final Function(GroupEntity?) onChangeGroup;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => onChangeGroup(group),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: CurrencyScreenConstants.sizeRadio,
                  width: CurrencyScreenConstants.sizeRadio,
                  child: Radio<GroupEntity>(
                    value: group,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    groupValue: selectedGroup,
                    onChanged: onChangeGroup,
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(child: Text(group.name, style: ThemeText.getDefaultTextTheme().textMenu)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
