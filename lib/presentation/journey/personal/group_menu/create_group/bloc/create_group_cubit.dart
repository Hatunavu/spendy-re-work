import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/domain/entities/participant_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
import 'package:spendy_re_work/domain/usecases/group_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/event_bus_bloc/bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_event.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/create_group/bloc/create_group_state.dart';

class CreateGroupCubit extends Cubit<CreateGroupState> {
  final GroupUseCase groupUseCase;
  final AuthenticationBloc authenticationBloc;
  final GroupBloc groupBloc;
  final EventBusBloc eventBusBloc;

  late UserEntity _user;
  GroupEntity? _group;
  final List<ParticipantEntity> _deletedParticipants = [];

  CreateGroupCubit(
      {required this.groupBloc,
      required this.groupUseCase,
      required this.authenticationBloc,
      required this.eventBusBloc})
      : super(CreateGroupState.initial()) {
    _user = authenticationBloc.userEntity;
  }

  Future<void> initGroupData(GroupEntity? group) async {
    try {
      _group = group;
      if (group != null && group.id != null && _user.uid != null) {
        emit(state.copyWith(status: CreateGroupStatus.initiating));
        final _participants =
            await groupUseCase.getDataParticipantList(_user.uid!, group.id!);
        emit(
          state.copyWith(
            status: CreateGroupStatus.initiated,
            groupName: group.name,
            participants: _participants,
            isValidated: _checkValidated(group.name, _participants),
          ),
        );
      } else {
        emit(state.copyWith(status: CreateGroupStatus.initiated));
      }
    } catch (e) {
      emit(state.copyWith(status: CreateGroupStatus.failed, error: e));
    }
  }

  void updateGroupName(String groupName) {
    emit(
      state.copyWith(
        status: CreateGroupStatus.updating,
        groupName: groupName,
        isValidated: _checkValidated(groupName, state.participants),
      ),
    );
  }

  void addParticipant() {
    final _participants = List<ParticipantEntity>.from(state.participants)
      ..add(ParticipantEntity(name: ''));
    emit(
      state.copyWith(
        status: CreateGroupStatus.updating,
        participants: _participants,
        isValidated: _checkValidated(state.groupName, _participants),
      ),
    );
  }

  void deleteParticipant(int index) {
    final _participant = state.participants[index];
    if (_participant.id?.isEmpty ?? false) {
      _deletedParticipants.add(_participant);
    }
    final _participants = List<ParticipantEntity>.from(state.participants)
      ..removeAt(index);
    emit(
      state.copyWith(
        status: CreateGroupStatus.updating,
        participants: _participants,
        isValidated: _checkValidated(state.groupName, _participants),
      ),
    );
  }

  void updateParticipant(int index, String name) {
    final _participant = state.participants[index];
    final _participants = List<ParticipantEntity>.from(state.participants)
      ..[index] = ParticipantEntity(name: name, id: _participant.id);
    emit(
      state.copyWith(
        status: CreateGroupStatus.updating,
        participants: _participants,
        isValidated: _checkValidated(state.groupName, _participants),
      ),
    );
  }

  Future<void> saveGroup() async {
    try {
      emit(state.copyWith(status: CreateGroupStatus.submitting));
      if (_group != null && _group?.id != null) {
        await groupUseCase.updateGroup(
          _user.uid!,
          _group!.id!,
          GroupEntity(
            type: 'debts',
            isDefault: false,
            name: state.groupName,
            countParticipants: state.participants.length + 1,
            updateAt: DateTime.now().microsecondsSinceEpoch,
          ),
          state.participants,
          _deletedParticipants,
        );
        eventBusBloc.add(RefreshParticipantInTransactionEvent());
      } else {
        await groupUseCase.addGroups(
          _user.uid!,
          GroupEntity(
            type: 'debts',
            isDefault: false,
            name: state.groupName,
            countParticipants: state.participants.length + 1,
            updateAt: DateTime.now().microsecondsSinceEpoch,
          ),
          state.participants,
        );
      }
      groupBloc.add(GroupRefreshEvent());
      emit(state.copyWith(status: CreateGroupStatus.submitted));
    } catch (e) {
      emit(state.copyWith(status: CreateGroupStatus.failed, error: e));
    }
  }

  bool _checkValidated(String groupName, List<ParticipantEntity> participants) {
    if (groupName.isEmpty || groupName.length == 1) {
      return false;
    }
    for (final item in participants) {
      if (item.name.isEmpty || item.name.length == 1) {
        return false;
      }
    }
    return true;
  }
}
