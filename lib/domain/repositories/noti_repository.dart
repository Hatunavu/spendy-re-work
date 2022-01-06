import 'package:spendy_re_work/domain/entities/notifications/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotification(
      {String uid, int currentDate, bool loadMore = false});
  Future createNotification({String? uid, NotificationEntity? notification});
  Future updateNotification({String? uid, NotificationEntity? notification});
  Future deleteNotification({String? uid, String? notiId});
  Future<NotificationEntity> getNotificationByGoalId(
      {String? uid, String? goalId});
  Future<bool> isUnreadNotification(String uid, int currentDate);
  Stream listenNotification(String uid);
  Stream listenUnReadNotification(String uid);
  void requestMore(String uid);
  void clear();
}
