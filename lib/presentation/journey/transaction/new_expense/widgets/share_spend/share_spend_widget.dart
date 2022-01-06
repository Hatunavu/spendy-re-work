// import 'package:flutter/material.dart';
// import 'package:spendy_re_work/common/constants/icon_constants.dart';
// import 'package:spendy_re_work/common/injector/injector.dart';
// import 'package:spendy_re_work/domain/entities/currency_entity.dart';
// import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
// import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
// import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';
// import 'package:spendy_re_work/presentation/journey/transaction/new_expense/widgets/expense_appbar_widget.dart';
// import 'package:spendy_re_work/presentation/journey/transaction/new_expense/widgets/new_expense_active_button_widget.dart';
// import 'package:spendy_re_work/presentation/theme/theme_color.dart';
// import 'package:spendy_re_work/presentation/theme/theme_text.dart';
// import 'package:spendy_re_work/presentation/widgets/create_form/create_element_form.dart';

// import 'money_form_widget.dart';
// import 'participant_name_form_widget.dart';

// class ShareSpendWidget extends StatefulWidget {
//   final String? title;
//   final String? actionButtonTitle;
//   final bool? isEdit;
//   final bool? isWhoPaidScreen;
//   final bool? isSelectAll;
//   final bool? isShowParticipantForm;
//   final bool? isActive;
//   final TextEditingController? participantNameController;
//   final FocusNode? participantNameFocusNode;

//   final List<ParticipantInTransactionEntity>? participants;
//   final Map<String, FocusNode>? focusNodesMap;

//   final Function()? addParticipantOnPress;
//   final Function(bool)? listenerAddParticipantFocusNode;
//   final Function(String)? onSavedParticipantName;
//   final Function(String, String)? onEditParticipantAmount;
//   final Function(String)? onCheckParticipant;
//   final Function()? onSelectAll;
//   final Function(bool, String, String)? listenerMoneyFocusNode;
//   final Function()? actionButtonOnTap;

//   final CurrencyEntity? currencyEntity;

//   final List<String>? suggestNameList;

//   ShareSpendWidget(
//       {Key? key,
//       this.currencyEntity,
//       this.actionButtonTitle,
//       this.title,
//       this.isWhoPaidScreen,
//       this.isEdit = false,
//       this.isSelectAll = false,
//       this.isShowParticipantForm,
//       this.isActive = false,
//       this.participantNameController,
//       this.participantNameFocusNode,
//       this.addParticipantOnPress,
//       this.listenerAddParticipantFocusNode,
//       this.onSavedParticipantName,
//       this.participants,
//       this.suggestNameList,
//       this.onEditParticipantAmount,
//       this.onCheckParticipant,
//       this.onSelectAll,
//       this.actionButtonOnTap,
//       this.listenerMoneyFocusNode,
//       this.focusNodesMap})
//       : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _ShareSpendWidgetState();
// }

// class _ShareSpendWidgetState extends State<ShareSpendWidget> {
//   final _userEntity = Injector.resolve<AuthenticationBloc>().userEntity;

//   @override
//   void initState() {
//     super.initState();
//     _listenerAddParticipantFocusNode();
//   }

//   void _listenerAddParticipantFocusNode() {
//     widget.participantNameFocusNode!.addListener(() {
//       if (mounted) {
//         widget.listenerAddParticipantFocusNode!(
//             widget.participantNameFocusNode!.hasFocus);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     // widget.participantNameController.dispose();
//     // widget.participantNameFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: ExpenseAppbarWidget(
//         appBarTitle: widget.isEdit!
//             ? NewExpenseConstants.editPersonalExpenseTitle
//             : NewExpenseConstants.personalExpenseTitle,
//         child: SizedBox(
//           width: MediaQuery.of(context).size.width,
//           child: FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Text(
//               widget.title!,
//               style: NewExpenseConstants.spentStyle,
//             ),
//           ),
//         ),
//       ),
//       body: _bodyWidget(context),
//       bottomNavigationBar: _nextButtonWidget(context),
//     );
//   }

