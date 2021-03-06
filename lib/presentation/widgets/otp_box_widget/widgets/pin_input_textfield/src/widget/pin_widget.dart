import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendy_re_work/presentation/widgets/otp_box_widget/widgets/pin_input_textfield/src/builder/color_builder.dart';
import 'package:spendy_re_work/presentation/widgets/otp_box_widget/widgets/pin_input_textfield/src/decoration/pin_decoration.dart';
import 'package:spendy_re_work/presentation/widgets/otp_box_widget/widgets/pin_input_textfield/src/util/utils.dart';

const _kDefaultPinLength = 6;
const _kDefaultDecoration =
    BoxLooseDecoration(strokeColorBuilder: FixedColorBuilder(Colors.cyan));

class PinInputTextField extends StatefulWidget {
  /// The max length of pin.
  final int? pinLength;

  /// The callback will execute when user click done.
  final ValueChanged<String>? onSubmit;

  /// Decorate the pin.
  final PinDecoration? decoration;

  /// Just like [TextField]'s inputFormatter.
  final List<TextInputFormatter> inputFormatters;

  /// Just like [TextField]'s keyboardType.
  final TextInputType keyboardType;

  /// Controls the pin being edited.
  final TextEditingController? controller;

  /// Same as [TextField]'s autoFocus.
  final bool autoFocus;

  /// Same as [TextField]'s focusNode.
  final FocusNode? focusNode;

  /// Same as [TextField]'s textInputAction.
  final TextInputAction textInputAction;

  /// Same as [TextField]'s enabled.
  final bool enabled;

  /// Same as [TextField]'s onChanged.
  final ValueChanged<String>? onChanged;

  /// Same as [TextField]'s textCapitalization
  final TextCapitalization textCapitalization;

  /// Same as [TextField]'s autocorrect
  final bool autocorrect;

  /// Same as [TextField]'s enableInteractiveSelection
  final bool enableInteractiveSelection;

  /// Same as [TextField]'s toolbarOptions
  final ToolbarOptions? toolbarOptions;

  /// Same as [TextField]'s autofillHints
  final Iterable<String>? autofillHints;

  PinInputTextField({
    Key? key,
    this.pinLength: _kDefaultPinLength,
    this.onSubmit,
    this.decoration: _kDefaultDecoration,
    List<TextInputFormatter>? inputFormatter,
    this.keyboardType: TextInputType.phone,
    this.controller,
    this.focusNode,
    this.autoFocus = false,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
    this.onChanged,
    textCapitalization,
    this.autocorrect = false,
    this.enableInteractiveSelection = false,
    this.toolbarOptions,
    this.autofillHints,
  })  :

        /// pinLength must larger than 0.
        /// If pinEditingController isn't null, guarantee the [pinLength] equals to the pinEditingController's _pinMaxLength
        assert(pinLength != null && pinLength > 0, ''),
        assert(decoration != null, ''),

        /// Hint length must equal to the [pinLength].
        assert(
            decoration!.hintText == null ||
                decoration.hintText!.length == pinLength,
            ''),
        inputFormatters = inputFormatter ??
            <TextInputFormatter>[
              LengthLimitingTextInputFormatter(pinLength),
            ]
          ..add(LengthLimitingTextInputFormatter(pinLength)),
        textCapitalization = textCapitalization ?? TextCapitalization.none,
        super(key: key);

  @override
  State createState() {
    return _PinInputTextFieldState();
  }
}

class _PinInputTextFieldState extends State<PinInputTextField> {
  /// The display text to the user.
  String? _text;

  TextEditingController? _controller;

  TextEditingController get _effectiveController =>
      (widget.controller ?? _controller)!;

  void _pinChanged() {
    setState(_updateText);
  }

  void _updateText() {
    if (_effectiveController.text.runes.length > widget.pinLength!) {
      _text = String.fromCharCodes(
          _effectiveController.text.runes.take(widget.pinLength!));
    } else {
      _text = _effectiveController.text;
    }

    widget.decoration!.notifyChange(_text!);
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
    }
    _effectiveController.addListener(_pinChanged);

