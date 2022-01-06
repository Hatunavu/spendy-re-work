import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/image_data_state.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/widgets/transaction_button.dart';
import 'package:spendy_re_work/presentation/journey/transaction/widgets/transaction_detail_dialog/transaction_detail_dialog_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

import 'content_widget.dart';

class BodyTransactionDetail extends StatelessWidget {
  final ExpenseEntity? expense;
  final Function()? onShowMorePicture;
  final ImageDataState? imageDataState;
  final Function()? onBack;
  final Function()? editOnPressed;
  final Function()? deleteOnPressed;

  const BodyTransactionDetail(
      {Key? key,
      this.expense,
      this.onShowMorePicture,
      this.imageDataState,
      this.onBack,
      this.editOnPressed,
      this.deleteOnPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(LayoutConstants.roundedRadius),
          color: AppColor.white),
      padding: const EdgeInsets.only(
        top: TransactionConstants.transactionDialogPaddingVertical,
        bottom: TransactionConstants.transactionDialogPaddingVertical,
        left: TransactionConstants.transactionDialogPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeaderTransactionDetail(
            editOnPressed: editOnPressed,
            deleteOnPressed: deleteOnPressed,
          ),
          ContentWidget(
            expense: expense!,
            onShowMorePicture: onShowMorePicture,
            imageDataState: imageDataState!,
          ),
          TransactionButton(
            onPressed: () {
              onBack!();
              Navigator.of(context).pop();
            },
            title: TransactionDetailDialogConstants.backButtonTitle,
          ),
        ],
      ),
    );
  }
}

///HEADER TRANSACTION DETAIL
class HeaderTransactionDetail extends StatelessWidget {
  const HeaderTransactionDetail(
      {Key? key, this.editOnPressed, this.deleteOnPressed})
      : super(key: key);
  final Function()? editOnPressed;
  final Function()? deleteOnPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: TransactionConstants.transactionDialogPadding,
        bottom: TransactionDetailDialogConstants.spaceBetweenHeaderAndContent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            TransactionDetailDialogConstants.transactionDetailTitle,
            style: ThemeText.getDefaultTextTheme().headline4!.copyWith(
                fontSize: TransactionDetailDialogConstants.fzTitle,
                fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: editOnPressed,
                child: Image.asset(
                  IconConstants.editIcon,
                  height: TransactionDetailDialogConstants.iconSize,
                  width: TransactionDetailDialogConstants.iconSize,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                width: TransactionDetailDialogConstants.spaceBetweenIcons,
              ),
              GestureDetector(
                onTap: deleteOnPressed,
                child: Image.asset(
                  IconConstants.deleteIcon,
                  height: TransactionDetailDialogConstants.iconSize,
                  width: TransactionDetailDialogConstants.iconSize,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
