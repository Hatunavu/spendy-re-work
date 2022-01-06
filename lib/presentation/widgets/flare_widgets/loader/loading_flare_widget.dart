import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/flare_keys_constants.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/appbar_constants.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/alert_widgets_constants.dart';
import '../flare_controller.dart';

class FlareLoadingWidget extends StatelessWidget {
  final _controller = MyFlareController();
  static String loadingMessage = translate('label.please_waiting');
  final bool
      marginBottom; // when have appbar in scaffold, should set this = true

  final Color? textColor;

  FlareLoadingWidget({Key? key, this.marginBottom = false, this.textColor})
      : super(key: key);

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
                  child: FlareActor(IconConstants.loadingWalletFlare,
                      controller: _controller,
                      alignment: Alignment.center,
                      fit: BoxFit.scaleDown,
                      callback: _controller.play,
                      animation: FlareKeysConstants.loadingWalletKey),
                ),
              ),
            ),
            Text(
              loadingMessage,
              style: AlertWidgetsConstants.textErrorActionStyle
                  .copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
