import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/image_data_state.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/widgets/transaction_detail_dialog/widgets/body_transaction_detail.dart';

class TransactionDetailDialogWidget extends StatelessWidget {
  final ExpenseEntity? expense;
  final Function()? onBack;
  final Function() editOnPressed;
  final Function() deleteOnPressed;
  final Function() onShowMorePicture;
  final ImageDataState? imageDataState;

  const TransactionDetailDialogWidget({
    Key? key,
    this.expense,
    this.onBack,
    this.imageDataState,
    required this.editOnPressed,
    required this.deleteOnPressed,
    required this.onShowMorePicture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
          horizontal: TransactionConstants.transactionDialogMarginHorizontal),
      child: BodyTransactionDetail(
        expense: expense,
        onBack: onBack,
        imageDataState: imageDataState,
        editOnPressed: editOnPressed,
        deleteOnPressed: deleteOnPressed,
        onShowMorePicture: onShowMorePicture,
      ),
    );
  }
}
