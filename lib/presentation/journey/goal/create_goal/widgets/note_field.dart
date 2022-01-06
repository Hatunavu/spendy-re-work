import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/presentation/widgets/create_form/element_form_textfield.dart';

import '../../goal_list/goal_page_constants.dart';

class NoteTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? initText;
  final Function(String) onChangeNote;

  NoteTextFieldWidget(
      {required this.controller, this.initText, required this.onChangeNote});

  @override
  Widget build(BuildContext context) {
    return ElementFormTextField(
      showLineBottom: true,
      controller: controller,
      initText: initText,
      iconPath: IconConstants.noteIcon,
      hintText: GoalPageConstants.textHintNote,
      onChanged: onChangeNote,
    );
  }
}
