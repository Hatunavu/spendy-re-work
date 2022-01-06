import 'package:spendy_re_work/data/datasources/remote/noti_datasource.dart';
import 'package:spendy_re_work/data/model/notification/notification_model.dart';
import 'package:spendy_re_work/domain/entities/notifications/notification_entity.dart';
import 'package:spendy_re_work/domain/repositories/noti_repository.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final NotificationDataSource notificationDataSource;

  NotificationRepositoryImpl({
    required this.notificationDataSource,
  });

  @override
  Future createNotification({String? uid, NotificationEntity? notification}) =>
      notificationDataSource.createNotification(uid!, notification!.toModel());

  @override
  Future<List<NotificationEntity>> getNotification(
          {String? uid, int? currentDate, bool loadMore = false}) =>
      notificationDataSource.getNotification(uid!, currentDate!,
          loadMore: loadMore);

  @override
  Future updateNotification({String? uid, NotificationEntity? notification}) =>
      notificationDataSource.updateNotification(uid!, notification!.toModel());

  @override
  Future deleteNotification({String? uid, String? notiId}) =>
      notificationDataSource.removeNotification(uid: uid, notiId: notiId);

  @override
  Future<NotificationModel> getNotificationByGoalId(
          {String? uid, String? goalId}) =>
      notificationDataSource.getNotificationByGoalId(uid: uid, goalId: goalId);

  @override
  Future<bool> isUnreadNotification(String uid, int currentDate) =>
      notificationDataSource.isUnreadNotification(uid, currentDate);

  @override
  Stream listenNotification(String uid) =>
      notificationDataSource.listenNotification(uid);

  @override
  Stream listenUnReadNotification(String uid) =>
      notificationDataSource.listenUnReadNoti(uid);

  @override
  void requestMore(String uid) => notificationDataSource.loadMore(uid);

  @override
  void clear() => notificationDataSource.clear();
}
