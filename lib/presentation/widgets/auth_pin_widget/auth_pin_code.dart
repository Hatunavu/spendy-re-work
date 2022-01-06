import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:spendy_re_work/presentation/theme/theme_color.dart';

import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

import 'auth_pin_constants.dart';
import 'widgets/list_dots.dart';
import 'widgets/pin_code.dart';

class AuthPinCode extends StatefulWidget {
  final Color buttonColor;
  final int timeAnimationButton;
  final bool showFingerprint;
  final bool useFaceId;
  final bool showBackButton;
  final Function()? onTapFingerPrint;
  final Function()? onTapBackButton;
  final bool showPassWordButton;
  final Function? onTapPassWord;
  final String title;
  final String textWrong;
  final bool showError;
  final Function(String)? onChangePinCode;
  final ListDots? listDots;
  final List<String>? listPinCode;
  final bool showLoading;
  final bool isDisabledPinCode;
  final double? heightScreen;
  final Widget? customListBox;
  final bool scaleEmptySpace;
  final double? overrideTopPaddingValue;
  final double? overrideTitleTopPaddingValue;

  AuthPinCode({
    Key? key,
    this.buttonColor = const Color(0xfffdc768),
    this.timeAnimationButton = 10,
    this.showFingerprint = false,
    this.useFaceId = false,
    this.onTapFingerPrint,
    this.showPassWordButton = false,
    this.onTapPassWord,
    required this.title,
    required this.listDots,
    this.textWrong = 'PIN cannot be repeated number',
    this.showError = false,
    this.onChangePinCode,
    this.listPinCode,
    this.showLoading = false,
    this.isDisabledPinCode = false,
    this.heightScreen,
    this.customListBox,
    this.showBackButton = false,
    this.onTapBackButton,
    this.scaleEmptySpace = false,
    this.overrideTopPaddingValue,
    this.overrideTitleTopPaddingValue,
  }) : super(key: key);

  @override
  _AuthPinCodeState createState() => _AuthPinCodeState();

  static bool validatePin(String pin) {
    for (int num = 0; num <= 9; num++) {
      final String hasRepetitiveCharacterInPin =
          List.filled(AuthPinConstants.lengthPinCode, num).join();
      if (hasRepetitiveCharacterInPin == pin) {
        return false;
      }
    }
    return true;
//    return !isValidConsequentialNumbers(pin, AuthPinConstants.lengthPincode);
  }
}

class _AuthPinCodeState extends State<AuthPinCode> {
  List<String>? _listPinCode;
  final _ctrPading = const EdgeInsets.symmetric(
    horizontal: 14.0,
    vertical: 8.0,
  );

