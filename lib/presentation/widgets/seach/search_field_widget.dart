import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/seach/search_constants.dart';

class SearchFieldWidget extends StatefulWidget {
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final Function()? onClearText;
  final TextEditingController controller;
  const SearchFieldWidget(
      {Key? key,
      this.onSubmitted,
      this.onChanged,
      this.onSaved,
      this.onClearText,
      required this.controller})
      : super(key: key);

  @override
  _SearchFieldWidget createState() => _SearchFieldWidget();
}

class _SearchFieldWidget extends State<SearchFieldWidget> {
  final FocusNode _focusNodeSearching = FocusNode();
  final GlobalKey<FormState> _groupNameKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isShowIcon = ValueNotifier(true);
  @override
  void initState() {
    _focusNodeSearching.addListener(_unFocusNodeCheckSubmitted);
    widget.controller.addListener(_checkFieldIsEmpty);
    super.initState();
  }

  @override
  void dispose() {
    _focusNodeSearching.removeListener(_unFocusNodeCheckSubmitted);
    widget.controller.removeListener(_checkFieldIsEmpty);
    super.dispose();
  }

  void _checkFieldIsEmpty() {
    _isShowIcon.value = widget.controller.text.trim().isEmpty;
  }

  void _unFocusNodeCheckSubmitted() {
    if (!_focusNodeSearching.hasFocus) {
      if (_groupNameKey.currentState?.validate() ?? false) {
        _groupNameKey.currentState?.save();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _groupNameKey,
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNodeSearching,
        textAlignVertical: TextAlignVertical.center,
        style: ThemeText.getDefaultTextTheme()
            .caption!
            .copyWith(color: const Color(0xff3C3C43), fontSize: 15.sp),
        onFieldSubmitted: widget.onSubmitted,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          isCollapsed: true,
          hintText: SearchConstants.searchContent,
          hintStyle: ThemeText.getDefaultTextTheme()
              .caption!
              .copyWith(color: const Color(0xff3C3C43), fontSize: 15.sp),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
          prefixIcon: IconButton(
            onPressed: null,
            icon: Image.asset(
              IconConstants.searchIcon,
              color: const Color(0xff3C3C43),
            ),
          ),
          prefixIconConstraints: BoxConstraints(maxHeight: 28.h, maxWidth: 40.w),
          suffixIcon: ValueListenableBuilder(
            valueListenable: _isShowIcon,
            builder: (context, bool value, child) => value
                ? const SizedBox()
                : IconButton(
                    onPressed: () {
                      widget.controller.clear();
                      _focusNodeSearching.requestFocus();
                      widget.onClearText!();
                    },
                    icon: Image.asset(
                      IconConstants.cleanIcon,
                      color: const Color(0xff3C3C43),
                    ),
                  ),
          ),
          enabledBorder: _outlineInputBorder(),
          focusedBorder: _outlineInputBorder(),
        ),
      ),
    );
  }

  OutlineInputBorder _outlineInputBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40.sp)),
        borderSide: const BorderSide(width: 1, color: Color(0xffD4D4D4)),
      );
}
