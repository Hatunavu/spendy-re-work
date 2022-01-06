import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/domain/entities/notifications/notification_entity.dart';
import 'package:spendy_re_work/presentation/journey/home/notification/noti_bloc.dart';
import 'package:spendy_re_work/presentation/journey/home/notification/noti_event.dart';
import 'package:spendy_re_work/presentation/journey/home/notification/noti_state.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/loader_dialog/loader_wallet_dialog.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/alert_flare_widgets/empty_data_widget.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/alert_flare_widgets/error_flare_widget.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/loader/load_more/load_more_widget.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/loader/loading_flare_widget.dart';
import 'package:spendy_re_work/presentation/widgets/no_internet_widget/no_internet_widget.dart';

import 'notification_item_widget.dart';

class BodyNotification extends StatefulWidget {
  const BodyNotification({Key? key}) : super(key: key);

  @override
  State<BodyNotification> createState() => _BodyNotificationState();
}

class _BodyNotificationState extends State<BodyNotification> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _scrollEndList(context);
      }
    });
  }

  void _scrollEndList(BuildContext context) {
    BlocProvider.of<NotificationBloc>(context)
        .add(NotiInitialEvent(isMore: true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotiState>(
        listener: (context, state) async {
      if (state is NotiInitialState) {
        LoaderWalletDialog.getInstance().hide(context);
      } else if (state is NotificationPushToEditGoalState) {
        final result = await Navigator.pushNamed(context, RouteList.addGoal,
            arguments: {
              KeyConstants.editAGoalKey: state.goalEntity,
              KeyConstants.isEditAGoalKey: true
            });
        if (result != null) {
          BlocProvider.of<NotificationBloc>(context)
              .add(NotiInitialEvent(isMore: false));
        }
      }
    }, builder: (context, state) {
      if (state is NotiLoadingState) {
        return Center(
          child: FlareLoadingWidget(
            marginBottom: true,
          ),
        );
      } else if (state is NotiInitialState ||
          state is LoadMoreNotificationState) {
        if (state.notificationList == null || state.notificationList!.isEmpty) {
          return Center(child: EmptyDataWidget());
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: LayoutConstants.paddingHorizontal),
          child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              controller: _scrollController,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => NotiItemWidget(
                      notificationEntity: state.notificationList![index],
                      onPressed: () => _itemOnPressed(
                          context, state.notificationList![index]),
                    ),
                    childCount: state.notificationList!.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: state is LoadMoreNotificationState
                      ? FlareLoadMoreWidget()
                      : const SizedBox(height: 20),
                ),
              ]),
        );
      } else if (state is NotificationNoInternetState) {
        return NoInternetWidget();
      } else {
        return FailedFlareWidget(
          marginBottom: true,
          callback: () => _onRefresh(context),
        );
      }
    });
  }

  void _itemOnPressed(BuildContext context, NotificationEntity notification) {
    BlocProvider.of<NotificationBloc>(context).add(ReadNotiEvent(notification));
  }

  void _onRefresh(BuildContext context) {}
}
