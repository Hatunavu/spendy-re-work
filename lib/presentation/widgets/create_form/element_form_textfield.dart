import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendy_re_work/presentation/journey/goal/goal_list/goal_page_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

import 'create_element_form.dart';

class ElementFormTextField extends StatefulWidget {
  final String iconPath;
  final bool showLineBottom;
  final bool showLineTop;
  final Function(String)? onChanged;
  final Function()? onSelectDuration;
  final Function()? onSelectDate;
  final TextEditingController? controller;
  final String? trailingText;
  final String? hintText;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatters;
  final String? initText; // use when  text controller needs to init value text
  final String? changedText; // use when update value text of controller
  final bool enableField;

  ElementFormTextField(
      {required this.iconPath,
      this.hintText,
      this.changedText,
      this.initText,
      this.enableField = true,
      this.inputFormatters = const [],
      this.textInputType = TextInputType.text,
      this.onChanged,
      this.onSelectDuration,
      this.onSelectDate,
      this.controller,
      this.trailingText,
      this.showLineBottom = false,
      this.showLineTop = false}) {
    if (changedText != null && controller != null) {
      controller!.text = changedText!;
    }
  }

  @override
  _ElementFormTextFieldState createState() => _ElementFormTextFieldState();
}

class _ElementFormTextFieldState extends State<ElementFormTextField> {
  @override
  void initState() {
    if (widget.controller != null && widget.initText != null) {
      widget.controller!.text = widget.initText!;
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller != null) {
      widget.controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contentStyle = ThemeText.getDefaultTextTheme().textMenu;
    final captionTextStyle = ThemeText.getDefaultTextTheme()
        .caption!
        .copyWith(fontSize: GoalPageConstants.fz_15sp);

    return CreateElementFormWidget(
      showLineBottom: widget.showLineBottom,
      showLineTop: widget.showLineTop,
      iconPath: widget.iconPath,
      child: Row(
        children: [
          Flexible(
            child: GestureDetector(
              onTap: widget.onSelectDate,
              child: TextFormField(
                controller: widget.controller,
                enabled: widget.enableField,
                inputFormatters: widget.inputFormatters,
                style: widget.enableField ? captionTextStyle : contentStyle,
                onChanged: widget.onChanged,
                keyboardType: widget.textInputType,
                decoration: InputDecoration.collapsed(
                    hintStyle: ThemeText.getDefaultTextTheme()
                        .textHint
                        .copyWith(fontSize: GoalPageConstants.fz_15sp),
                    hintText: widget.hintText),
              ),
            ),
          ),
          Visibility(
            visible: widget.trailingText != null,
            child: widget.trailingText != null
                ? GestureDetector(
                    onTap: widget.onSelectDuration,
                    child: Text(
                      widget.trailingText!,
                      style: captionTextStyle,
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
