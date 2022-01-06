import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/domain/usecases/noti_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/unread_notification_bloc/bloc.dart';
import 'package:spendy_re_work/presentation/bloc/unread_notification_bloc/unread_notification_event.dart';
import 'package:spendy_re_work/presentation/bloc/unread_notification_bloc/unread_notification_state.dart';

class UnreadNotificationBloc
    extends Bloc<UnreadNotificationEvent, UnreadNotificationState> {
  final NotificationUseCase notificationUseCase;
  final AuthenticationBloc authenticationBloc;

  UnreadNotificationBloc(
      {required this.notificationUseCase, required this.authenticationBloc})
      : super(UnreadNotificationState.init());

  @override
  Stream<UnreadNotificationState> mapEventToState(
      UnreadNotificationEvent event) async* {
    if (event is UnreadNotificationInitEvent) {
      yield* _mapUnreadNotiInitEventToState(event);
    } else if (event is ListenUnreadNotificationRealTimeEvent) {
      yield state.update(isUnread: event.isUnread);
    }
  }

  Stream<UnreadNotificationState> _mapUnreadNotiInitEventToState(
      UnreadNotificationInitEvent event) async* {
    yield UnreadNotificationState.init();
    final user = authenticationBloc.userEntity;
    if (user.uid != null) {
      notificationUseCase
          .listenUnReadNotification(user.uid ?? '')
          .listen((isUnread) {
        add(ListenUnreadNotificationRealTimeEvent(isUnread));
      });
    }
  }
}
