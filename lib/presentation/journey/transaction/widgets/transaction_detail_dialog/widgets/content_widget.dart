import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/category_name_map.dart';
import 'package:spendy_re_work/common/constants/image_data_state.dart';
import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/widgets/transaction_detail_dialog/transaction_detail_dialog_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/widgets/transaction_detail_dialog/widgets/content_item_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';

import 'image_list_widget.dart';

class ContentWidget extends StatelessWidget {
  final ExpenseEntity? expense;
  final Function()? onShowMorePicture;
  final ImageDataState? imageDataState;

  const ContentWidget({
    Key? key,
    this.expense,
    this.onShowMorePicture,
    this.imageDataState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContentItemWidget(
          title: TransactionDetailDialogConstants.categoryContentTitle,
          value: '${CategoryCommon.categoryNameMap[expense?.category] ?? ''}',
        ),
        ContentItemWidget(
          title: TransactionDetailDialogConstants.noteContentTitle,
          value: '${expense?.note}',
        ),
        // ContentItemWidget(
        //   title: TransactionDetailDialogConstants.groupContentTitle,
        //   value: expense?.group == 'PERSONAL'
        //       ? TransactionDetailDialogConstants.personalGroup
        //       : '${expense?.debts?.length}',
        // ),
        ContentItemWidget(
          title: TransactionDetailDialogConstants.dateContentTitle,
          value:
              '${DateTime.fromMillisecondsSinceEpoch(expense!.spendTime).formatDate}',
        ),
        ContentItemWidget(
          title: TransactionDetailDialogConstants.amountContentTitle,
          value: '${expense?.amount.toString().formatStringToCurrency()}',
          valueColor: AppColor.textError,
          visible: false,
        ),
        Visibility(
            visible: expense!.photos.isNotEmpty,
            child: ImageListWidget(
              imageList: expense?.photos,
              onShowMorePicture: onShowMorePicture,
              state: imageDataState,
            )),
      ],
    );
  }
}
