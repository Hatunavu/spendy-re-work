import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/dialog_constants.dart';
import 'package:spendy_re_work/presentation/widgets/state_widget/empty_data_widget.dart';

class EmptyDialogWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: DialogConstants.dialogMarginHorizontal),
      child: EmptyDataWidget(),
    );
  }
}
