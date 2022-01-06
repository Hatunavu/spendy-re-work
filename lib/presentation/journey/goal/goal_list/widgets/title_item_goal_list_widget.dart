import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/category_name_map.dart';
import 'package:spendy_re_work/domain/entities/goal_entity.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/items_widget/item_list_widget_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';

class TitleItemGoalListWidget extends StatelessWidget {
  final GoalEntity goal;
  final String currency;

  TitleItemGoalListWidget(this.goal, this.currency);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            CategoryCommon.categoryNameMap[goal.category]!,
            style: ThemeText.getDefaultTextTheme().textMenu,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: ItemListWidgetConstants.itemPaddingHorizontal,
        ),
        Container(
//          color: Colors.red,
          alignment: Alignment.centerRight,
          width: 105.w,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${(goal.amount).toString().formatStringToCurrency()}',
              style: ThemeText.getDefaultTextTheme().textMoneyMenu,
            ),
          ),
        ),
      ],
    );
  }
}
