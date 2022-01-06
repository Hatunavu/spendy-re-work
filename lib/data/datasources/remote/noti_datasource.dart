import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendy_re_work/common/configs/default_env.dart';
import 'package:spendy_re_work/common/constants/firebase_storage_constants.dart';
import 'package:spendy_re_work/common/firebase_setup.dart';
import 'package:spendy_re_work/data/model/notification/notification_model.dart';

class NotificationDataSource {
  final SetupFirebaseDatabase setupFirebaseDatabase;

  NotificationDataSource({required this.setupFirebaseDatabase});

  DocumentSnapshot? _useNotifiLastDocument;
  bool hasMore = true;

  Future<List<NotificationModel>> getNotification(String uid, int currentDate,
      {bool loadMore = false}) async {
    if (!loadMore) {
      _clear();
    }
    final _notifiList = <NotificationModel>[];
    final _userCollectionRef = setupFirebaseDatabase.collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.notificationCollection);

    var notifiQuery = _userCollectionRef
        .orderBy(FirebaseStorageConstants.showTimeField, descending: true)
        .where(FirebaseStorageConstants.showTimeField,
            isLessThanOrEqualTo: currentDate)
        .limit(DefaultConfig.limitNotifiRequest);

    if (!hasMore) {
      return [];
    }

