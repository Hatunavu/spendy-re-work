import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_constants.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_option/widgets/reset_button.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget.dart';

class GroupButtonWidget extends StatelessWidget {
  final bool? isActiveButton;
  final int? selectOptionTypeNumbers;
  final Function() onPressedApplyButton;
  final Function() onPressedResetButton;

  const GroupButtonWidget(
      {Key? key,
      this.isActiveButton,
      this.selectOptionTypeNumbers,
      required this.onPressedApplyButton,
      required this.onPressedResetButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: LayoutConstants.dimen_26,
          horizontal: LayoutConstants.dimen_26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: ResetButton(
              onPress: isActiveButton! ? onPressedResetButton : null,
              title: _getResetButtonTitle(),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 5,
            child: ButtonWidget.primary(
              title: translate('label.apply'),
              onPress: isActiveButton! ? onPressedApplyButton : null,
            ),
          ),
        ],
      ),
    );
  }

  String _getResetButtonTitle() {
    if (selectOptionTypeNumbers == 0) {
      return FilterConstants.resetButton;
    } else {
      return '${FilterConstants.resetButton} ($selectOptionTypeNumbers)';
    }
  }
}
