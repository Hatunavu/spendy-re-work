class ReceiveNotificationEntity {
  int id;
  final String title;
  final String body;
  final String? payload;
  final dynamic sendTime;

  ReceiveNotificationEntity(
      {this.id = 0,
      required this.title,
      required this.body,
      this.payload,
      this.sendTime});
}
