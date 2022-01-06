import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/usecases/debt_usecase.dart';
import 'package:spendy_re_work/presentation/journey/transaction/debt/debt_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/debt/widgets/settle_debt_item_dialog.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class ShareSettleDebtDialog extends StatefulWidget {
  final Function()? onCancel;
  final Function(List<ShareSettleDebtEntity>)? onApply;
  final List<ShareSettleDebtEntity>? shareSettleDebtList;
  final CategoryEntity? categoryEntity;

  const ShareSettleDebtDialog({
    Key? key,
    this.onCancel,
    this.onApply,
    this.shareSettleDebtList,
    this.categoryEntity,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ShareSettleDebtDialogState();
}

class ShareSettleDebtDialogState extends State<ShareSettleDebtDialog> {
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    isActive = _checkActive();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      padding: const EdgeInsets.symmetric(
          horizontal: LayoutConstants.paddingHorizontal),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _headerBottomSheet(context),
          Expanded(child: _content()),
        ],
      ),
    );
  }

  Widget _headerBottomSheet(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding:
              const EdgeInsets.symmetric(vertical: LayoutConstants.dimen_16),
          child: Text(
            DebtConstants.shareSettleDebtTitle,
            style: ThemeText.getDefaultTextTheme().captionSemiBold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.only(top: LayoutConstants.dimen_16),
                child: Text(
                  DebtConstants.cancelTitle,
                  style: ThemeText.getDefaultTextTheme()
                      .captionSemiBold
                      .copyWith(color: AppColor.primaryColor),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (isActive) {
                  Navigator.pop(context);
                  widget.onApply!(widget.shareSettleDebtList!);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: LayoutConstants.dimen_16),
                child: Text(
                  DebtConstants.applyTitle,
                  style: ThemeText.getDefaultTextTheme()
                      .captionSemiBold
                      .copyWith(
                          color: isActive
                              ? AppColor.primaryColor
                              : AppColor.hindColor),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _content() {
    return ListView.builder(
        itemCount: widget.shareSettleDebtList!.length,
        itemBuilder: (context, index) => SettleDebtItemDialog(
            onSelected: () => _onSelected(index),
            shareSettleDebt: widget.shareSettleDebtList![index],
            debtCate: widget.categoryEntity!));
  }

  void _onSelected(int index) {
    setState(() {
      widget.shareSettleDebtList![index].share();
      isActive = _checkActive();
    });
    // widget.onSelected(index);
  }

  bool _checkActive() {
    for (final ShareSettleDebtEntity shareSettleDebtEntity
        in widget.shareSettleDebtList!) {
      if (shareSettleDebtEntity.isShare) {
        return true;
      }
    }
    return false;
  }
}
