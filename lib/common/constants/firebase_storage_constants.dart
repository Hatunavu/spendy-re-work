class FirebaseStorageConstants {
  static const String userCollection = 'user';
  static const String userGoalCollection = 'userGoal';
  static const String goalCollection = 'goal';
  static const String pinField = 'pin_code';
  static const String uidField = 'uid';

  /// ===== COMMON =====
  static const String createAtField = 'create_at';
  static const String lastUpdateField = 'last_update';
  static const int limitRequest = 15;

  /// HOME
  static const String notificationCollection = 'notification';

  /// ===== TRANSACTION =====
  static const String transactionCollection = 'transaction';

  /// ===== EXPENSE =====
  static const String expenseCollection = 'expense';
  static const String searchRecentlyCollection = 'searchRecently';
  static const String userField = 'user';
  static const String categoryField = 'category';
  static const String forWhoField = 'for_who';
  static const String groupField = 'group';
  static const String searchCountField = 'search_count';
  static const String searchTimeField = 'search_time';
  static const String expenseIdField = 'expense_id';
  static const String timeSort = 'time_sort';
  static const String remarksField = 'remarks';
  static const String updateAt = 'update_at';

  /// ===== PARTICIPANT =====
  static const String participantCollection = 'participant';
  static const String nameField = 'name';
  static const String spendTimeField = 'spend_time';

  /// ===== CATEGORY =====
  static const String categoryCollection = 'category';
  static const String typeField = 'type';
  static const String transactionType = 'EXPENSE';
  static const String goalType = 'GOAL';
  static const String categoryType = 'type';

  /// ===== GOAL ====
  static const String goalCompleteField = 'complete_at';
  static const String goalField = 'goal';
  static const String dateField = 'date';
  static const String expiredDateField = 'expired_date';

  /// ===== NOTIFICATION =====
  static const String notiTimerField = 'noti_timer';
  static const String notifyTypeField = 'type';
  static const String typeID = 'type_id';
  // static const String showTime = 'show_time';
  static const String systemCollection = 'system';
  static const String showTimeField = 'show_time';
  static const String goalIdField = 'goal_id';
  static const String isReadField = 'is_read';

  /// ===Setting===
  static const String groupCollection = 'group';
  static const String participantsCollection = 'participants';
}
