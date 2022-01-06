import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/utils/internet_util.dart';
import 'package:spendy_re_work/domain/entities/goal_entity.dart';
import 'package:spendy_re_work/domain/entities/notifications/notification_entity.dart';
import 'package:spendy_re_work/domain/usecases/goal_usecase.dart';
import 'package:spendy_re_work/domain/usecases/noti_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/unread_notification_bloc/unread_notification_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/unread_notification_bloc/unread_notification_event.dart';
import 'package:spendy_re_work/presentation/journey/home/blocs/bottom_tab_bloc/bottom_tab_bloc.dart';
import 'package:spendy_re_work/presentation/journey/home/notification/noti_event.dart';
import 'package:spendy_re_work/presentation/journey/home/notification/noti_state.dart';
import 'package:spendy_re_work/common/enums/notification_enum/notification_type.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_blocs/transaction_bloc.dart';

class NotificationBloc extends Bloc<NotiEvent, NotiState> {
  final NotificationUseCase notificationUseCase;
  final AuthenticationBloc authenticationBloc;
  final GoalUseCase goalUseCase;
  final TransactionBloc transactionBloc;
  final BottomTabBloc bottomTabBloc;
  final UnreadNotificationBloc unreadNotificationBloc;

  final List<NotificationEntity> _notificationList = [];
  final DateTime _now = DateTime.now();

  NotificationBloc(
      {required this.notificationUseCase,
      required this.goalUseCase,
      required this.authenticationBloc,
      required this.bottomTabBloc,
      required this.transactionBloc,
      required this.unreadNotificationBloc})
      : super(NotiLoadingState());

  @override
  Stream<NotiState> mapEventToState(NotiEvent event) async* {
    switch (event.runtimeType) {
      case NotiInitialEvent:
        yield* _mapNotiInitialEventToState(event as NotiInitialEvent);
        break;
      case ReadNotiEvent:
        yield* _mapReadNotiEventToState(event as ReadNotiEvent);
        break;
      case CreateNotificationEvent:
        yield* _mapCreateNotificationEvent(event as CreateNotificationEvent);
        break;
      case DeleteGoalNotiEvent:
        yield* _mapDeleteNotiEvent(event as DeleteGoalNotiEvent);
        break;
      case UpdateGoalNotificationEvent:
        yield* _mapUpdateGoalNotificationEventToState(
            event as UpdateGoalNotificationEvent);
        break;
    }
  }

  Stream<NotiState> _mapUpdateGoalNotificationEventToState(
      UpdateGoalNotificationEvent event) async* {
    final user = authenticationBloc.userEntity;

    var noti = await notificationUseCase.getNotificationByGoalId(
        uid: user.uid, goalId: event.goalId);
    noti = noti.update(showTime: event.showTime);
    await notificationUseCase.updateNotification(
        uid: user.uid, notification: noti);
  }

  Stream<NotiState> _mapNotiInitialEventToState(NotiInitialEvent event) async* {
    if (!event.isMore) {
      _notificationList.clear();
      yield NotiLoadingState();
    } else {
      yield LoadMoreNotificationState(notificationList: _notificationList);
    }
    final connectResult = await InternetUtil.checkInternetConnection();
    if (connectResult == ConnectivityResult.wifi ||
        connectResult == ConnectivityResult.mobile) {
      final user = authenticationBloc.userEntity;
      final notis = await notificationUseCase.getNotification(
          uid: user.uid,
          currentDate: _now.millisecondsSinceEpoch,
          loadMore: event.isMore);
      _notificationList.addAll(notis);
      yield NotiInitialState(notificationList: _notificationList);
    } else {
      yield NotificationNoInternetState();
    }
  }

  Stream<NotiState> _mapReadNotiEventToState(ReadNotiEvent event) async* {
    yield NotiLoadingState();
    if (!event.notification.isRead!) {
      final user = authenticationBloc.userEntity;
      await notificationUseCase.updateNotification(
          uid: user.uid,
          notification: event.notification.update(
            isRead: true,
          ));
    }
    late GoalEntity entity;
    final user = authenticationBloc.userEntity;
    switch (NotificationTypeEnum().getTypeByName(event.notification.type!)) {
      case NotiType.goal:
        entity =
            await goalUseCase.getGoalById(user.uid!, event.notification.id!);
        break;
      default:
        break;
    }
    if (NotificationTypeEnum().getTypeByName(event.notification.type!) ==
        NotiType.goal) {
      yield NotificationPushToEditGoalState(entity);
    }
    add(NotiInitialEvent(isMore: false));
  }

  Stream<NotiState> _mapCreateNotificationEvent(
      CreateNotificationEvent event) async* {
    final NotificationEntity noti = NotificationEntity(
        isRead: false,
        type: event.type?.name,
        createAt: event.createTime,
        showtime: event.showTime,
        message: event.messages ?? '',
        key: event.categoryName,
        id: event.goalId);

    final user = authenticationBloc.userEntity;
    await notificationUseCase.createNotification(
        uid: user.uid, notification: noti);
    add(NotiInitialEvent());
    unreadNotificationBloc.add(UnreadNotificationInitEvent());
  }

  Stream<NotiState> _mapDeleteNotiEvent(DeleteGoalNotiEvent event) async* {
    final user = authenticationBloc.userEntity;
    await notificationUseCase.deleteNotification(
        uid: user.uid, notiId: event.goalID);
    add(NotiInitialEvent());
  }
}
