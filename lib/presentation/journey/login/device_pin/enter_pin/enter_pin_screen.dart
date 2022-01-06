import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/domain/entities/user/security_entity.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/device_pin/enter_pin/bloc/enter_pin_bloc.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/auth_pin_widget/auth_pin_code.dart';
import 'package:spendy_re_work/presentation/widgets/auth_pin_widget/auth_pin_constants.dart';
import 'package:spendy_re_work/presentation/widgets/auth_pin_widget/widgets/list_dots.dart';
import 'package:spendy_re_work/presentation/widgets/background_logo_widget/background_logo_widget.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/loader/loader_widget/loader_widget.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/loader_dialog/loader_wallet_dialog.dart';

import 'enter_pin_constants.dart';

class EnterPINScreen extends StatefulWidget {
  final String? previousRoute;
  final bool isDeletePassCode;
  final SecurityEntity? newSettings;

  EnterPINScreen(
      {this.previousRoute, this.newSettings, this.isDeletePassCode = false});

  @override
  _EnterPINScreenState createState() => _EnterPINScreenState();
}

class _EnterPINScreenState extends State<EnterPINScreen> {
  @override
  void initState() {
    super.initState();
    // if (SchedulerBinding.instance.schedulerPhase ==
    //     SchedulerPhase.persistentCallbacks) {
    //   SchedulerBinding.instance.addPostFrameCallback((_) => Future.delayed(
    //       const Duration(milliseconds: 500),
    //       () => BlocProvider.of<EnterPinBloc>(context).add(ShowScanBioAuth())));
    // }
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) {
    //   BlocProvider.of<EnterPinBloc>(context).add(ShowScanBioAuth());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is UnAuthenticated) {
                _logOut(context);
              } else if (state is AuthenticationLoading) {
                LoaderWalletDialog.getInstance()
                    .show(context, enableBack: false);
              }
            },
            child: BackgroundLogoWidget(
                child: Center(
                    child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildBlocConsumer(context),
            )))),
      ),
    );
  }

  Widget _buildBlocConsumer(BuildContext context) {
    return BlocConsumer<EnterPinBloc, EnterPinState>(
      listener: (context, state) {
        if (state is ConfirmSuccessState) {
          _confirmSuccessPinCode(context);
        }
      },
      builder: (context, state) {
        if (state is ConfirmState) {
          return AuthPinCode(
            // this key is identified between confirm no error
            // and confirm has error
            key: ValueKey(
                '${EnterPINConstants.confirmPinKey}${state.limitTimes}'),
            title: EnterPINConstants.textEnterPIN,
            listDots: ListDots(
              color: Colors.transparent,
              colorSelected: AppColor.primaryDarkColor,
              countDots: AuthPinConstants.lengthPinCode,
              countSelect: state.listPinCode!.length,
              size: AuthPinConstants.dotSize,
            ),
            listPinCode: state.listPinCode,
            showFingerprint: true,
            showError: state.isError,
            showPassWordButton: true,
            textWrong: EnterPINConstants.textWrong(state.limitTimes),
//            useFaceId: ,
            onChangePinCode: (pin) => _onChangePinCode(context, pin),
            timeAnimationButton: AuthPinConstants.timeAnimationFirstStep,
          );
        }
        if (state is ConfirmSuccessState) {
          return LoadingContainer();
        }
        return Container();
      },
    );
  }

  void _onChangePinCode(BuildContext context, String pin) {
    if (pin.length == AuthPinConstants.lengthPinCode) {
      BlocProvider.of<EnterPinBloc>(context).add(ConfirmPinCodeEvent(
          pin: pin,
          isDeletePinCode: widget.isDeletePassCode,
          settingsEntity: widget.newSettings!));
    } else {
      // update dots was selected
      BlocProvider.of<EnterPinBloc>(context).add(ChangedPinCode(pin));
    }
  }

  void _confirmSuccessPinCode(BuildContext context) {
    switch (widget.previousRoute) {
      case RouteList.security:
        // in setting pin code
        Navigator.pop(context, ModalRoute.withName(RouteList.security));
        break;
      case RouteList.welcome:
        // after welcome
        Navigator.of(context)
            .pushNamedAndRemoveUntil(RouteList.home, (route) => false);
        break;
      default:
        // authentication on paused
        Navigator.pop(context);
    }
  }

  void _logOut(BuildContext context) {
    Navigator.pushReplacementNamed(context, RouteList.loginPhone);
  }
}
