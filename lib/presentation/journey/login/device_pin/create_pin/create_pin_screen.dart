import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/domain/entities/user/security_entity.dart';
import 'package:spendy_re_work/presentation/journey/login/device_pin/create_pin/bloc/create_pin_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/device_pin/device_pin_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/auth_pin_widget/auth_pin_code.dart';
import 'package:spendy_re_work/presentation/widgets/auth_pin_widget/auth_pin_constants.dart';
import 'package:spendy_re_work/presentation/widgets/auth_pin_widget/widgets/list_dots.dart';
import 'package:spendy_re_work/presentation/widgets/background_logo_widget/background_logo_widget.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/loader/loader_widget/loader_widget.dart';

import 'create_pin_constants.dart';

class CreatePINScreen extends StatelessWidget {
  final SecurityEntity settingsEntity;

  CreatePINScreen({required this.settingsEntity});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(DevicePinConstants.configPassCodeFailed);
        return true;
      },
      child: Scaffold(
        body: BackgroundLogoWidget(
            child: Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocConsumer<CreatePinBloc, CreatePinState>(
                listener: (context, state) {
                  if (state is ConfirmSuccessState) {
                    _createdPinCode(context, state.routeName);
                  }
                },
                builder: (context, state) {
                  if (state is FirstStepState) {
                    return AuthPinCode(
                      key:
                          const ValueKey(CreatePINScreenConstants.createPinKey),
                      title: CreatePINScreenConstants.textCreate,
                      listDots: ListDots(
                        color: Colors.transparent,
                        colorSelected: AppColor.primaryDarkColor,
                        countDots: AuthPinConstants.lengthPinCode,
                        countSelect: state.listPinCode!.length,
                        size: AuthPinConstants.dotSize,
                      ),
                      listPinCode: state.listPinCode,
                      showFingerprint: true,
                      showPassWordButton: true,
                      showBackButton: true,
                      onChangePinCode: (pin) => _onChangePinCode(context, pin),
                      textWrong: 'PIN cannot be repeated number',
                      timeAnimationButton:
                          AuthPinConstants.timeAnimationFirstStep,
                      onTapBackButton: () => Navigator.of(context)
                          .pop(DevicePinConstants.configPassCodeFailed),
                    );
                  }
                  if (state is SecondStepState) {
                    return AuthPinCode(
                      // this key is identified between confirm no error
                      // and confirm has error
                      key: ValueKey(
                          '${CreatePINScreenConstants.confirmPinKey}${state.isError}'),
                      title: CreatePINScreenConstants.textConfirm,
                      listDots: ListDots(
                        color: Colors.transparent,
                        colorSelected: AppColor.primaryDarkColor,
                        countDots: AuthPinConstants.lengthPinCode,
                        countSelect: state.listPinCode!.length,
                        size: AuthPinConstants.dotSize,
                      ),
                      listPinCode: state.listPinCode,
                      showBackButton: true,
                      showFingerprint: true,
                      showError: state.isError!,
                      showPassWordButton: true,
//            useFaceId: ,
                      onChangePinCode: (pin) => _onChangePinCode(context, pin),
                      onTapBackButton: () => _onTapBackButton(context),
                      timeAnimationButton:
                          AuthPinConstants.timeAnimationFirstStep,
                    );
                  }
                  if (state is ConfirmSuccessState) {
                    return LoadingContainer();
                  }
                  return Container();
                },
              )),
        )),
      ),
    );
  }

  void _onChangePinCode(BuildContext context, String pin) {
    if (pin.length == AuthPinConstants.lengthPinCode) {
      BlocProvider.of<CreatePinBloc>(context)
          .add(ConfirmPinCodeEvent(pin, settingsEntity));
    } else {
      // update dots was selected
      BlocProvider.of<CreatePinBloc>(context).add(ChangedPinCode(pin));
    }
  }

  void _onTapBackButton(BuildContext context) {
    BlocProvider.of<CreatePinBloc>(context).add(BackStepEvent());
  }

  void _createdPinCode(BuildContext context, String routeName) {
    Navigator.pop(context, ModalRoute.withName(routeName));
  }
}
