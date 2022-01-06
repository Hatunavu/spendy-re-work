import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/widgets/transaction_detail_dialog/transaction_detail_dialog_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class ContentItemWidget extends StatelessWidget {
  final String? title;
  final String? value;
  final Color valueColor;
  final bool visible;

  const ContentItemWidget(
      {Key? key,
      this.title,
      this.value,
      this.valueColor = AppColor.textColor,
      this.visible = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: TransactionDetailDialogConstants.spaceBetweenContents,
            bottom: TransactionDetailDialogConstants.spaceBetweenContents,
            right: TransactionConstants.transactionDialogPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Text(title!,
                    style: ThemeText.getDefaultTextTheme().captionSemiBold),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  value!,
                  style: ThemeText.getDefaultTextTheme()
                      .caption
                      ?.copyWith(color: valueColor),
                  textAlign: TextAlign.right,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Visibility(
            visible: visible,
            child: const Divider(
                height: 0, color: AppColor.hindColor, thickness: 1))
      ],
    );
  }
}
