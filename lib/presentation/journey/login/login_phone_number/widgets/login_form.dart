import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/utils/validator_utils.dart';
import 'package:spendy_re_work/presentation/journey/login/blocs/login_bloc/login_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/blocs/phone_country_bloc/phone_country_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/blocs/validator_bloc/validator_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/login_phone_number/widgets/text_field_login.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget.dart';
import '../login_phone_num_const.dart';

class LoginPhoneNumberForm extends StatefulWidget {
  @override
  _LoginPhoneNumberFormState createState() => _LoginPhoneNumberFormState();
}

class _LoginPhoneNumberFormState extends State<LoginPhoneNumberForm> {
  bool? _isValid;

  String? _phone;

  String? _phoneCountry;

  bool _isButtonOnPressed = false;

  bool? _isInit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneCountryBloc, PhoneCountryState>(
      builder: (context, state) {
        if (state is PhoneCountriesLoaded) {
          _initStateWhenPhoneHasBeenSelected(context, state);
          return _validatorBlocBuilder(context);
        }
        return const SizedBox();
      },
    );
  }

  Widget _validatorBlocBuilder(BuildContext context) {
    return BlocBuilder<ValidatorBloc, ValidatorState>(
        builder: (context, state) {
      if (state is ValidatorInitial) {
        _isValid = null;
        _isInit = true;
      } else if (state is ValidState) {
        _isValid = true;
        _isInit = false;
        _phone = state.data;
      } else {
        _isValid = false;
        _isInit = false;
        _phone = state.data;
        _isButtonOnPressed = state.isButtonOnPressed!;
      }

      return SizedBox(
        height: LoginPhoneNumberConstant.sizeLoginForm,
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: LoginPhoneNumberConstant.paddingHorizontal),
                  child: TextFieldLogin(
                      phoneCountry: _phoneCountry!,
                      phone: _phone,
                      isValid: _isValid,
                      isInit: _isInit,
                      isButtonOnPressed: _isButtonOnPressed),
                )),
            SizedBox(
              height: LoginPhoneNumberConstant.btnLoginPaddingTop,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _loginButtonWidget(
                context,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _loginButtonWidget(BuildContext context) {
    return ButtonWidget.primary(
      // width: MediaQuery.of(context).size.width * 0.5,
      onPress: () => _onPressedLogin(context),
      title: LoginPhoneNumberConstant.textLogin,
    );
  }

  void _onPressedLogin(BuildContext context) {
    if (_isValid == null || _phone == null) {
      BlocProvider.of<ValidatorBloc>(context).add(SendValidate(
          data: _phone!,
          typeValidator: TypeValidator.phone,
          isButtonOnPressed: true));
    } else if (_isValid!) {
      BlocProvider.of<LoginBloc>(context)
          .add(PressedVerifyPhone(_phone!, phoneCode: _phoneCountry));
    }
  }

  void _initStateWhenPhoneHasBeenSelected(
      BuildContext context, PhoneCountriesLoaded state) {
    _phoneCountry = state.defaultCode;
    BlocProvider.of<ValidatorBloc>(context).add(InitValidatorEvent());
  }
}
