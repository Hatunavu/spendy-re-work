import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/enums/notification_enum/notification_type.dart';
import 'package:spendy_re_work/domain/usecases/local_notification_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/notification_manager_bloc/bloc.dart';
import 'package:spendy_re_work/presentation/journey/home/notification/noti_bloc.dart';
import 'package:spendy_re_work/presentation/journey/home/notification/noti_event.dart';

class NotificationManagerBloc extends Bloc<NotificationManagerEvent, NotificationManagerState> {
  final LocalNotificationUseCase localNotificationUseCase;
  final NotificationBloc notificationBloc;

  NotificationManagerBloc({required this.localNotificationUseCase, required this.notificationBloc})
      : super(InitNotificationManagerState());

  @override
  Stream<NotificationManagerState> mapEventToState(NotificationManagerEvent event) async* {
    if (event is InitEvent) {
      yield* _mapInitEventToState(event);
    } else if (event is ShowNotificationEvent) {
      yield* _mapNotificationOnTapEventToState(event);
    }
  }

  Stream<NotificationManagerState> _mapInitEventToState(InitEvent event) async* {
    yield InitNotificationManagerState();
  }

  Stream<NotificationManagerState> _mapNotificationOnTapEventToState(
      ShowNotificationEvent event) async* {
    await localNotificationUseCase.showNotification(event.receiveNotificationEntity);
    notificationBloc.add(CreateNotificationEvent(
        messages: event.receiveNotificationEntity.body,
        showTime: event.receiveNotificationEntity.sendTime,
        type: NotiType.system,
        createTime: event.receiveNotificationEntity.sendTime));
  }
}
