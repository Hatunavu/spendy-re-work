import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';

abstract class GroupState extends Equatable {}

class GroupInitState extends GroupState {
  final List<GroupEntity> groups;

  GroupInitState({required this.groups});

  @override
  List<Object?> get props => [groups];
}

class GroupUpdateState extends GroupState {
  final List<GroupEntity> groups;
  final DateTime lastUpdated;
  GroupUpdateState({required this.groups}) : lastUpdated = DateTime.now();

  @override
  List<Object?> get props => [groups, lastUpdated];
}

class GroupLoadingState extends GroupState {
  @override
  List<Object?> get props => [];
}

class GroupErroredState extends GroupState {
  @override
  List<Object?> get props => [];
}

class GroupDeleteErroredState extends GroupState {
  @override
  List<Object?> get props => [];
}
