import 'package:equatable/equatable.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';

class SelectGroupState extends Equatable {
  final List<GroupEntity> groups;
  final GroupEntity? selectedGroup;

  SelectGroupState({
    required this.groups,
    this.selectedGroup,
  });

  factory SelectGroupState.initial() => SelectGroupState(groups: const []);

  SelectGroupState copyWith({
    List<GroupEntity>? groups,
    GroupEntity? selectedGroup,
  }) =>
      SelectGroupState(
        groups: groups ?? this.groups,
        selectedGroup: selectedGroup ?? this.selectedGroup,
      );
  @override
  List<Object?> get props => [groups, selectedGroup];
}
