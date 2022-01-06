import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/presentation/journey/goal/create_goal/create_goal_bloc/create_goal_bloc.dart';
import 'package:spendy_re_work/presentation/widgets/create_form/element_form_textfield.dart';

import '../../goal_list/goal_page_constants.dart';

class GoalNameFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? initText;

  GoalNameFieldWidget({required this.controller, this.initText});

  @override
  Widget build(BuildContext context) {
    return ElementFormTextField(
      showLineBottom: true,
      showLineTop: true,
      controller: controller,
      initText: initText,
      hintText: GoalPageConstants.textHintGoalName,
      iconPath: IconConstants.goalMenuIcon,
      onChanged: (content) => _onNameChanged(context, content),
    );
  }

  void _onNameChanged(BuildContext context, String content) {
    BlocProvider.of<CreateGoalBloc>(context).add(GoalNameChangeEvent(content));
  }
}
