import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/journey/goal/create_goal/create_goal_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/app_dialog/app_dialog.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/dialog_constants.dart';

class GoalAchieveConfirmDialog extends StatelessWidget {
  final Function() onPressedYes;
  final Function() onPressedNo;

  const GoalAchieveConfirmDialog({
    Key? key,
    required this.onPressedYes,
    required this.onPressedNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: CreateGoalConstants.achieve,
      rightButtonTitle: CreateGoalConstants.achieve,
      leftButtonTitle: CreateGoalConstants.cancel,
      content: _content(),
      rightAction: onPressedYes,
      leftAction: onPressedNo,
    );
  }

  Widget _content() => Padding(
        padding: const EdgeInsets.only(
          top: DialogConstants.spaceBetweenContentAndButton,
          right: DialogConstants.transactionDialogPadding,
        ),
        child: Text(
          CreateGoalConstants.confirmContent,
          style: ThemeText.getDefaultTextTheme().caption,
        ),
      );
}
