import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/participant_entity.dart';

enum CreateGroupStatus { initial, initiating, initiated, updating, submitting, submitted, failed }

class CreateGroupState extends Equatable {
  final List<ParticipantEntity> participants;
  final String groupName;
  final CreateGroupStatus status;
  final dynamic error;
  final bool isValidated;

  CreateGroupState({
    required this.participants,
    required this.groupName,
    required this.status,
    this.error,
    required this.isValidated,
  });

  factory CreateGroupState.initial() {
    return CreateGroupState(
      groupName: '',
      participants: const [],
      status: CreateGroupStatus.initial,
      isValidated: false,
    );
  }

  CreateGroupState copyWith({
    List<ParticipantEntity>? participants,
    String? groupName,
    CreateGroupStatus? status,
    dynamic error,
    bool? isValidated,
  }) {
    return CreateGroupState(
      participants: participants ?? this.participants,
      groupName: groupName ?? this.groupName,
      status: status ?? this.status,
      error: error,
      isValidated: isValidated ?? this.isValidated,
    );
  }

  @override
  List<Object?> get props => [participants, groupName, status, isValidated, error];
}
