import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/extensions/num_extensions.dart';
import 'package:spendy_re_work/common/extensions/double_extensions.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/tag_list/tag_list_constants.dart';
import 'package:spendy_re_work/presentation/widgets/range_slide/range_slide.dart'
    as frs;

class ExpenseRangeOptionWidget extends StatelessWidget {
  final bool useActionButton;
  final bool spendRangeInfinity;
  final Function() onTapActionButton;
  final double? lowerRange;
  final double? upperRange;
  final Function(double lower, double upper) onChangeRange;
  final Function(double lower, double upper) onChangeEnd;

  const ExpenseRangeOptionWidget({
    Key? key,
    this.useActionButton = false,
    this.spendRangeInfinity = false,
    required this.onTapActionButton,
    this.lowerRange,
    this.upperRange,
    required this.onChangeRange,
    required this.onChangeEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _headerOptionSquadWidget(),
            const SizedBox(
              height: LayoutConstants.dimen_17,
            ),
            _expenseRangeWidget(context),
          ],
        ),
      ],
    );
  }

  Widget _headerOptionSquadWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                IconConstants.expenseIcon,
                height: LayoutConstants.iconSize20,
              ),
              TagListConstants.spacingBetweenIconAndTitle,
              Text(
                FilterConstants.expenseRangeOptionName,
                style: ThemeText.getDefaultTextTheme().captionSemiBold,
              )
            ],
          ),
        ),
        Visibility(
          visible: useActionButton,
          child: GestureDetector(
            onTap: onTapActionButton,
            child: Text(
              FilterConstants.deselectExpenseRange,
              style: ThemeText.getDefaultTextTheme()
                  .caption
                  ?.copyWith(color: AppColor.primaryColor),
            ),
          ),
        )
      ],
    );
  }

  Widget _expenseRangeWidget(context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              overlayColor: AppColor.primaryColor,
              activeTickMarkColor: AppColor.primaryColor,
              activeTrackColor: AppColor.primaryColor,
              inactiveTrackColor: AppColor.deepPurpleCFD1F8,
              thumbColor: AppColor.white,
              valueIndicatorColor: AppColor.primaryColor,
              showValueIndicator: ShowValueIndicator.never,
            ),
            child: frs.RangeSlider(
              min: FilterConstants.minExpenseRange,
              max: FilterConstants.maxExpenseRange,
              lowerValue:
                  lowerRange ?? FilterConstants.minExpenseRange.compactDouble,
              upperValue:
                  upperRange ?? FilterConstants.maxExpenseRange.compactDouble,
              showValueIndicator: true,
              valueIndicatorMaxDecimals: 1,
              onChanged: (lower, upper) =>
                  onChangeRange(lower.compactDouble, upper.compactDouble),
              onChangeEnd: onChangeEnd,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                constraints: const BoxConstraints(
                  minWidth: 40.0,
                  maxWidth: 100.0,
                ),
                child: Text(
                  '${lowerRange?.toInt().formatMoneyWithChar()}',
                  style: ThemeText.getDefaultTextTheme()
                      .textDateRange
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                constraints: const BoxConstraints(
                  minWidth: 40.0,
                  maxWidth: 150.0,
                ),
                child: spendRangeInfinity &&
                        upperRange == FilterConstants.maxExpenseRange
                    ? Image.asset(
                        IconConstants.infinityIcon,
                        height: 15,
                      )
                    : Text(
                        '${upperRange?.toInt().formatMoneyWithChar()}',
                        style: ThemeText.getDefaultTextTheme()
                            .textDateRange
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
