import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/journey/home/notification/widgets/body_notification.dart';
import 'package:spendy_re_work/presentation/widgets/base_scaffold/base_scaffold.dart';
import 'notification_constants.dart';

class NotiScreen extends StatefulWidget {
  @override
  _NotiScreenState createState() => _NotiScreenState();
}

class _NotiScreenState extends State<NotiScreen> {
  //ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      context,
      leading: true,
      key: _scaffoldKey,
      appBarTitle: NotificationConstants.notiTitle,
      actionAlignment: Alignment.bottomRight,
      body: Padding(
        padding: EdgeInsets.only(top: NotificationConstants.paddingTop18),
        child: const BodyNotification(),
      ),
    );
  }
}