//   Widget _bodyWidget(BuildContext context) {
//     return CustomScrollView(
//       slivers: <Widget>[
//         SliverToBoxAdapter(
//           child: _headerWidget(),
//         ),
//         SliverToBoxAdapter(
//           child: _shareSpendListWidget(),
//         ),
//         SliverToBoxAdapter(
//           child: _addParticipantGroupWidget(),
//         ),
//       ],
//     );
//   }

//   Widget _headerWidget() {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//           vertical: NewExpenseConstants.newExpensePaddingVertical,
//           horizontal: NewExpenseConstants.newExpensePaddingHorizontal),
//       child: SizedBox(
//         width: double.infinity,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Text(
//               widget.isWhoPaidScreen!
//                   ? NewExpenseConstants.whoPaidTitle
//                   : NewExpenseConstants.forWhoTitle,
//               style: NewExpenseConstants.shareSpendTitle,
//             ),
//             GestureDetector(
//               onTap: widget.onSelectAll,
//               child: Text(
//                 widget.isSelectAll!
//                     ? NewExpenseConstants.shareSpendDeselectAllTitle
//                     : NewExpenseConstants.shareSpendSelectAllTitle,
//                 style: ThemeText.getDefaultTextTheme()
//                     .caption
//                     ?.copyWith(color: AppColor.primaryColor),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _shareSpendListWidget() {
//     return Padding(
//       padding: EdgeInsets.only(
//           left: NewExpenseConstants.newExpensePaddingHorizontal),
//       child: ListView(
//         shrinkWrap: true,
//         primary: false,
//         children: widget.participants!.map((participant) {
//           final FocusNode moneyFocusNode =
//               widget.focusNodesMap![participant.name]!;
//           return GestureDetector(
//             behavior: HitTestBehavior.translucent,
//             onTap: () => widget.onCheckParticipant!(participant.name),
//             child: CreateElementFormWidget(
//               iconPath: participant.isPaid ?? false
//                   ? IconConstants.checkIcon
//                   : IconConstants.uncheckIcon,
//               showLineBottom: true,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Expanded(
//                       flex: 1,
//                       child: Text(
//                           "${participant.name}${participant.name == _userEntity.fullName ? ' (me)' : ''}",
//                           style:
//                               ThemeText.getDefaultTextTheme().captionSemiBold)),
//                   Expanded(
//                       flex: 1,
//                       child: MoneyFormWidget(
//                         currencyEntity: widget.currencyEntity!,
//                         participant: participant,
//                         maxLength: NewExpenseConstants.maxLengthMountField,
//                         onChange: (value) {
//                           if (value.length ==
//                               NewExpenseConstants.maxLengthMountField) {
//                             // unFocus when max length
//                             moneyFocusNode.unfocus();
//                             widget.listenerMoneyFocusNode!(
//                                 false, value, participant.name);
//                           }
//                         },
//                         onSubmitted: (value) => widget.onEditParticipantAmount!(
//                             participant.name, value),
//                         focusNode: moneyFocusNode,
//                         listenerFocusNode: (hasFocus, amount) =>
//                             widget.listenerMoneyFocusNode!(
//                                 hasFocus, amount, participant.name),
//                       ))
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _addParticipantGroupWidget() {
//     return Column(
//       children: <Widget>[
//         Visibility(
//           visible: widget.isShowParticipantForm!,
//           child: ParticipantNameFormWidget(
//               controller: widget.participantNameController!,
//               focusNode: widget.participantNameFocusNode!,
//               suggestionsList: widget.suggestNameList!,
//               onSaved: widget.onSavedParticipantName!),
//         ),
//         _addParticipantButton(),
//       ],
//     );
//   }

//   Widget _addParticipantButton() {
//     return GestureDetector(
//       onTap: widget.addParticipantOnPress,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Image.asset(
//             IconConstants.plusIcon,
//             height: 8,
//             width: 8,
//           ),
//           const SizedBox(width: 3),
//           Text(
//             NewExpenseConstants.addParticipantTitle,
//             style: ThemeText.getDefaultTextTheme().captionSemiBold,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _nextButtonWidget(context) => NewExpenseActiveButtonWidget(
//       title: widget.actionButtonTitle,
//       onPressed: widget.isActive! ? widget.actionButtonOnTap : null);
// }
