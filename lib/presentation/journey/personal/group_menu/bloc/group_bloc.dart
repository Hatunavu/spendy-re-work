import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/domain/usecases/group_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_event.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupUseCase groupUseCase;
  final AuthenticationBloc authenticationBloc;
  GroupBloc({
    required this.groupUseCase,
    required this.authenticationBloc,
  }) : super(GroupInitState(groups: const []));

  @override
  Stream<GroupState> mapEventToState(GroupEvent event) async* {
    if (event is GroupInitEvent) {
      yield* _mapGroupInitEventToState(event);
    }
    if (event is GroupRefreshEvent) {
      yield* _mapGroupRefreshEventToState(event);
    }
    if (event is GroupDeleteEvent) {
      yield* _mapGroupDeleteEventToState(event);
    }
  }

  Stream<GroupState> _mapGroupInitEventToState(GroupInitEvent event) async* {
    try {
      yield GroupLoadingState();
      final _user = authenticationBloc.userEntity;
      final _groups = await groupUseCase.getDataGroup(_user.uid!);
      yield GroupUpdateState(groups: _groups..sort((g1, g2) => g1.isDefault ? 0 : 1));
    } catch (e) {
      yield GroupErroredState();
    }
  }

  Stream<GroupState> _mapGroupRefreshEventToState(GroupRefreshEvent event) async* {
    try {
      yield GroupLoadingState();
      final _user = authenticationBloc.userEntity;
      final _groups = await groupUseCase.getDataGroup(_user.uid!);
      yield GroupUpdateState(groups: _groups..sort((g1, g2) => g1.isDefault ? 0 : 1));
    } catch (e) {
      yield GroupErroredState();
    }
  }

  Stream<GroupState> _mapGroupDeleteEventToState(GroupDeleteEvent event) async* {
    try {
      yield GroupLoadingState();
      final _user = authenticationBloc.userEntity;
      await groupUseCase.deleteGroups(_user.uid!, event.id!);
      final _groups = await groupUseCase.getDataGroup(_user.uid!);
      yield GroupUpdateState(groups: _groups..sort((g1, g2) => g1.isDefault ? 0 : 1));
    } catch (e) {
      yield GroupDeleteErroredState();
    }
  }
}
