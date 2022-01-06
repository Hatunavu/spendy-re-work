import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/push_notification/push_notification_services.dart';
import 'package:spendy_re_work/presentation/bloc/push_notification_bloc/bloc.dart';

class PushNotificationBloc extends Bloc<PushNotificationEvent, PushNotificationState> {
  final PushNotificationService pushNotificationService;

  PushNotificationBloc(this.pushNotificationService) : super(InitState());

  @override
  Stream<PushNotificationState> mapEventToState(PushNotificationEvent event) async* {
    if (event is InitEvent) {
      yield* _mapInitEventToState(event);
    } else if (event is NotificationOnTapEvent) {
      yield* _mapNotificationOnTapEventToState(event);
    } else if (event is OnReceivePushNotificationEvent) {
      yield* _mapOnReceivePushNotificationEventToState(event);
    } else if (event is OnGetCountUnreadNotificationEvent) {
      yield* _mapOnGetCountUnreadNotificationEventToState(event);
    } else if (event is LogoutEvent) {
      yield* _mapLogoutEventToState(event);
    } else if (event is LogInEvent) {
      yield* _mapLogInEventToState(event);
    }
  }

  Stream<PushNotificationState> _mapInitEventToState(InitEvent event) async* {
    yield InitState();
  }

  Stream<PushNotificationState> _mapNotificationOnTapEventToState(
      NotificationOnTapEvent event) async* {
    yield NotificationOnTapState(event.pushNotificationEntity);
  }

  Stream<PushNotificationState> _mapOnReceivePushNotificationEventToState(
      OnReceivePushNotificationEvent event) async* {
    yield OnReceivePushNotificationState(pushNotificationEntity: event.pushNotificationEntity);
  }

  Stream<PushNotificationState> _mapOnGetCountUnreadNotificationEventToState(
      OnGetCountUnreadNotificationEvent event) async* {
    yield OnGetCountUnreadNotificationState();
  }

  Stream<PushNotificationState> _mapLogoutEventToState(LogoutEvent event) async* {
    pushNotificationService.unsubscribeFromTopic();
    await pushNotificationService.deleteToken();
  }

  Stream<PushNotificationState> _mapLogInEventToState(LogInEvent event) async* {
    pushNotificationService.subscribeToTopic();
  }
}
