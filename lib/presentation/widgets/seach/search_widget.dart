import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_list/transaction_list_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/autocomplete_textfield/autocomplete_textfield.dart';
import 'package:spendy_re_work/presentation/widgets/seach/search_constants.dart';

// ignore: must_be_immutable
class SearchWidget extends StatelessWidget {
  final bool isTextForm;
  late bool showCleanButton;
  late bool autoFocus;
  late Function()? onPress;
  late TextEditingController searchController;
  late Function(String) onSubmitted;
  late Function(String) onSuggestionSelected;
  late Function(String) onChange;
  late Function() onCleanText;
  late List<String> categoryNameList;
  late FocusNode? nodeFocus;

  SearchWidget.text({Key? key, this.onPress})
      : isTextForm = false,
        super(key: key);

  SearchWidget.textForm({
    Key? key,
    this.nodeFocus,
    this.autoFocus = false,
    required this.searchController,
    required this.categoryNameList,
    required this.onSubmitted,
    required this.onSuggestionSelected,
    required this.onChange,
    required this.onCleanText,
    this.showCleanButton = false,
  })  : isTextForm = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColor.searchBackgroundColor,
          borderRadius: BorderRadius.circular(LayoutConstants.roundedRadius)),
      padding: const EdgeInsets.symmetric(
          vertical: SearchConstants.paddingVertical,
          horizontal: SearchConstants.paddingHorizontal),
      child: Row(
        children: [
          Image.asset(
            IconConstants.searchIcon,
            height: 18,
          ),
          const SizedBox(
            width: 9,
          ),
          Expanded(child: _contentWidget(context)),
        ],
      ),
    );
  }

  Widget _contentWidget(BuildContext context) {
    if (isTextForm) {
      return Row(
        children: [
          Expanded(
            child: SimpleAutoCompleteTextField(
              autoFocus: autoFocus,
              textAlign: TextAlign.start,
              controller: searchController,
              suggestions: categoryNameList,
              focusNode: nodeFocus!,
              style: ThemeText.getDefaultTextTheme().caption!.copyWith(
                  color: AppColor.primaryColor,
                  fontSize: TransactionListConstants.fzSearchText),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: SearchConstants.searchContent,
                hintStyle: ThemeText.getDefaultTextTheme().textHint.copyWith(
                    color: AppColor.searchHintTextColor,
                    fontSize: TransactionListConstants.fzSearchText,
                    fontWeight: FontWeight.normal),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              suggestionsAmount: categoryNameList.length,
              clearOnSubmit: false,
              textSubmitted: onSuggestionSelected,
              textChanged: onChange,
            ),
          ),
          const SizedBox(
            width: 9,
          ),
          Visibility(
            visible: showCleanButton,
            child: GestureDetector(
              onTap: onCleanText,
              child: Image.asset(
                IconConstants.cleanIcon,
                height: 18,
              ),
            ),
          ),
        ],
      );
    } else {
      return GestureDetector(
        onTap: onPress!,
        child: Text(SearchConstants.searchContent,
            style: ThemeText.getDefaultTextTheme().caption!.copyWith(
                color: AppColor.deepPurple,
                fontSize: TransactionListConstants.fzSearchText)),
      );
    }
  }
}
