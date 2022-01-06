import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/flare_keys_constants.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';

import '../alert_flare_widget_form.dart';
import '../alert_widgets_constants.dart';
import '../flare_controller.dart';

class FailedFlareWidget extends StatelessWidget {
  final Function() callback;
  final String? actionText;

  final _controller = MyFlareController();
  final bool marginBottom;

  FailedFlareWidget(
      {required this.callback,
      this.marginBottom = false,
      this.actionText = AlertWidgetsConstants.textTryAgain});

  @override
  Widget build(BuildContext context) {
    return AlertFlareWidgetForm(
      flareController: _controller,
      flareName: IconConstants.errorFlare,
      keyFlare: FlareKeysConstants.errorKey,
      marginBottom: marginBottom,
      actionText: actionText!,
      callback: callback,
    );
  }
}
