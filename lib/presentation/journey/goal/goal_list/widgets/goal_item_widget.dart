import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/category_icon_map.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/enums/slide_state.dart';
import 'package:spendy_re_work/domain/entities/goal_entity.dart';
import 'package:spendy_re_work/presentation/journey/goal/goal_list/widgets/goal_item_options_widget.dart';
import 'package:spendy_re_work/presentation/journey/goal/goal_list/widgets/subtitle_item_goal_list_widget.dart';
import 'package:spendy_re_work/presentation/journey/goal/goal_list/widgets/title_item_goal_list_widget.dart';
import 'package:spendy_re_work/presentation/widgets/circle_progress/circular_percent_indicator.dart';
import 'package:spendy_re_work/presentation/widgets/items_widget/item_list_widget_constants.dart';
import 'package:spendy_re_work/presentation/widgets/items_widget/item_widget.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';

class GoalItemWidget extends StatelessWidget {
  final GoalEntity? goalCurrentSelected;
  final GoalEntity? goalSelected;
  final Function() deleteOnPress;
  final SlideState? slideState;
  final String? currency;
  final Function(GoalEntity) openSlide;
  final Function() closeSlide;
  final Function() onTapGoal;

  const GoalItemWidget(
      {Key? key,
      this.goalCurrentSelected,
      this.goalSelected,
      required this.deleteOnPress,
      this.slideState,
      this.currency,
      required this.closeSlide,
      required this.openSlide,
      required this.onTapGoal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapGoal,
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (details.delta.dx <= 0) {
          openSlide(goalCurrentSelected!);
        }
        if (details.delta.dx >= 0) {
          closeSlide();
        }
      },
      child: Row(
        children: [
          Expanded(
            child: ItemWidget(
              showLineBottom: true,
              iconPath: categoryIconMap[goalCurrentSelected?.category]!,
              linePadding: 5.h,
              circleIconWidget: CircularPercentIndicator(
                radius: 55.w,
                circularStrokeCap: CircularStrokeCap.round,
                lineWidth: 6.w,
                percent: goalCurrentSelected!.percentProgress! <= 0
                    ? 0
                    : goalCurrentSelected!.percentProgress,
                center: SizedBox(
                  height: ItemListWidgetConstants.sizeIconLeading,
                  width: ItemListWidgetConstants.sizeIconLeading,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(
                      categoryIconMap[goalCurrentSelected?.category]!,
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
                // progressColor: goal.categoryEntity.color,
                progressColor: goalCurrentSelected?.progressColor?.toColor(),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: LayoutConstants.dimen_26),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TitleItemGoalListWidget(goalCurrentSelected!, currency!),
                    SizedBox(
                      height: ItemListWidgetConstants.subTitlePaddingTop,
                    ),
                    SubTitleItemGoalListWidget(goalCurrentSelected!)
                  ],
                ),
              ),
            ),
          ),
          GoalItemOptionWidget(
            goalEntity: goalCurrentSelected,
            goalSelected: goalSelected,
            deleteOnPressed: deleteOnPress,
            slideState: slideState,
          )
        ],
      ),
    );
  }
}