    if (_useNotifiLastDocument != null) {
      notifiQuery = notifiQuery.startAfterDocument(_useNotifiLastDocument!);
    }
    await notifiQuery.get().then((notifiSnapshot) {
      if (notifiSnapshot.docs.isEmpty) {
        _notifiList.addAll([]);
      } else if (notifiSnapshot.docs.isNotEmpty) {
        final notifications = notifiSnapshot.docs
            .map((notification) => NotificationModel.fromJson(
                notification.data(), notification.id))
            .toList();
        _notifiList.addAll(notifications);
        _useNotifiLastDocument = notifiSnapshot.docs.last;
        hasMore = notifications.length == DefaultConfig.limitNotifiRequest;
      }
    });
    return _notifiList;
  }

  // ignore: missing_return
  Future<bool> isUnreadNotification(String uid, int currentDate) async {
    bool isUnread = false;
    final _userCollectionRef = setupFirebaseDatabase.collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.notificationCollection);
    final notifiQuery = _userCollectionRef
        .where(FirebaseStorageConstants.showTimeField,
            isLessThanOrEqualTo: currentDate)
        .where(FirebaseStorageConstants.isReadField, isEqualTo: false)
        .orderBy(FirebaseStorageConstants.showTimeField, descending: true);
    await notifiQuery.get().then((notifiSnapshot) {
      if (notifiSnapshot.docs.isEmpty || notifiSnapshot.docs.length == 0) {
        isUnread = false;
      } else if (notifiSnapshot.docs.isNotEmpty) {
        final notifications = notifiSnapshot.docs
            .map((notification) => NotificationModel.fromJson(
                notification.data(), notification.id))
            .toList();
        if (notifications.isEmpty) {
          isUnread = false;
        } else {
          isUnread = true;
        }
      }
    });
    return isUnread;
  }

  Future<NotificationModel> getNotificationByGoalId(
      {String? uid, String? goalId}) async {
    final documentRef = setupFirebaseDatabase.collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.notificationCollection)
        .doc(goalId);
    final snapshot = await documentRef.get();
    return NotificationModel.fromJson(
        snapshot.data() as Map<String, dynamic>, snapshot.id);
  }

  void _clear() {
    _useNotifiLastDocument = null;
    hasMore = true;
  }

  Future createNotification(String uid, NotificationModel notification) async {
    final _collectionRef = setupFirebaseDatabase.collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.notificationCollection);
    await _collectionRef.doc(notification.id).set(notification.toJson());
  }

  Future updateNotification(String uid, NotificationModel notification) async {
    final _collectionRef = setupFirebaseDatabase.collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.notificationCollection);
    await _collectionRef.doc(notification.id).update(notification.toJson());
  }

  Future removeNotification({String? uid, String? notiId}) async {
    final collectionRef = setupFirebaseDatabase.collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.notificationCollection);
    await collectionRef.doc(notiId).delete();
  }

  List<List<NotificationModel>> _notifications = <List<NotificationModel>>[];
  StreamController<List<NotificationModel>> _notificationStream =
      StreamController<List<NotificationModel>>.broadcast();
  DocumentSnapshot? _lastNoti;
  bool _hasMoreNoti = true;
  bool _isOnlyNoti = false;

  Stream listenNotification(String uid) {
    _requestNotification(uid);
    return _notificationStream.stream;
  }

  void _requestNotification(String uid, {bool loadMore = false}) {
    final CollectionReference notiCollection = setupFirebaseDatabase
        .collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.notificationCollection);

    final pageNotiQuery = notiCollection
      ..where(FirebaseStorageConstants.showTimeField,
              isLessThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
          .orderBy(FirebaseStorageConstants.showTimeField, descending: true)
          .limit(DefaultConfig.limitNotifiRequest);

    if (_lastNoti != null) {
      pageNotiQuery.startAfterDocument(_lastNoti!);
    }

    if (!_hasMoreNoti) {
      final allNoti = _notifications.fold<List<NotificationModel>>(
          <NotificationModel>[],
          (initialValue, pageItems) => initialValue..addAll(pageItems));
      _notificationStream.add(allNoti);
      return;
    }
    final currentRequestIndex = _notifications.length;

    pageNotiQuery.snapshots().listen((notiSnapshot) {
      if (notiSnapshot.docs.isEmpty && _isOnlyNoti) {
        _isOnlyNoti = false;
        _notificationStream.add([]);
      } else if (notiSnapshot.docs.isNotEmpty) {
        final expenses = notiSnapshot.docs
            .map((snapshot) => NotificationModel.fromJson(
                snapshot.data() as Map<String, dynamic>, snapshot.id))
            .toList();

        final pageExists = currentRequestIndex < _notifications.length;

        if (pageExists) {
          _notifications[currentRequestIndex] = expenses;
        } else {
          _notifications.add(expenses);
        }

        final allExpenses = _notifications.fold<List<NotificationModel>>(
            <NotificationModel>[],
            (initialValue, pageItems) => initialValue..addAll(pageItems));

        _notificationStream.add(allExpenses);

        if (currentRequestIndex == _notifications.length - 1) {
          _lastNoti = notiSnapshot.docs.last;
        }

        _hasMoreNoti = expenses.length == DefaultConfig.limitRequest;

        _isOnlyNoti = allExpenses.length == 1;
      }
    });
  }

  void loadMore(String uid) => _requestNotification(uid, loadMore: true);

  void clear() {
    _notifications = <List<NotificationModel>>[];
    _notificationStream = StreamController<List<NotificationModel>>.broadcast();
    _unReadNotiController = StreamController<bool>.broadcast();
    _lastNoti = null;
    _isOnlyNoti = false;
    _hasMoreNoti = true;
  }

  StreamController<bool> _unReadNotiController =
      StreamController<bool>.broadcast();

  Stream listenUnReadNoti(String uid) {
    _requestUnReadNoti(uid);
    return _unReadNotiController.stream;
  }

  void _requestUnReadNoti(String uid) {
    final CollectionReference notiCollection = setupFirebaseDatabase
        .collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.notificationCollection);
    final pageNotiQuery = notiCollection
        .where(FirebaseStorageConstants.showTimeField,
            isLessThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
        .where(FirebaseStorageConstants.isReadField, isEqualTo: false);
    pageNotiQuery.snapshots().listen((snapshot) {
      if (snapshot.docs.isEmpty && snapshot.docs.length == 0) {
        _unReadNotiController.add(false);
      } else if (snapshot.docs.isNotEmpty) {
        _unReadNotiController.add(true);
      }
    });
  }
}
