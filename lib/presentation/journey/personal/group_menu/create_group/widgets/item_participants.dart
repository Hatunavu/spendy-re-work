import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/domain/entities/participant_entity.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class ItemParticipantsWidget extends StatefulWidget {
  ItemParticipantsWidget({
    Key? key,
    required this.onChanged,
    required this.onRemove,
    required this.participantEntity,
    required this.focusListener,
  }) : super(key: key);

  final Function(String) onChanged;
  final Function() onRemove;
  final Function(bool) focusListener;
  final ParticipantEntity participantEntity;

  @override
  State<ItemParticipantsWidget> createState() => _ItemParticipantsWidgetState();
}

class _ItemParticipantsWidgetState extends State<ItemParticipantsWidget> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _participantNameKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _focusNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _focusNode.removeListener(_validate);
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _focusNode.addListener(_validate);
    if (widget.participantEntity.name.isEmpty) {
      _focusNode.requestFocus();
    }
    _controller = TextEditingController(
      text: widget.participantEntity.name,
    );
    _controller.selection = TextSelection.collapsed(offset: widget.participantEntity.name.length);
    super.initState();
  }

  void _validate() {
    widget.focusListener(_focusNode.hasFocus);
    _focusNotifier.value = _focusNode.hasFocus;
    if (!_focusNode.hasFocus) {
      if (_participantNameKey.currentState?.validate() ?? false) {
        _participantNameKey.currentState?.save();
      } else if (_controller.text.trim().isEmpty) {
        widget.onRemove();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _focusNotifier,
      builder: (context, bool isFocused, child) => Slidable(
        actionPane: const SlidableDrawerActionPane(),
        actionExtentRatio: 0.10,
        enabled: !isFocused,
        secondaryActions: [
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: IconSlideAction(
              color: AppColor.transparent,
              onTap: widget.onRemove,
              iconWidget: SvgPicture.asset(
                IconConstants.icRemove,
                width: 20.w,
              ),
            ),
          ),
        ],
        child: Form(
          key: _participantNameKey,
          child: TextFormField(
            controller: _controller,
            onTap: () {
              final slidable = Slidable.of(context);
              final closed = slidable?.renderingMode == SlidableRenderingMode.none;
              if (!closed) {
                slidable?.close();
              }
            },
            onChanged: widget.onChanged,
            validator: (value) {
              if (value == null) {
                return null;
              }
              if (value.length < 2) {
                return translate('error_message.error_length_text');
              }
              return null;
            },
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColor.darkBlue,
              fontWeight: FontWeight.w400,
            ),
            focusNode: _focusNode,
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: () {
                  if (isFocused) {
                    _controller
                      ..clear()
                      ..text = '';
                    widget.onChanged('');
                  }
                },
                child: SizedBox(
                  width: 20.w,
                  height: 25.w,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: isFocused
                        ? SvgPicture.asset(
                            IconConstants.icClear,
                            width: 15.w,
                            height: 15.w,
                          )
                        : _controller.text.isNotEmpty
                            ? SvgPicture.asset(
                                IconConstants.icEditParticipants,
                                width: 20.w,
                                height: 20.w,
                              )
                            : const SizedBox(),
                  ),
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: AppColor.lightGrey,
                ),
              ),
              focusedErrorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: AppColor.red,
                ),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: AppColor.lightGrey,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              isCollapsed: true,
              errorStyle: ThemeText.getDefaultTextTheme()
                  .hint
                  .copyWith(fontSize: 12.sp, color: AppColor.red, height: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}
