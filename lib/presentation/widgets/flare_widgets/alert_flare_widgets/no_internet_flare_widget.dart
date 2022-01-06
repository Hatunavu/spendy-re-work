import 'package:flutter/material.dart';

import 'package:spendy_re_work/common/constants/flare_keys_constants.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';

import '../alert_flare_widget_form.dart';
import '../flare_controller.dart';

class FlareNoInternetWidget extends StatelessWidget {
  final _controller = MyFlareController();
  final bool marginBottom;

  FlareNoInternetWidget({this.marginBottom = false});

  @override
  Widget build(BuildContext context) {
    return AlertFlareWidgetForm(
      flareController: _controller,
      flareName: IconConstants.noInternetFlare,
      actionText: 'No internet',
      keyFlare: FlareKeysConstants.noInternetKey,
    );
  }
}
