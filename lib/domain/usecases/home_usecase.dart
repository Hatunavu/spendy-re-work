class HomeUseCase {
  /// use for monthly spending notices
  // NotificationEntity getNotificationBetween2MonthNotify(
  //     {DateTime? dateTime,
  //     SettleDebt? month,
  //     SettleDebt? lastMonth,
  //     String? notifyType,
  //     NotificationEntity? inputNotify,
  //     CurrencyEntity? currency}) {
  //   assert(
  //       dateTime != null &&
  //           month != null &&
  //           lastMonth != null &&
  //           notifyType != null &&
  //           inputNotify != null &&
  //           currency != null,
  //       'date time, month, last month, notify type input notify type and currrency must not be null');
  //
  //   final NotificationEntity notificationEntity = inputNotify!;
  //   String _keyMsg ;
  //   String _keyMsg1;
  //
  //   int totalLastMonth;
  //   int totalMonth;
  //
  //   String typeMsgKey;
  //
  //   if (notifyType == NotificationConstants.spentType) {
  //     // spent percent
  //     totalLastMonth = lastMonth!.totalExpense.toInt();
  //     totalMonth = month!.totalExpense.toInt();
  //   } else {
  //     // debt percent
  //     totalLastMonth = lastMonth!.totalOwed.toInt();
  //     totalMonth = month!.totalOwed.toInt();
  //   }
  //
  //   if (totalLastMonth == 0 || totalLastMonth == totalMonth) {
  //     // if total last month = total month or total last month = 0
  //     _keyMsg =
  //         '${totalMonth.toString().formatStringToCurrency(haveSymbol: true)}';
  //     _keyMsg1 = '${dateTime!.toStringMMyyyy}';
  //
  //     if (notifyType == NotificationConstants.spentType) {
  //       typeMsgKey = NotificationConstants.spentAmountMsgKey;
  //     } else if (notifyType == NotificationConstants.debtType) {
  //       typeMsgKey = NotificationConstants.debtAmountMsgKey;
  //     }
  //   } else {
  //     final percent = (totalMonth - totalLastMonth) / totalLastMonth * 100;
  //
  //     if (percent > 0) {
  //       _keyMsg =
  //           '${percent.abs().toStringAsFixed(2)}% ${NotificationConstants.textMore}';
  //     } else if (percent < 0) {
  //       _keyMsg =
  //           '${percent.abs().toStringAsFixed(2)}% ${NotificationConstants.textLess}';
  //     }
  //
  //     if (notifyType == NotificationConstants.spentType) {
  //       typeMsgKey = NotificationConstants.spentMsgKey;
  //     } else if (notifyType == NotificationConstants.debtType) {
  //       typeMsgKey = NotificationConstants.debtMsgKey;
  //     }
  //   }

  // notificationEntity.notiTimer =
  //     DateTime.now().firstDayOfMonth.millisecondsSinceEpoch;
  // notificationEntity.type = notifyType;
  // notificationEntity.message =
  //     NotificationConstants.mapTypeMessage[typeMsgKey];
  // notificationEntity._keyMsg = _keyMsg;
  // notificationEntity._keyMsg1 = _keyMsg1;
  // notificationEntity.isRead = false;

//     return notificationEntity;
//   }
// }
}
