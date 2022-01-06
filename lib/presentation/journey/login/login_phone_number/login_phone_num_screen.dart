import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/presentation/journey/login/blocs/login_bloc/login_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/blocs/phone_country_bloc/phone_country_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/blocs/validator_bloc/validator_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/login_phone_number/login_phone_num_const.dart';
import 'package:spendy_re_work/presentation/journey/login/login_phone_number/widgets/login_form.dart';
import 'package:spendy_re_work/presentation/journey/login/login_verify_otp/verify_otp_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/background_logo_widget/background_logo_widget.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/alert_dialog/alert_dialog.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/alert_dialog/alert_dialog_constants.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/loader_dialog/loader_wallet_dialog.dart';
import 'package:spendy_re_work/presentation/widgets/version_widget/version_widget.dart';

class LoginPhoneNumberScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundLogoWidget(child: _loginBlocListener()),
    );
  }

  Widget _loginBlocListener() {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            LoaderWalletDialog.getInstance().show(context, enableBack: false);
          } else if (state is VerifyPhoneSuccess) {
            _handlingVerifyPhoneSuccess(context, state);
          } else if (state is VerifyPhoneFailed) {
            _handlingVerifyPhoneFailed(context);
          } else if (state is LoginNoInternetState) {
            _handlingNoInternet(context);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              _bodyWidget(),
              SizedBox(
                height: LoginPhoneNumberConstant.versionPaddingTop,
              ),
              _bottomWidget(),
            ],
          ),
        ));
  }

  Widget _bodyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: LoginPhoneNumberConstant.paddingTop,
          ),
          _textTitle(),
          SizedBox(
            height: LoginPhoneNumberConstant.formPaddingTop,
          ),
          _loginPhoneNumberFormWidget(),
        ],
      ),
    );
  }

  Widget _loginPhoneNumberFormWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PhoneCountryBloc>(
          create: (_) =>
              Injector.resolve<PhoneCountryBloc>()..add(GetDefaultPhoneCode()),
        ),
        BlocProvider<ValidatorBloc>(
          create: (_) => Injector.resolve<ValidatorBloc>(),
        ),
      ],
      child: LoginPhoneNumberForm(),
    );
  }

  Widget _textTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: LoginPhoneNumberConstant.paddingHorizontal),
      child: Text(
        LoginPhoneNumberConstant.textWelcome,
        style: ThemeText.getDefaultTextTheme().headline5!.copyWith(
            fontSize: LoginPhoneNumberConstant.fzWelcome, letterSpacing: -0.74),
      ),
    );
  }

  Widget _bottomWidget() {
    return VersionInfoWidget();
  }

  void _handlingVerifyPhoneSuccess(
      BuildContext context, VerifyPhoneSuccess state) {
    LoaderWalletDialog.getInstance().hide(context);
    Navigator.pushNamed(context, RouteList.loginVerifyCode, arguments: {
      VerifyOtpConstant.keyArgVerifyId: state.verificationId,
      VerifyOtpConstant.keyArgPhone: state.phone,
      VerifyOtpConstant.keyArgPhoneCode: state.phoneCode,
    });
  }

  void _handlingVerifyPhoneFailed(BuildContext context) {
    LoaderWalletDialog.getInstance().hide(context);
    AlertDialogSpendy.showDialogOneAction(
      context,
      LoginPhoneNumberConstant.textPhoneInvalid,
      AlertDialogConstants.textOk,
      title: LoginPhoneNumberConstant.textTitleAlert,
    );
  }

  void _handlingNoInternet(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      LoaderWalletDialog.getInstance().hide(context);
      AlertDialogSpendy.showDialogOneAction(
        context,
        LoginPhoneNumberConstant.noInternetText,
        AlertDialogConstants.textOk,
        title: LoginPhoneNumberConstant.textTitleAlert,
      );
    });
  }
}
