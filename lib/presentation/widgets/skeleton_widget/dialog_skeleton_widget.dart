// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
// import 'package:spendy_re_work/presentation/journey/transaction/transaction_constants.dart';
// import 'package:spendy_re_work/presentation/journey/transaction/widgets/transaction_detail_dialog/transaction_detail_dialog_constants.dart';
// import 'package:spendy_re_work/presentation/theme/theme_color.dart';
//
// class DialogSkeletonWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         if (index == 0) {
//           return _headerWidget();
//         }
//       },
//       separatorBuilder: (context, index) {
//         return Padding(
//           padding: EdgeInsets.only(
//             top: TransactionConstants.transactionDialogPaddingVertical,
//             bottom: TransactionConstants.transactionDialogPaddingVertical,
//             left: TransactionConstants.transactionDialogPadding,
//           ),
//           child: Container(
//             height: 1,
//             color: AppColor.shimmerLine,
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(LayoutConstants.roundedRadius),
//             color: AppColor.white),
//         padding: EdgeInsets.only(
//           top: TransactionConstants.transactionDialogPaddingVertical,
//           bottom: TransactionConstants.transactionDialogPaddingVertical,
//           left: TransactionConstants.transactionDialogPadding,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _headerWidget(context),
//             ContentWidget(
//               expense: expense,
//               onShowMorePicture: onShowMorePicture,
//               imageDataState: imageDataState,
//             ),
//             TransactionButton(
//               onPressed: () {
//                 onBack();
//                 Navigator.of(context).pop();
//               },
//               title: TransactionDetailDialogConstants.backButtonTitle,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _headerWidget() {
//     return Padding(
//       padding: EdgeInsets.only(
//         right: TransactionConstants.transactionDialogPadding,
//         bottom: TransactionDetailDialogConstants.spaceBetweenHeaderAndContent,
//       ),
//       child: Shimmer.fromColors(
//         baseColor: AppColor.shimmerBase,
//         highlightColor: AppColor.shimmerHighlight,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               TransactionDetailDialogConstants.transactionDetailTitle,
//               style: ThemeText.getDefaultTextTheme().display1.copyWith(
//                   fontSize: TransactionDetailDialogConstants.fzTitle,
//                   fontWeight: FontWeight.bold),
//             ),
//             Row(
//               children: [
//                 GestureDetector(
//                   onTap: editOnPressed,
//                   child: Image.asset(
//                     IconConstants.editIcon,
//                     height: TransactionDetailDialogConstants.iconSize,
//                     width: TransactionDetailDialogConstants.iconSize,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//                 SizedBox(
//                   width: TransactionDetailDialogConstants.spaceBetweenIcons,
//                 ),
//                 GestureDetector(
//                   onTap: deleteOnPressed,
//                   child: Image.asset(
//                     IconConstants.deleteIcon,
//                     height: TransactionDetailDialogConstants.iconSize,
//                     width: TransactionDetailDialogConstants.iconSize,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
