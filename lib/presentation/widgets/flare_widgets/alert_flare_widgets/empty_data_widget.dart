import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/flare_keys_constants.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/appbar_constants.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/alert_widgets_constants.dart';

import '../flare_controller.dart';

class EmptyDataWidget extends StatelessWidget {
  EmptyDataWidget(
      {this.emptyDataMessage = 'Empty data', this.marginBottom = false});

  final bool marginBottom;
  final String emptyDataMessage;
  final _controller = MyFlareController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
            bottom: marginBottom ? AppbarConstants.heightAppbar.height : 0),
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: FlareActor(IconConstants.emptyDataFlare,
                      controller: _controller,
                      alignment: Alignment.center,
                      fit: BoxFit.scaleDown,
                      callback: _controller.play,
                      animation: FlareKeysConstants.emptyDataKey),
                ),
              ),
            ),
            Text(
              emptyDataMessage,
              style: AlertWidgetsConstants.textErrorActionStyle
                  .copyWith(color: AppColor.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
