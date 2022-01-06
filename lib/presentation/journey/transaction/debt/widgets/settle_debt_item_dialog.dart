import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/usecases/debt_usecase.dart';
import 'package:spendy_re_work/presentation/journey/transaction/debt/widgets/settle_debt_item_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';

class SettleDebtItemDialog extends StatelessWidget {
  final ShareSettleDebtEntity? shareSettleDebt;
  final CategoryEntity? debtCate;
  final Function()? onSelected;

  const SettleDebtItemDialog(
      {Key? key, this.shareSettleDebt, this.debtCate, this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                shareSettleDebt!.isShare
                    ? IconConstants.checkIcon
                    : IconConstants.uncheckIcon,
                color: AppColor.iconColor,
              ),
            ),
          ),
          Expanded(
              flex: 9,
              child: SettleDebtItemWidget(
                shareSettleDebt!.settleDebtModel,
                debtCate!,
                paddingRight: LayoutConstants.dimen_0,
              ))
        ],
      ),
    );
  }
}
