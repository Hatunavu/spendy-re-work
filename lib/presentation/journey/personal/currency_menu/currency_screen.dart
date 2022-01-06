import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/alert_dialog/alert_dialog_constants.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/alert_dialog/alert_dialog.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/loader_dialog/loader_wallet_dialog.dart';
import 'bloc/choose_currency_bloc.dart';
import 'widgets/body_currency_widget.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';

class ChooseCurrencyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<ChooseCurrencyBloc, ChooseCurrencyState>(
          listener: (context, state) {
            if (state is CurrencyActionLoadingState) {
              LoaderWalletDialog.getInstance().show(context, enableBack: false);
            } else if (state is CurrencySaveFailure) {
              Navigator.pop(context);
              AlertDialogSpendy.showDialogOneAction(
                  context,
                  AlertDialogConstants.textErrorSimple,
                  AlertDialogConstants.textOk,
                  title: AlertDialogConstants.textTitleSimple);
            } else if (state is CurrencySaveSuccess) {
              _chooseCurrencySuccess(context);
            }
          },
          child: BodyChooseCurrencyWidget()),
    );
  }

  void _chooseCurrencySuccess(BuildContext context) {
    LoaderWalletDialog.getInstance().hide(context);
    Navigator.pushNamedAndRemoveUntil(context, RouteList.home, (route) => false,
        arguments: {KeyConstants.tabIndexArg: 0});
  }
}