    //Ensure the initial value will be displayed when the field didn't get the focus.
    _updateText();
  }

  @override
  void dispose() {
    // Ensure no listener will execute after dispose.
    _effectiveController.removeListener(_pinChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(PinInputTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller == null && oldWidget.controller != null) {
      oldWidget.controller!.removeListener(_pinChanged);
      _controller =
          TextEditingController.fromValue(oldWidget.controller!.value);
      _controller!.addListener(_pinChanged);
    } else if (widget.controller != null && oldWidget.controller == null) {
      _controller!.removeListener(_pinChanged);
      _controller = null;
      widget.controller!.addListener(_pinChanged);
      // Invalidate the text when controller hold different old text.
      if (_text != widget.controller!.text) {
        _pinChanged();
      }
    } else if (widget.controller != oldWidget.controller) {
      // The old controller and current controller is not null and not the same.
      oldWidget.controller!.removeListener(_pinChanged);
      widget.controller!.addListener(_pinChanged);
    }

    /// If the newLength is shorter than now and the current text length longer
    /// than [pinLength], So we should cut the superfluous subString.
    if (oldWidget.pinLength! > widget.pinLength! &&
        _text!.runes.length > widget.pinLength!) {
      setState(() {
        _text = _text!.substring(0, widget.pinLength);
        _effectiveController
          ..text = _text!
          ..selection = TextSelection.collapsed(offset: _text!.runes.length);
      });
    }

    // make sure the the first time the decoration would take effective
    widget.decoration!.notifyChange(_text!);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      /// The foreground paint to display pin.
      foregroundPainter: _PinPaint(
        text: _text!,
        pinLength: widget.pinLength!,
        decoration: widget.decoration!,
        themeData: Theme.of(context),
      ),
      child: TextField(
        /// Actual textEditingController.
        controller: _effectiveController,

        /// Fake the text style.
        style: TextStyle(
          /// Hide the editing text.
          color: Colors.transparent,
          // To hide the cursor when in select mode
          fontSize: platformMiniFontSize(),
        ),

        /// Hide the Cursor
        showCursor: false,

        /// Autofill hints for the underlying platform.
        autofillHints: widget.autofillHints,

        /// Whether to correct the user input.
        autocorrect: widget.autocorrect,

        /// Center the input to make more natural.
        textAlign: TextAlign.center,

        /// Options of the edit menu
        toolbarOptions: widget.toolbarOptions,

        /// Disable the actual textField selection.
        enableInteractiveSelection: widget.enableInteractiveSelection,

        /// The maxLength of the pin input, the default value is 6.
        maxLength: widget.pinLength,

        /// If use system keyboard and user click done, it will execute callback
        /// Note!!! Custom keyboard in Android will not execute, see the related issue [https://github.com/flutter/flutter/issues/19027]
        onSubmitted: widget.onSubmit,

        /// Default text input type is number.
        keyboardType: widget.keyboardType,

        /// only accept digits.
        inputFormatters: widget.inputFormatters,

        /// Defines the keyboard focus for this widget.
        focusNode: widget.focusNode,

        /// {@macro flutter.widgets.editableText.autofocus}
        autofocus: widget.autoFocus,

        /// The type of action button to use for the keyboard.
        ///
        /// Defaults to [TextInputAction.done]
        textInputAction: widget.textInputAction,

        onChanged: widget.onChanged,

        enabled: widget.enabled,

        textCapitalization: widget.textCapitalization,

        /// Clear default text decoration.
        decoration: InputDecoration(
          /// Hide the counterText
          counterText: '',

          /// Bind the error text from pin decoration to this input decoration.
          errorText: widget.decoration!.errorText,

          /// Bind the style of error text from pin decoration to
          /// this input decoration.
          errorStyle: widget.decoration!.errorTextStyle,

          // Disabled this as it doesn't show error or
          enabled: false,

          /// Hide the all border.
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class PinInputTextFormField extends FormField<String> {
  /// Controls the pin being edited.
  final TextEditingController? controller;

  /// The max length of pin.
  final int? pinLength;

  /// Just like [TextField]'s inputFormatter.
  final List<TextInputFormatter> inputFormatters;

  PinInputTextFormField({
    Key? key,
    this.controller,
    String? initialValue,
    this.pinLength = _kDefaultPinLength,
    ValueChanged<String>? onSubmit,
    PinDecoration? decoration = _kDefaultDecoration,
    List<TextInputFormatter>? inputFormatter,
    TextInputType keyboardType = TextInputType.phone,
    FocusNode? focusNode,
    bool autoFocus = false,
    TextInputAction textInputAction = TextInputAction.done,
    bool enabled = true,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    @Deprecated("'autovalidate' is deprecated and shouldn't be used, use 'autovalidateMode' instead")
        bool autovalidate = false,
    AutovalidateMode? autovalidateMode = AutovalidateMode.disabled,
    ValueChanged<String>? onChanged,
    TextCapitalization? textCapitalization,
    bool autocorrect = false,
    bool enableInteractiveSelection = false,
    ToolbarOptions? toolbarOptions,
    Iterable<String>? autofillHints,
  })  : assert(initialValue == null || controller == null, ''),
        assert(autovalidateMode != null, ''),
        assert(pinLength != null && pinLength > 0, ''),

        /// pinLength must larger than 0.
        /// If pinEditingController isn't null, guarantee the [pinLength] equals to the pinEditingController's _pinMaxLength
        assert(pinLength != null && pinLength > 0, ''),
        assert(decoration != null, ''),

        /// Hint length must equal to the [pinLength].
        assert(
            decoration!.hintText == null ||
                decoration.hintText!.length == pinLength,
            ''),
        inputFormatters = inputFormatter ??
            <TextInputFormatter>[
              LengthLimitingTextInputFormatter(pinLength),
            ]
          ..add(LengthLimitingTextInputFormatter(pinLength)),
        super(
            key: key,
            initialValue:
                controller != null ? controller.text : (initialValue ?? ''),
            onSaved: onSaved,
            validator: (value) {
              final result = validator!(value);
              if (result == null) {
                if (value!.isEmpty) {
                  return 'Input field is empty.';
                }
                if (value.length < pinLength!) {
                  if (pinLength - value.length > 1) {
                    return 'Missing ${pinLength - value.length} digits of input.';
                  } else {
                    return 'Missing last digit of input.';
                  }
                }
              }
              return result;
            },

            // ignore: deprecated_member_use, deprecated_member_use_from_same_package
            autovalidate: autovalidate,
            autovalidateMode: autovalidateMode,
            enabled: enabled,
            builder: (FormFieldState<String> field) {
              final _PinInputTextFormFieldState state =
                  field as _PinInputTextFormFieldState;
              return PinInputTextField(
                pinLength: pinLength,
                onSubmit: onSubmit,
                decoration:
                    decoration?.copyWith(errorText: field.errorText ?? ''),
                inputFormatter: inputFormatter,
                keyboardType: keyboardType,
                controller: state._effectiveController,
                focusNode: focusNode,
                autoFocus: autoFocus,
                textInputAction: textInputAction,
                enabled: enabled,
                onChanged: onChanged,
                textCapitalization: textCapitalization,
                enableInteractiveSelection: enableInteractiveSelection,
                autocorrect: autocorrect,
                toolbarOptions: toolbarOptions,
                autofillHints: autofillHints,
              );
            });

  @override
  _PinInputTextFormFieldState createState() => _PinInputTextFormFieldState();
}

class _PinInputTextFormFieldState extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController get _effectiveController =>
      (widget.controller ?? _controller)!;

  @override
  PinInputTextFormField get widget => super.widget as PinInputTextFormField;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    }
    _effectiveController.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(PinInputTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller == null && oldWidget.controller != null) {
      oldWidget.controller!.removeListener(_handleControllerChanged);
      _controller =
          TextEditingController.fromValue(oldWidget.controller!.value);
      _controller!.addListener(_handleControllerChanged);
    } else if (widget.controller != null && oldWidget.controller == null) {
      _controller!.removeListener(_handleControllerChanged);
      _controller = null;
      widget.controller!.addListener(_handleControllerChanged);
      // Invalidate the text when controller hold different old text.
      if (value != widget.controller!.text) {
        _handleControllerChanged();
      }
    } else if (widget.controller != oldWidget.controller) {
      // The old controller and current controller is not null and not the same.
      oldWidget.controller!.removeListener(_handleControllerChanged);
      widget.controller!.addListener(_handleControllerChanged);
    }

    /// If the newLength is shorter than now and the current text length longer
    /// than [pinLength], So we should cut the superfluous subString.
    if (oldWidget.pinLength! > widget.pinLength! &&
        value!.runes.length > widget.pinLength!) {
      setState(() {
        setValue(value!.substring(0, widget.pinLength));
        _effectiveController
          ..text = value!
          ..selection = TextSelection.collapsed(
            offset: value!.runes.length,
          );
      });
    }
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController.text = widget.initialValue!;
    });
  }

  @override
  void didChange(String? value) {
    if (value!.runes.length > widget.pinLength!) {
      super.didChange(String.fromCharCodes(
        value.runes.take(widget.pinLength!),
      ));
    } else {
      super.didChange(value);
    }
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController.text != value) {
      didChange(_effectiveController.text);
    }
  }
}

class _PinPaint extends CustomPainter {
  final String text;
  final int pinLength;
  final PinEntryType type;
  final PinDecoration decoration;
  final ThemeData? themeData;

  _PinPaint({
    required this.text,
    required this.pinLength,
    PinDecoration? decoration,
    this.type: PinEntryType.boxTight,
    this.themeData,
  }) : decoration = decoration!.copyWith(
          textStyle: (decoration.textStyle ?? themeData!.textTheme.headline5)!,
          errorTextStyle: decoration.errorTextStyle ??
              themeData!.textTheme.caption!
                  .copyWith(color: themeData.errorColor),
          hintTextStyle: decoration.hintTextStyle ??
              themeData!.textTheme.headline5!
                  .copyWith(color: themeData.hintColor),
        );

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;

  @override
  void paint(Canvas canvas, Size size) {
    decoration.drawPin(canvas, size, text, pinLength, themeData!);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _PinPaint &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          pinLength == other.pinLength &&
          type == other.type &&
          decoration == other.decoration &&
          themeData == other.themeData;

  @override
  int get hashCode =>
      text.hashCode ^
      pinLength.hashCode ^
      type.hashCode ^
      decoration.hashCode ^
      themeData.hashCode;
}
