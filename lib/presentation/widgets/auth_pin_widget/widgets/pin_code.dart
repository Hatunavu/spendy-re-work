import 'package:flutter/material.dart';

import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class PinCode extends StatefulWidget {
  final String title;
  final double size;
  final Function()? onPressed;
  final Color color;
  final Color colorTapDown;
  final double borderRadius;
  final int timeAnimationButton;
  final bool isDisabledPinCode;

  PinCode({
    Key? key,
    this.title = '',
    this.color = Colors.white,
    this.colorTapDown = Colors.black,
    this.size = 80,
    this.onPressed,
    this.borderRadius = 0,
    this.timeAnimationButton = 110,
    this.isDisabledPinCode = false,
  }) : super(key: key);

  @override
  _PinCodeState createState() => _PinCodeState();
}

class _PinCodeState extends State<PinCode> {
  bool? _stateSeleted;
  int? _timeAnimation;

  @override
  void initState() {
    _stateSeleted = false;
    _timeAnimation = widget.timeAnimationButton;
    super.initState();
  }

  void changeState(bool state) {
    if (state) {
      setState(() {
        _stateSeleted = state;
      });
      return;
    }
    // if (mounted && _timeAnimation != 0) {
    //   Timer(
    //       Duration(milliseconds: state ? 0 : _timeAnimation),
    //       () => setState(() {
    //             _stateSeleted = state;
    //           }));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ValueKey('number_${widget.title}'),
      onTapDown: (tapDowm) => changeState(true),
      onTapUp: (tapUp) => changeState(false),
      onTapCancel: () => changeState(false),
      onTap: !widget.isDisabledPinCode
          ? () {
              changeState(true);
              widget.onPressed!();
            }
          : null,
      child: AnimatedContainer(
        duration: Duration(milliseconds: _timeAnimation!),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.primaryDarkColor, width: 2),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        width: widget.size,
        height: widget.size,
        child: Center(
          child: AnimatedDefaultTextStyle(
            style: TextStyle(color: _getColor(_stateSeleted!)),
            duration: Duration(
              milliseconds: (_stateSeleted! ? 0 : _timeAnimation)!,
            ),
            child: Text(
              widget.title,
              style: ThemeText.getDefaultTextTheme()
                  .bodyText1!
                  .copyWith(fontSize: 25.sp, color: AppColor.textColor),
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(bool selected) => widget.isDisabledPinCode
      ? AppColor.primaryColor
      : selected
          ? Colors.white
          : Colors.black;
}
