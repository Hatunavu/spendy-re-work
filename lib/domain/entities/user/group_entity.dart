import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/data/model/user/group_model.dart';

class GroupEntity extends Equatable {
  final String? id;
  final bool isDefault;
  final String name;
  final String? type;
  final int? updateAt;
  final int? countParticipants;
  final int? totalAmount;

  GroupEntity(
      {this.id,
      this.isDefault = false,
      this.name = '',
      this.type,
      this.updateAt,
      this.countParticipants,
      this.totalAmount = 0});

  GroupModel toModel() {
    return GroupModel(
      id: id,
      isDefault: isDefault,
      name: name,
      type: type,
      updateAt: updateAt,
      countParticipants: countParticipants,
      totalAmount: totalAmount,
    );
  }

  @override
  String toString() {
    return 'GroupEntity(name: $name, id: $id)';
  }

  @override
  List<Object?> get props => [id];
}
