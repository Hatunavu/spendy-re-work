import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/utils/date_time_utils.dart';
import 'package:spendy_re_work/domain/entities/goal_entity.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/items_widget/item_list_widget_constants.dart';

class SubTitleItemGoalListWidget extends StatelessWidget {
  final GoalEntity goal;

  SubTitleItemGoalListWidget(this.goal);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Visibility(
              visible: goal.name != null,
              child: Text(
                goal.name.toString(),
                style: ThemeText.getDefaultTextTheme().subTextMenu,
                overflow: TextOverflow.ellipsis,
              )),
        ),
        SizedBox(
          width: ItemListWidgetConstants.itemPaddingHorizontal,
        ),
        Visibility(
            visible: goal.expiredDate != null,
            child: Text(
              DateTimeUtils.formatDateTextMonth(
                  DateTime.fromMillisecondsSinceEpoch(goal.date!),
                  languageCode: Localizations.localeOf(context).languageCode),
              style: ThemeText.getDefaultTextTheme().subTextMenu,
            ))
      ],
    );
  }
}
