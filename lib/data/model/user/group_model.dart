import 'package:spendy_re_work/domain/entities/user/group_entity.dart';

class GroupModel extends GroupEntity {
  GroupModel(
      {String? id,
      required bool isDefault,
      String? name,
      String? type,
      int? updateAt,
      int? countParticipants,
      int? totalAmount})
      : super(
            id: id,
            isDefault: isDefault,
            name: name ?? '',
            type: type,
            updateAt: updateAt,
            countParticipants: countParticipants,
            totalAmount: totalAmount);
  factory GroupModel.fromJson(Map<String, dynamic> json, String? id) {
    return GroupModel(
        id: id,
        isDefault: json['isDefault'],
        name: json['name'],
        type: json['type'],
        updateAt: json['updateAt'],
        countParticipants: json['countParticipants'],
        totalAmount: json['total_amount']);
  }
  Map<String, dynamic> toJson() => {
        'isDefault': isDefault,
        'name': name,
        'type': type,
        'updateAt': updateAt,
        'countParticipants': countParticipants,
        'total_amount': totalAmount
      };
  @override
  String toString() {
    return 'GroupModel:{isDefault: $isDefault,name:$name}';
  }
}
