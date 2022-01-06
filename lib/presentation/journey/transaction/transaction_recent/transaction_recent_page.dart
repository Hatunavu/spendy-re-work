import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/common/navigation/lifecycle_event_handler.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/presentation/bloc/unread_notification_bloc/unread_notification_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/unread_notification_bloc/unread_notification_event.dart';
import 'package:spendy_re_work/presentation/journey/home/home_screen_constants.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_state.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_blocs/transaction_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_recent/widgets/group_home_item.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_recent/pages/group_transactions_page.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_recent/transaction_recent_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/until/scroll_transaction_until.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/appbar_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'widgets/loading_group_widget.dart';

class TransactionRecentPage extends StatefulWidget {
  final Function(List<String>)? notiPushToScreen;

  const TransactionRecentPage({Key? key, this.notiPushToScreen}) : super(key: key);

  @override
  _TransactionRecentPageState createState() => _TransactionRecentPageState();
}

class _TransactionRecentPageState extends State<TransactionRecentPage>
    with TickerProviderStateMixin {
  final _groupItemHeight = TransactionRecentConstants.groupItemHeight;
  final ValueNotifier<double> _scrollValueNotifier = ValueNotifier(0);
  TabController? _tabController;
  final Map<String, TransactionBloc> _transactionBlocs = {};

  @override
  void initState() {
    _tabController = TabController(length: 0, vsync: this);
    _scrollValueNotifier.value = _groupItemHeight;
    super.initState();
    WidgetsBinding.instance!.addObserver(LifecycleEventHandler(onResume: _onResume));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: HomeScreenConstants.textTitle,
        actions: const [
          // GestureDetector(
          //   onTap: () => _pushToDebt(context),
          //   child: Image.asset(IconConstants.debtHomeIcon),
          // ),
          //_notificationIcon()
        ],
      ),
      body: BlocConsumer<GroupBloc, GroupState>(
        listener: (_, state) {
          if (state is GroupUpdateState) {
            _tabController = TabController(length: state.groups.length, vsync: this);
          }
        },
        listenWhen: (_, state) => !(state is GroupDeleteErroredState),
        buildWhen: (_, state) => !(state is GroupDeleteErroredState),
        builder: (_, state) {
          List<GroupEntity> _groups = [];
          if (state is GroupUpdateState) {
            _groups = state.groups;
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20.h),
              ValueListenableBuilder<double>(
                valueListenable: _scrollValueNotifier,
                builder: (context, _height, _) {
                  Widget _child = const SizedBox();
                  if (state is GroupLoadingState) {
                    _child = LoadingGroupWidget();
                  }
                  if (state is GroupUpdateState) {
                    _child = CarouselSlider(
                      items: _groups.map((e) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 9.w),
                          child: GroupHomeItem(
                            nameGroup: e.name,
                            height: _height,
                            totalAmount: e.totalAmount ?? 0,
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: _groupItemHeight,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          _tabController?.animateTo(index);
                        },
                      ),
                    );
                  }
                  return AnimatedContainer(
                    height: _height,
                    duration: const Duration(milliseconds: 200),
                    child: _child,
                  );
                },
              ),
              SizedBox(height: 10.h),
              Expanded(child: _renderTransactionPage(state)),
            ],
          );
        },
      ),
    );
  }

  Widget _renderTransactionPage(GroupState state) {
    if (state is GroupLoadingState) {
      return GroupTransactionPage.loading();
    }
    if (state is GroupErroredState) {
      return GroupTransactionPage.error();
    }
    if (state is GroupUpdateState) {
      if (_tabController?.length != state.groups.length) {
        return const SizedBox();
      }
      return TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: state.groups.map(
          (group) {
            final _transactionBloc =
                _transactionBlocs[group.id!] ?? Injector.resolve<TransactionBloc>();
            _transactionBlocs.putIfAbsent(group.id!, () => _transactionBloc);
            return BlocProvider<TransactionBloc>.value(
              value: _transactionBloc,
              child: GroupTransactionPage(
                group: group,
                onScrolled: (controller) {
                  _scrollValueNotifier.value = getItemHeight(scrollController: controller);
                },
              ),
            );
          },
        ).toList(),
      );
    }
    return const SizedBox();
  }

  // void _onTapTransactionItem(
  //     BuildContext context, ExpenseEntity value, int index, TransactionInitialState state) {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (dialogContext) => BlocProvider(
  //       create: (_) =>
  //           Injector.resolve<TransactionDetailBloc>()..add(TransactionDetailInitialEvent(value)),
  //       child: BlocBuilder<TransactionDetailBloc, TransactionDetailState>(
  //         builder: (detailContext, state) {
  //           if (state is TransactionDetailInitialState) {
  //             return TransactionDetailDialogWidget(
  //               expense: state.expense,
  //               onShowMorePicture: () => _onShowMorePicture(dialogContext, value),
  //               deleteOnPressed: () {
  //                 Navigator.of(dialogContext).pop();
  //                 _deleteOnPressed(context, value);
  //               },
  //               imageDataState: state.imageDataState,
  //               onBack: () {},
  //               editOnPressed: () {
  //                 Navigator.of(dialogContext).pop();
  //                 _editOnPressed(context, value);
  //               },
  //             );
  //           }
  //           return EmptyDataWidget();
  //         },
  //       ),
  //     ),
  //   );
  // }

  // void _openSlideTransactionItem(BuildContext context, ExpenseEntity value) {
  //   BlocProvider.of<TransactionBloc>(context).add(OpenSlideEvent(selectExpense: value));
  // }

  // void _closeSlideTransactionItem(BuildContext context) {
  //   BlocProvider.of<TransactionBloc>(context).add(CloseSlideEvent());
  // }

  // void _editOnPressed(BuildContext context, ExpenseEntity selectExpense) {
  //   _closeSlideTransactionItem(context);
  //   Navigator.pushNamed(context, RouteList.personalExpense, arguments: {
  //     KeyConstants.routeKey: RouteList.home,
  //     KeyConstants.editExpenseKey: true,
  //     KeyConstants.expenseDetailKey: selectExpense,
  //   });
  // }

  // void _deleteOnPressed(BuildContext context, ExpenseEntity selectExpense) {
  //   _closeSlideTransactionItem(context);
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (dialogContext) => DeleteDialogWidget(
  //           typeNameItem: TransactionRecentConstants.transaction,
  //           onPressedYes: () => _onDelete(context, selectExpense),
  //           onPressedNo: () {
  //             Navigator.of(dialogContext).pop();
  //           }));
  // }

  // void _onDelete(BuildContext context, ExpenseEntity selectExpense) {
  //   BlocProvider.of<TransactionBloc>(context).add(DeleteExpenseEvent(expense: selectExpense));
  //   Navigator.of(context).pop();
  // }

  // void _onShowMorePicture(BuildContext dialogContext, ExpenseEntity expense) {
  //   Navigator.of(dialogContext).pop();
  //   Navigator.pushNamed(dialogContext, RouteList.showImage,
  //       arguments: {KeyConstants.expenseKey: expense});
  // }

  // void _pushToTransactionList(context) {
  //   Navigator.pushNamed(context, RouteList.transactionList);
  // }

  // void _onRefresh(BuildContext context) {
  //   BlocProvider.of<TransactionBloc>(context).add(TransactionInitialEvent());
  // }

  Future _onResume() async {
    Injector.resolve<UnreadNotificationBloc>().add(UnreadNotificationInitEvent());
  }
}
