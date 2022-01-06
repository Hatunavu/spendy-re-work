import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/push_notification/push_notification_services.dart';
import 'package:spendy_re_work/data/model/notification/push_notification_model.dart';
import 'package:spendy_re_work/domain/entities/notifications/push_notification_entity.dart';
import 'package:spendy_re_work/domain/entities/receive_notification_entity.dart';
import 'package:spendy_re_work/presentation/bloc/notification_manager_bloc/bloc.dart';
import 'package:spendy_re_work/presentation/bloc/push_notification_bloc/bloc.dart';
import 'package:spendy_re_work/presentation/journey/home/blocs/home_bloc/home_bloc.dart';
import 'package:spendy_re_work/presentation/journey/home/widgets/body_home.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/loader/loading_flare_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  StreamSubscription<PushNotificationState>?
      _pushNotificationStateStreamSubscription;
  final InAppReview inAppReview = InAppReview.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _initNotificationService();
    });
    _pushNotificationStateStreamSubscription =
        BlocProvider.of<PushNotificationBloc>(context).stream.listen((state) {
      if (state is NotificationOnTapState) {
        _route(context, state.pushNotificationEntity);
      } else if (state is OnReceivePushNotificationState) {
        BlocProvider.of<NotificationManagerBloc>(context).add(
            ShowNotificationEvent(ReceiveNotificationEntity(
                title: state.pushNotificationEntity!.notification!.title!,
                body: state.pushNotificationEntity!.notification!.body!,
                payload:
                    state.pushNotificationEntity!.data!.toModel().toRawJson(),
                sendTime: state.pushNotificationEntity!.sentTime)));
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _pushNotificationStateStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      BlocProvider.of<HomeBloc>(context).add(OnResumeEvent(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        //   resizeToAvoidBottomPadding: false,
        body: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) async {
            if (state is HomeLoaded) {
              if (state.showRate) {
                if (await inAppReview.isAvailable()) {
                  await inAppReview.requestReview();
                }
              }
            }
          },
          builder: (context, state) {
            if (state is HomeLoaded) {
              return const BodyHome();
            }
            return FlareLoadingWidget(
              marginBottom: true,
            );
            //return Container();
          },
        ));
  }

  Future<void> _initNotificationService() async {
    final duration = Platform.isIOS ? 3 : 1;
    Future.delayed(
        Duration(seconds: duration),
        () => PushNotificationService().initialize(context,
                handleNotificationTap: (payload) async {
              final notificationModel =
                  PushNotificationModel.fromRawJson(payload);
              BlocProvider.of<PushNotificationBloc>(context).add(
                  NotificationOnTapEvent(
                      PushNotificationEntity.parseEntity(notificationModel)));
            }));
  }

  Future<void> _route(context, PushNotificationEntity notification) async {
    switch (notification.data?.routeTo) {
      case RouteList.noti:
        await Navigator.of(context).pushNamed(RouteList.noti);
        break;
      default:
        break;
    }
  }
}
