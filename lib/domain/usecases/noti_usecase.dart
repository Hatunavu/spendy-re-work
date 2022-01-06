//import 'package:spendy_re_work/data/model/notification/notification_model.dart';
import 'package:spendy_re_work/domain/entities/notifications/notification_entity.dart';
import 'package:spendy_re_work/domain/repositories/noti_repository.dart';

class NotificationUseCase {
  final NotificationRepository notificationRepository;

  NotificationUseCase({required this.notificationRepository});

  Future<List<NotificationEntity>> getNotification(
      {String? uid, int? currentDate, bool loadMore = false}) async {
    final List<NotificationEntity> notifications =
        await notificationRepository.getNotification(
            uid: uid!, currentDate: currentDate!, loadMore: loadMore);
    return notifications;
  }

  Future createNotification(
      {String? uid, NotificationEntity? notification}) async {
    await notificationRepository.createNotification(
        uid: uid, notification: notification);
  }

  Future updateNotification(
      {String? uid, NotificationEntity? notification}) async {
    await notificationRepository.updateNotification(
        uid: uid, notification: notification);
  }

  Future deleteNotification({String? uid, String? notiId}) =>
      notificationRepository.deleteNotification(uid: uid, notiId: notiId);

  Future<NotificationEntity> getNotificationByGoalId(
          {String? uid, String? goalId}) =>
      notificationRepository.getNotificationByGoalId(uid: uid, goalId: goalId);

  Future<bool> isUnreadNotification(String uid, int currentDate) =>
      notificationRepository.isUnreadNotification(uid, currentDate);

  Stream listenNotification(String uid) =>
      notificationRepository.listenNotification(uid);

  Stream listenUnReadNotification(String uid) =>
      notificationRepository.listenUnReadNotification(uid);

  void requestMore(String uid) => notificationRepository.requestMore(uid);

  void clear() => notificationRepository.clear();
}
