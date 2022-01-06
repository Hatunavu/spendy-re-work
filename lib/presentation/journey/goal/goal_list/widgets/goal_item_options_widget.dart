import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/enums/slide_state.dart';
import 'package:spendy_re_work/domain/entities/goal_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/widgets/transaction_detail_dialog/transaction_detail_dialog_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class GoalItemOptionWidget extends StatelessWidget {
  final Function() deleteOnPressed;
  final SlideState? slideState;
  final GoalEntity? goalEntity;
  final GoalEntity? goalSelected;

  const GoalItemOptionWidget(
      {Key? key,
      required this.deleteOnPressed,
      this.slideState,
      this.goalEntity,
      this.goalSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: goalSelected != null &&
              goalEntity?.createAt == goalSelected?.createAt &&
              slideState == SlideState.openSlide
          ? 40.w
          : 0,
      height: 30.h,
      child: Padding(
        padding: const EdgeInsets.only(right: LayoutConstants.dimen_10),
        child: _optionItemWidget(
          context,
          iconPath: IconConstants.deleteIcon,
          onTap: deleteOnPressed,
        ),
      ),
    );
  }

  Widget _optionItemWidget(context,
      {String? iconPath, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerRight,
        child: Image.asset(
          iconPath!,
          height: TransactionDetailDialogConstants.iconSize,
          width: TransactionDetailDialogConstants.iconSize,
        ),
      ),
    );
  }
}
