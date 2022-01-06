import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/create_form/create_element_form_constants.dart';
import 'package:spendy_re_work/presentation/widgets/autocomplete_textfield/autocomplete_textfield.dart';

class ParticipantNameFormWidget extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function(String)? onSaved;
  final List<String>? suggestionsList;

  const ParticipantNameFormWidget(
      {Key? key,
      this.controller,
      this.suggestionsList,
      this.focusNode,
      this.onSaved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: NewExpenseConstants.newExpensePaddingHorizontal),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const SizedBox(
                width: LayoutConstants.dimen_32,
                height: LayoutConstants.dimen_19,
              ),
              Expanded(
                child: SimpleAutoCompleteTextField(
                  controller: controller,
                  textAlign: TextAlign.left,
                  style: ThemeText.getDefaultTextTheme().captionSemiBold,
                  focusNode: focusNode,
                  autoFocus: true,
                  decoration: InputDecoration(
                      hintText: NewExpenseConstants.participantNameHint,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintStyle: ThemeText.getDefaultTextTheme()
                          .hint
                          .copyWith(fontWeight: FontWeight.normal),
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none),
                  cursorColor: AppColor.primaryColor,
                  textSubmitted: onSaved,
                  suggestions: suggestionsList!,
                  suggestionsAmount: suggestionsList!.length,
                ),
              ),
            ],
          ),
          Padding(
            padding: CreateElementFormConstants.dividerPadding,
            child: const Divider(
              color: AppColor.lineColor,
              thickness: 1,
              height: 0,
            ),
          )
        ],
      ),
    );
  }
}
