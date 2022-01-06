import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/flare_keys_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/flare_controller.dart';

import '../../alert_flare_widget_form.dart';

class FlareLoadMoreWidget extends StatelessWidget {
  final _controller = MyFlareController();
  final bool
      marginBottom; // when have appbar in scaffold, should set this = true

  FlareLoadMoreWidget({Key? key, this.marginBottom = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      child: FittedBox(
        child: AlertFlareWidgetForm(
            flareController: _controller,
            flareName: IconConstants.loadingWalletFlare,
            marginBottom: marginBottom,
            keyFlare: FlareKeysConstants.loadingWalletKey,
            actionText: ''),
      ),
    );
  }
}
