import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spendy_re_work/common/constants/category_icon_map.dart';
import 'package:spendy_re_work/common/constants/category_name_map.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_detail_bloc/transaction_detail_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_detail_bloc/transaction_detail_event.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_detail_bloc/transaction_detail_state.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_recent/transaction_recent_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/widgets/transaction_detail_dialog/transaction_detail_dialog_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';
import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/delete_dialog/delete_dialog_widget.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/alert_flare_widgets/empty_data_widget.dart';

class TransactionItemWidget extends StatefulWidget {
  final ExpenseEntity transaction;
  final GroupEntity? group;
  final TransactionTimeFormat timeFormat;
  final Function() editTransaction;
  final Function() deleteTransaction;
  TransactionItemWidget(
      {Key? key,
      required this.transaction,
      this.timeFormat = TransactionTimeFormat.date,
      this.group,
      required this.editTransaction,
      required this.deleteTransaction})
      : super(key: key);

  @override
  _TransactionItemWidgetState createState() => _TransactionItemWidgetState();
}

class _TransactionItemWidgetState extends State<TransactionItemWidget> {
  late final SlidableController _slidableController;
  final ValueNotifier<double> _categoryIconNotifier =
      ValueNotifier(LayoutConstants.dimen_48);
  final _extentRatio = 0.1;

  @override
  void initState() {
    _slidableController = SlidableController(onSlideAnimationChanged: (offset) {
      offset?.addListener(
        () {
          _categoryIconNotifier.value = (LayoutConstants.dimen_48 *
                  (1 - (offset.value / (_extentRatio * 2))))
              .clamp(0, LayoutConstants.dimen_48);
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _transaction = widget.transaction;
    return GestureDetector(
      onTap: () => _openTransaction(widget.transaction),
      child: Padding(
        padding: EdgeInsets.only(
          left: LayoutConstants.paddingHorizontal.w,
          right: 15.w,
        ),
        child: Slidable(
          controller: _slidableController,
          actionPane: const SlidableDrawerActionPane(),
          actionExtentRatio: _extentRatio,
          secondaryActions: [
            GestureDetector(
              onTap: () {
                _slidableController.activeState?.close();
                widget.editTransaction();
              },
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Image.asset(
                  IconConstants.editIcon,
                  width: 45.h,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _slidableController.activeState?.close();
                _deleteTransaction(widget.transaction);
              },
              child: Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: SvgPicture.asset(
                  IconConstants.icRemoveWithBackground,
                  width: 24.w,
                  height: 24.w,
                ),
              ),
            )
          ],
          child: Row(
            children: [
              SizedBox(
                width: LayoutConstants.dimen_48.w,
                child: ValueListenableBuilder<double>(
                  valueListenable: _categoryIconNotifier,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: LayoutConstants.dimen_3),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                        categoryIconMap[_transaction.category]!,
                      ),
                    ),
                  ),
                  builder: (_, size, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: size.w,
                      height: size.w,
                      child: child!,
                    );
                  },
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              CategoryCommon
                                      .categoryNameMap[_transaction.category] ??
                                  '',
                              style: ThemeText.getDefaultTextTheme()
                                  .textMenu
                                  .copyWith(fontSize: 16.sp),
                            ),
                          ),
                          Text(
                            '- ${_transaction.amount.toString().formatStringToCurrency()}',
                            style: ThemeText.getDefaultTextTheme()
                                .textMoneyMenu
                                .copyWith(
                                    color: AppColor.red,
                                    fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Visibility(
                            visible: _transaction.forWho.isNotEmpty,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  IconConstants.forWho,
                                  height: 11.25.h,
                                  width: 12.5.w,
                                  color: AppColor.grey,
                                ),
                                Text(_transaction.forWho.length.toString(),
                                    style: ThemeText.getDefaultTextTheme()
                                        .transactionSubTextStyle),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _transaction.forWho.isNotEmpty &&
                                _transaction.note != null &&
                                _transaction.note!.isNotEmpty,
                            child: Text(
                              ' | ',
                              style: ThemeText.getDefaultTextTheme()
                                  .transactionSubTextStyle,
                            ),
                          ),
                          Text(_transaction.note ?? '',
                              style: ThemeText.getDefaultTextTheme()
                                  .transactionSubTextStyle),
                          Expanded(
                            child: Text(
                              DateTime.fromMillisecondsSinceEpoch(
                                      _transaction.spendTime)
                                  .formatTransactionTime(widget.timeFormat),
                              textAlign: TextAlign.right,
                              style: ThemeText.getDefaultTextTheme()
                                  .transactionSubTextStyle,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _openTransaction(ExpenseEntity expenseEntity) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) => BlocProvider(
        create: (_) => Injector.resolve<TransactionDetailBloc>()
          ..add(TransactionDetailInitialEvent(
              expenseEntity, widget.group?.id ?? '')),
        child: BlocBuilder<TransactionDetailBloc, TransactionDetailState>(
          builder: (detailContext, state) {
            if (state is TransactionDetailInitialState) {
              return TransactionDetailDialogWidget(
                expense: state.expense,
                onShowMorePicture: () =>
                    _onShowMorePicture(dialogContext, expenseEntity),
                deleteOnPressed: () {
                  Navigator.of(dialogContext).pop();
                  widget.deleteTransaction();
                },
                imageDataState: state.imageDataState,
                onBack: () {},
                editOnPressed: () {
                  Navigator.of(dialogContext).pop();
                  widget.editTransaction();
                },
              );
            }
            return EmptyDataWidget();
          },
        ),
      ),
    );
  }

  void _onShowMorePicture(BuildContext dialogContext, ExpenseEntity expense) {
    Navigator.of(dialogContext).pop();
    Navigator.pushNamed(dialogContext, RouteList.showImage,
        arguments: {KeyConstants.expenseKey: expense});
  }

  void _deleteTransaction(ExpenseEntity expenseEntity) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) => DeleteDialogWidget(
            typeNameItem: TransactionRecentConstants.transaction,
            onPressedYes: () {
              widget.deleteTransaction();
              Navigator.of(dialogContext).pop();
            },
            onPressedNo: () {
              Navigator.of(dialogContext).pop();
            }));
  }
}
