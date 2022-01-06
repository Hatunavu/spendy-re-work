// import 'package:flutter/material.dart';
// import 'package:spendy_re_work/common/configs/default_env.dart';
// import 'package:spendy_re_work/common/constants/layout_constants.dart';
// import 'package:spendy_re_work/common/enums/slide_state.dart';
// import 'package:spendy_re_work/common/utils/date_time_utils.dart';
// import 'package:spendy_re_work/domain/entities/expense/expense_data_entity.dart';
// import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
// import 'package:spendy_re_work/presentation/journey/transaction/transaction_list/transaction_list_constants.dart';
// import 'package:spendy_re_work/presentation/theme/theme_color.dart';
// import 'package:spendy_re_work/presentation/theme/theme_text.dart';
// import 'package:spendy_re_work/presentation/widgets/flare_widgets/alert_flare_widgets/error_flare_widget.dart';
// import 'package:spendy_re_work/presentation/widgets/skeleton_widget/expense_skeleton_widget.dart';
// import 'package:spendy_re_work/presentation/widgets/state_widget/empty_data_widget.dart';

// class RecentTransactionsWidget extends StatelessWidget {
//   final Function()? onViewAll;
//   final Widget? admobWidget;
//   final Map<int, List<ExpenseDataEntity>>? expenseOfDayMap;
//   late final int? widgetState;
//   final List<ExpenseEntity>? expenseList;
//   final ExpenseEntity? selectExpense;
//   final Function(ExpenseEntity, int)? onTapTransactionItem;
//   final Function(ExpenseEntity)? openSlideTransactionItem;
//   final Function()? closeSlide;
//   final Function()? deleteOnPressed;
//   final Function()? editOnPressed;
//   final Function()? onRefresh;
//   final SlideState? slideState;
//   final ScrollController? scrollController;

//   RecentTransactionsWidget.getData(
//       {Key? key,
//       required this.expenseList,
//       required this.selectExpense,
//       required this.onTapTransactionItem,
//       required this.openSlideTransactionItem,
//       required this.closeSlide,
//       required this.deleteOnPressed,
//       required this.editOnPressed,
//       required this.onViewAll,
//       required this.scrollController,
//       this.slideState = SlideState.none,
//       required this.expenseOfDayMap,
//       this.admobWidget,
//       this.widgetState = 2,
//       this.onRefresh})
//       : super(key: key);

//   RecentTransactionsWidget.loading({
//     Key? key,
//     required this.onViewAll,
//     this.admobWidget,
//     this.expenseOfDayMap,
//     this.widgetState = 1,
//     this.expenseList,
//     this.selectExpense,
//     this.onTapTransactionItem,
//     this.openSlideTransactionItem,
//     this.closeSlide,
//     this.deleteOnPressed,
//     this.editOnPressed,
//     this.onRefresh,
//     this.slideState,
//     this.scrollController,
//   }) : super(key: key);

//   RecentTransactionsWidget.error({
//     Key? key,
//     required this.onViewAll,
//     required this.onRefresh,
//     this.admobWidget,
//     this.expenseOfDayMap,
//     this.widgetState = 0,
//     this.expenseList,
//     this.selectExpense,
//     this.onTapTransactionItem,
//     this.openSlideTransactionItem,
//     this.closeSlide,
//     this.deleteOnPressed,
//     this.editOnPressed,
//     this.slideState,
//     this.scrollController,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Visibility(
//             visible: expenseList != null &&
//                 expenseOfDayMap != null &&
//                 expenseList!.isNotEmpty &&
//                 expenseOfDayMap!.isNotEmpty,
//             child: Padding(
//                 padding: const EdgeInsets.only(bottom: LayoutConstants.dimen_5),
//                 child: admobWidget),
//           ),
//           Expanded(child: _transactionsRecentWidget()),
//         ],
//       ),
//     );
//   }

//   Widget _transactionsRecentWidget() {
//     if (widgetState == 1) {
//       return ExpenseSkeletonWidget();
//     } else if (widgetState == 2) {
//       if (expenseList == null || expenseList!.isEmpty) {
//         return const EmptyDataWidget();
//       } else {
//         return CustomScrollView(
//           physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//           controller: scrollController,
//           slivers: [
//             SliverList(
//               delegate: SliverChildBuilderDelegate(
//                   (context, index) => _transactionWidget(context: context, index: index),
//                   childCount: expenseOfDayMap!.length <= DefaultConfig.limitRequest
//                       ? expenseOfDayMap!.length
//                       : DefaultConfig.limitRequest),
//             ),
//           ],
//         );
//       }
//     } else {
//       return FailedFlareWidget(
//         marginBottom: true,
//         callback: onRefresh!,
//       );
//     }
//   }

//   Widget _transactionWidget({BuildContext? context, int? index}) {
//     final int startDay = expenseOfDayMap!.keys.toList()[index!];
//     final String strDate = DateTimeUtils.formatDateTextMonth(
//         DateTime.fromMillisecondsSinceEpoch(startDay),
//         languageCode: Localizations.localeOf(context!).languageCode);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(
//             left: LayoutConstants.dimen_26,
//             // top: TransactionListConstants.spaceBetweenDateAndTransaction,
//             bottom: TransactionListConstants.spaceBetweenDateAndTransaction,
//           ),
//           child: Text(
//             '$strDate',
//             style: ThemeText.getDefaultTextTheme()
//                 .textHint
//                 .copyWith(color: AppColor.dateTimeTitleColor, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
// }
