import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/appbar_constants.dart';

import 'flare_controller.dart';
import 'alert_widgets_constants.dart';

class AlertFlareWidgetForm extends StatelessWidget {
  final Function()? callback;
  final String actionText;
  final String flareName;
  final String keyFlare;
  final MyFlareController flareController;
  final Color textColor;
  final String message;
  final bool? marginBottom;
  final double? paddingTopTextAction;

  AlertFlareWidgetForm(
      {this.callback,
      required this.flareName,
      required this.keyFlare,
      required this.flareController,
      required this.actionText,
      this.marginBottom, // when has appbar in scaffold -> this = true
      this.paddingTopTextAction,
      this.textColor = AppColor.primaryColor,
      this.message = 'Error'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
            bottom: marginBottom! ? AppbarConstants.heightAppbar.height : 0),
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.15,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: FlareActor(flareName,
                      controller: flareController,
                      alignment: Alignment.center,
                      fit: BoxFit.scaleDown,
                      callback: flareController.play,
                      animation: keyFlare),
                ),
              ),
            ),
            GestureDetector(
              onTap: callback == null ? null : () => callback!(),
              child: Text(
                actionText,
                style: AlertWidgetsConstants.textErrorActionStyle
                    .copyWith(color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
