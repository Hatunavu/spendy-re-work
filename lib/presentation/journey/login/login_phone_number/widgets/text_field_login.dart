import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/utils/validator_utils.dart';
import 'package:spendy_re_work/presentation/journey/login/blocs/validator_bloc/validator_bloc.dart';

import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

import '../login_phone_num_const.dart';
import 'country_list_pick.dart';

class TextFieldLogin extends StatefulWidget {
  final String phoneCountry;
  final bool? isValid;
  final String? phone;
  final bool? isButtonOnPressed;
  final bool? isInit;
  TextFieldLogin(
      {required this.phoneCountry,
      this.isValid,
      this.isInit,
      this.phone,
      this.isButtonOnPressed});

  @override
  _TextFieldLoginState createState() => _TextFieldLoginState();
}

class _TextFieldLoginState extends State<TextFieldLogin> {
  final _phoneCtrl = TextEditingController();
  final _focus = FocusNode();

  final _typeValidator = TypeValidator.phone;
  String? lastValue;

  @override
  void initState() {
    if (widget.phone != null) {
      _phoneCtrl.text = widget.phone!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String textHint =
        '${widget.phoneCountry} ${LoginPhoneNumberConstant.textHideField}';

    return TextFormField(
      enableInteractiveSelection: false,
      controller: _phoneCtrl,
      focusNode: _focus,
      keyboardType: TextInputType.phone,
      style: ThemeText.getDefaultTextTheme().textField.copyWith(
            fontSize: LoginPhoneNumberConstant.fzTextField,
          ),
      textAlign: TextAlign.left,
      textAlignVertical: TextAlignVertical.center,
      onChanged: (text) {
        _validatorPhone(context, text);
        // _handlePastePhoneNumber(text);
        lastValue = text;
      },
      decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(
            minWidth: LoginPhoneNumberConstant.widthFlag,
          ),
          prefixIcon: CountryPickList(widget.phoneCountry),
          hintStyle: ThemeText.getDefaultTextTheme().textHint.copyWith(
                fontSize: LoginPhoneNumberConstant.fzHintField,
              ),
          hintText: textHint,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: AppColor.primaryColor),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: AppColor.red),
          ),
          errorText: (_focus.hasFocus || widget.isButtonOnPressed!) &&
                  !widget.isInit! &&
                  (widget.isValid == null ||
                      widget.phone == null ||
                      widget.phone!.isEmpty)
              ? LoginPhoneNumberConstant.textPhoneEmptyInvalid
              : (widget.isValid != null && !widget.isValid!)
                  ? LoginPhoneNumberConstant.textPhoneInvalid
                  : null,
          errorStyle: ThemeText.getDefaultTextTheme()
              .textErrorField
              .copyWith(fontSize: LoginPhoneNumberConstant.fzErrorField)),
    );
  }

  void _validatorPhone(BuildContext context, String text) {
    BlocProvider.of<ValidatorBloc>(context)
        .add(SendValidate(data: text, typeValidator: _typeValidator));
  }
}
