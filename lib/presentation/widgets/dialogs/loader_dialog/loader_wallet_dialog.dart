import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/loader/loading_flare_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';

class LoaderWalletDialog {
  static LoaderWalletDialog? _instance;
  static bool _showing = false;

  LoaderWalletDialog._internal();

  LoaderWalletDialog.getInstance() {
    _instance ??= LoaderWalletDialog._internal();
  }

  bool get showing => _showing;

  void show(BuildContext context, {bool enableBack = true}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          _showing = true;
          return WillPopScope(
            onWillPop: () async {
              return enableBack;
            },
            child: Material(
                color: Colors.transparent,
                child: FlareLoadingWidget(
                  textColor: AppColor.white,
                )),
          );
        });
  }

  void hide(BuildContext context, {bool forcePop = false}) {
    // remove _context in pop
    if (forcePop) {
      Navigator.of(context).pop();
    } else if (_showing) {
      _showing = false;
      Navigator.of(context).pop();
    }
  }
}