  @override
  void initState() {
    _listPinCode = widget.listPinCode ?? <String>[];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: _wrapInContainer(
            FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _getTitle(),
                  _renderHeaderContent(),
                  _renderKeyBoardNumber(row: 4, col: 3),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.showBackButton,
          child: Padding(
            padding: EdgeInsets.only(left: 16.4.w, top: 28.4.w),
            child: GestureDetector(
              onTap: widget.onTapBackButton!,
              child: const Icon(Icons.arrow_back_ios),
            ),
          ),
        )
      ],
    );
  }

  Widget _wrapInContainer(Widget child) {
    if (widget.scaleEmptySpace) {
      return Align(
        alignment: Alignment.topCenter,
        child: child,
      );
    }
    return child;
  }

  Widget _getTitle() {
    return Padding(
      padding: EdgeInsets.only(
        top: AuthPinConstants.paddingTop,
      ),
      child: Text(
        widget.title,
        key: const ValueKey(AuthPinKeys.authPinTitleKey),
        style: ThemeText.getDefaultTextTheme().bodyText1!.copyWith(
            fontSize: AuthPinConstants.fzTitle, color: AppColor.textColor),
      ),
    );
  }

  Widget _renderHeaderContent() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: AuthPinConstants.fieldPINPaddingTop),
          child: widget.listDots ?? widget.customListBox,
        ),
        SizedBox(
          height: AuthPinConstants.wrongTextPaddingTop,
        ),
        widget.showError
            ? Text(
                widget.textWrong,
                key: const ValueKey('error_message_easy_pin_predicted'),
                style: TextStyle(color: Colors.red, fontSize: 16.sp),
              )
            : const Text(''),
      ],
    );
  }

  Widget _renderKeyBoardNumber({int? row, int? col}) {
    return Padding(
      padding: EdgeInsets.only(
          top: AuthPinConstants.keyboardPaddingTop,
          bottom: AuthPinConstants.paddingBottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(row!, (int indexC) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              col!,
              (int indexR) => _createPinCodeByIndex(
                index: (indexC * col) + indexR + 1,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _createPinCodeByIndex({int? index}) {
    final fingerColor = widget.isDisabledPinCode
        ? AppColor.hintColor
        : AppColor.primaryDarkColor;

    switch (index) {
      case 10:
        final fingerIcon = widget.useFaceId
            ? Container(
                key: const ValueKey(AuthPinKeys.fingerFaceId),
                color: Colors.transparent,
                padding: const EdgeInsets.all(
                    AuthPinConstants.btnNumberHeight * 0.28),
                width: AuthPinConstants.btnNumberHeight,
                height: AuthPinConstants.btnNumberHeight,
                child: const Icon(Icons.apps),
              )
            : Icon(
                Icons.fingerprint,
                size: 40,
                color: fingerColor,
              );

        return Padding(
          padding: _ctrPading,
          child: GestureDetector(
            key: const ValueKey(AuthPinConstants.btnFingerPrintKey),
            onTap: !widget.isDisabledPinCode ? widget.onTapFingerPrint : null,
            child: Opacity(
              opacity: widget.onTapFingerPrint == null ? 0.2 : 1.0,
              child: SizedBox(
                width: AuthPinConstants.btnNumberHeight,
                height: AuthPinConstants.btnNumberHeight,
                child: widget.showFingerprint ? fingerIcon : const SizedBox(),
              ),
            ),
          ),
        );
      case 12:
        return Padding(
          padding: _ctrPading,
          child: GestureDetector(
            key: const ValueKey(AuthPinConstants.btnDeleteKey),
            onTap: !widget.isDisabledPinCode ? onDelete : null,
            child: SizedBox(
              width: AuthPinConstants.btnNumberHeight,
              height: AuthPinConstants.btnNumberHeight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  AuthPinLanguage.deleteButtonLabel,
                  style: ThemeText.getDefaultTextTheme().bodyText1!.copyWith(
                      fontSize: AuthPinConstants.fzTextDeleteButton,
                      color: AppColor.textColor),
                ),
              ),
            ),
          ),
        );
      case 11:
        index = 0;
        break;
    }
    return Padding(
      padding: _ctrPading,
      child: PinCode(
        color: widget.buttonColor,
        title: '$index',
        borderRadius: 50,
        size: AuthPinConstants.btnNumberHeight,
        timeAnimationButton: widget.timeAnimationButton,
        onPressed: () => _onTapPinCode(index!),
        isDisabledPinCode: widget.isDisabledPinCode,
      ),
    );
  }

  void onDelete() {
    if (_listPinCode?.isNotEmpty ?? false) {
      setState(() {
        _listPinCode!.removeLast();
      });
      widget.onChangePinCode?.call(_getPinCode());
    }
  }

  void _onTapPinCode(int index) {
    debugPrint('>>> _onTapPinCode: ${_listPinCode!.length}');
    if (_listPinCode!.length < AuthPinConstants.lengthPinCode) {
      setState(() {
        _listPinCode?.add(index.toString());
      });
      widget.onChangePinCode?.call(_getPinCode());
    }
  }

  String _getPinCode() {
    final StringBuffer stringBuffer = StringBuffer();
    for (int i = 0; i < _listPinCode!.length; i++) {
      stringBuffer.write(_listPinCode![i]);
    }
    return stringBuffer.toString();
  }
}
