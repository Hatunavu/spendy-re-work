import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/presentation/journey/login/blocs/login_bloc/login_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/blocs/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/login_verify_otp/verify_otp_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/background_logo_widget/background_logo_widget.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/alert_dialog/alert_dialog.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/loader_dialog/loader_wallet_dialog.dart';
import 'package:spendy_re_work/presentation/widgets/otp_box_widget/otp_box_widget.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String phone;
  final String phoneCode;
  final String verificationId;

  const VerifyOTPScreen(this.phone, this.verificationId, this.phoneCode);

  @override
  _VerifyOTPScreenState createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final _ctrlTextFieldOTP = TextEditingController();
  late LoginBloc _loginBloc;
  late VerifyOtpBloc _verifyOtpBloc;
  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _verifyOtpBloc = BlocProvider.of<VerifyOtpBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyOtpBloc, VerifyOtpState>(
      listener: (context, state) {
        if (state is OtpLoading) {
          LoaderWalletDialog.getInstance().show(context, enableBack: false);
        } else if (state is VerifyOTPSuccess) {
          _handlingVerifyOTPSuccess(
              state.isCreateProfile ?? true, state.isChooseCurrency ?? true);
        } else if (state is VerifyOTPFailed) {
          _handlingVerifyOtpFailed(state.exception);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BackgroundLogoWidget(
            leadingTop: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios,
                color: AppColor.iconColor,
              ),
            ),
            child: BlocBuilder<VerifyOtpBloc, VerifyOtpState>(
              builder: (context, state) {
                return Column(
                  children: [
                    SizedBox(
                      height: VerifyOtpConstant.paddingTopBody,
                    ),
                    Text(
                      VerifyOtpConstant.textTitle,
                      style: ThemeText.getDefaultTextTheme()
                          .subtitle1!
                          .copyWith(
                              fontSize: VerifyOtpConstant.fzTitle,
                              color: AppColor.primaryDarkColor),
                    ),
                    SizedBox(
                      height: VerifyOtpConstant.paddingTopSubTit,
                    ),
                    Text(VerifyOtpConstant.textSubTit,
                        style: ThemeText.getDefaultTextTheme()
                            .bodyText1!
                            .copyWith(
                                fontSize: VerifyOtpConstant.fzBody,
                                color: AppColor.primaryDarkColor)),
                    Text(
                      widget.phone,
                      style: ThemeText.getDefaultTextTheme()
                          .bodyText1!
                          .copyWith(
                              fontSize: VerifyOtpConstant.fzBody,
                              color: AppColor.primaryDarkColor),
                    ),
                    SizedBox(
                      height: VerifyOtpConstant.paddingTopNumberField,
                    ),
                    OTPBoxWidget(
                      ctrlTextFieldOTP: _ctrlTextFieldOTP,
                      resendCallback: _handlingResendCode,
                      secondsNumber: VerifyOtpConstant.timeOutResendSecond,
                      validCodeCallback: _validCodeCallback,
                    ),
                  ],
                );
              },
            )),
      ),
    );
  }

  void _handlingVerifyOTPSuccess(bool isCreateProfile, bool isChooseCurrency) {
    LoaderWalletDialog.getInstance().hide(context);
    if (isCreateProfile) {
      Navigator.pushReplacementNamed(context, RouteList.createProfile,
          arguments: {KeyConstants.routeKey: RouteList.loginVerifyCode});
    } else if (isChooseCurrency) {
      Navigator.pushReplacementNamed(context, RouteList.chooseCurrency);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteList.home, (route) => false,
          arguments: {KeyConstants.tabIndexArg: 0});
    }
  }

  void _handlingVerifyOtpFailed(Exception exception) {
    LoaderWalletDialog.getInstance().hide(context);
    _ctrlTextFieldOTP.clear();
    AlertDialogSpendy.showDialogOneAction(
      context,
      VerifyOtpConstant.textBodyAlert,
      VerifyOtpConstant.textButtonAlert,
      title: VerifyOtpConstant.textTitleAlert,
    );
  }

  void _handlingResendCode() {
    _ctrlTextFieldOTP.clear();
    _loginBloc.add(ResendOTP());
  }

  void _validCodeCallback(String otp, bool isTimerRunning) {
    debugPrint(otp);
    if (isTimerRunning) {
      _verifyOtpBloc.add(PressedVerifyOTP(
        otp,
        widget.verificationId,
        widget.phoneCode,
      ));
    } else {
      _verifyOtpBloc.add(SendFailedOTPEvent());
    }
  }
}
