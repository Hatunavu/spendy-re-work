import 'package:spendy_re_work/common/enums/notification_enum/notification_message.dart';
import 'package:sprintf/sprintf.dart';
import 'package:flutter_translate/flutter_translate.dart';

class NotificationTypeEnum {
  NotiType getTypeByName(String name) {
    return NotiType.values.firstWhere((type) => type.name.compareTo(name) == 0);
  }

  String getMessage(
    NotiType type,
    List<String> argument,
  ) {
    switch (type) {
      case NotiType.goal:
        {
          return sprintf(NotificationMessage.goalMsg, argument);
        }
      case NotiType.expense:
        return '';
      default:
        return '';
    }
  }
}

enum NotiType { expense, goal, system }

extension NotiTypeExtension on NotiType {
  String get name {
    switch (this) {
      case NotiType.expense:
        return 'EXPENSE';
      case NotiType.goal:
        return 'GOAL';
      case NotiType.system:
        return 'SYSTEM';
      default:
        return '';
    }
  }

  String get message {
    switch (this) {
      case NotiType.goal:
        return translate('label.goal_msg_key');
      case NotiType.expense:
        return '';
      default:
        return '';
    }
  }
}
