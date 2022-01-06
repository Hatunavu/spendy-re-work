import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_state.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/select_group/bloc/select_group_state.dart';

class SelectGroupBloc extends Cubit<SelectGroupState> {
  final GroupBloc groupBloc;
  final groups = <GroupEntity>[];

  SelectGroupBloc({
    required this.groupBloc,
  }) : super(SelectGroupState.initial()) {
    if (groupBloc.state is GroupUpdateState) {
      groups
        ..clear()
        ..addAll(
          (groupBloc.state as GroupUpdateState).groups.where((gr) => !gr.isDefault).toList(),
        );
    }
  }

  Future<void> getGroups() async {
    emit(state.copyWith(groups: groups));
  }

  Future<void> searchGroup(String keyword) async {
    if (keyword.isEmpty) {
      emit(state.copyWith(groups: groups));
      return;
    }
    final filteredGroups =
        groups.where((gr) => gr.name.toLowerCase() == keyword.toLowerCase()).toList();
    emit(state.copyWith(groups: filteredGroups));
  }

  void setSelectedGroup(GroupEntity? group) {
    emit(state.copyWith(selectedGroup: group));
  }
}
