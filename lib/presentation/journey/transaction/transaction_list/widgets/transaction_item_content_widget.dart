import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class TransactionItemContentWidget extends StatelessWidget {
  final String? categoryName;
  final String? note;
  final String? strSpend;
  final int? payerNumbers;
  final int? spendTime;
  final bool? isPersonal;
  final String? strSpendTime;
  final bool? showTime;

  const TransactionItemContentWidget({
    Key? key,
    this.categoryName,
    this.payerNumbers,
    this.note,
    this.strSpend,
    this.spendTime,
    this.isPersonal = false,
    this.strSpendTime = '',
    this.showTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _transactionInfoWidget(),
    );
  }

  Widget _spendWidget() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.topRight,
      child: Text(
        '${strSpend.toString().formatStringToCurrency()}',
        style: ThemeText.getDefaultTextTheme()
            .textMoneyMenu
            .copyWith(color: AppColor.red),
      ),
    );
  }

  Widget _transactionInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                '$categoryName',
                style: ThemeText.getDefaultTextTheme().textMenu,
              ),
            ),
            Expanded(flex: 1, child: _spendWidget()),
          ],
        ),
        const SizedBox(
          height: 3,
        ),
        _contentWidget(),
      ],
    );
  }

  Widget _contentWidget() {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: !isPersonal!,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _groupIcon(),
                    Text(
                      ' | ',
                      style: ThemeText.getDefaultTextTheme().subTextMenu,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Visibility(
                  visible: true,
                  child: Text(
                    '$note',
                    style: ThemeText.getDefaultTextTheme().subTextMenu,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        strSpendTime != null && strSpendTime!.isNotEmpty && showTime!
            ? Text(
                '$strSpendTime',
                style: ThemeText.getDefaultTextTheme().subTextMenu,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              )
            : const Spacer(),
      ],
    );
  }

  Widget _groupIcon() {
    if (isPersonal!) {
      return Image.asset(IconConstants.personalIcon, height: 9);
    } else if (payerNumbers! >= 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(IconConstants.transactionGroupIcon, height: 9),
          const SizedBox(width: LayoutConstants.dimen_2),
          Text('$payerNumbers',
              style: ThemeText.getDefaultTextTheme().subTextMenu),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
