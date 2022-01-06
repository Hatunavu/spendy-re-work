import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/journey/goal/goal_list/goal_page_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/appbar_widget.dart';
import 'package:spendy_re_work/presentation/widgets/seach/search_field_widget.dart';

class GoalAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Function() addGoal;
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final Function(String) onChange;
  final Function() onClearText;
  final bool? showClearButton;
  final FocusNode? focusNode;

  const GoalAppBarWidget(
      {Key? key,
      required this.addGoal,
      required this.controller,
      required this.onSubmitted,
      required this.onChange,
      required this.onClearText,
      this.showClearButton,
      this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      child: SafeArea(
          child: Column(
        children: [
          AppBarWidget(
            title: GoalPageConstants.textGoal,
            actions: [
              GestureDetector(
                onTap: addGoal,
                child: Image.asset(
                  IconConstants.createGoalIcon,
                  height: 17,
                  width: 17,
                ),
              )
            ],
          ),
          const SizedBox(
            height: LayoutConstants.dimen_10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: LayoutConstants.dimen_26),
            child: SearchFieldWidget(
              onSubmitted: onSubmitted,
              onChanged: onChange,
              controller: controller,
            ),
          ),
        ],
      )),
    );
  }

  @override
  Size get preferredSize => GoalPageConstants.heightAppBar;
}
