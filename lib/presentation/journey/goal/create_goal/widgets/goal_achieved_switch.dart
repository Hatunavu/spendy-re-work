import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/presentation/journey/goal/create_goal/create_goal_bloc/create_goal_bloc.dart';
import 'package:spendy_re_work/presentation/journey/goal/create_goal/widgets/goal_archieve_confirm_dialog.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/create_form/create_element_form.dart';

import '../../goal_list/goal_page_constants.dart';

class GoalAchievedSwitchWidget extends StatelessWidget {
  final bool? isGoalAchieved;

  GoalAchievedSwitchWidget(this.isGoalAchieved);

  @override
  Widget build(BuildContext context) {
    return CreateElementFormWidget(
      iconPath: IconConstants.awardIcon,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              GoalPageConstants.textAchieved,
              style: ThemeText.getDefaultTextTheme().textMenu,
            ),
          ),
          Transform.scale(
            scale: GoalPageConstants.scaleSwitch,
            child: CupertinoSwitch(
              value: isGoalAchieved!,
              onChanged: (tick) {
                if (isGoalAchieved!) {
                  BlocProvider.of<CreateGoalBloc>(context)
                      .add(GoalAchievedChangeEvent(tick));
                } else {
                  _confirmAchieve(context, tick);
                }
              },
              activeColor: AppColor.activeColor,
              trackColor: AppColor.trackColor,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmAchieve(BuildContext context, bool tick) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) => GoalAchieveConfirmDialog(
              onPressedNo: () => Navigator.pop(dialogContext),
              onPressedYes: () {
                BlocProvider.of<CreateGoalBloc>(context)
                    .add(GoalAchievedChangeEvent(tick));
                Navigator.of(context).pop();
              },
            ));
  }
}
