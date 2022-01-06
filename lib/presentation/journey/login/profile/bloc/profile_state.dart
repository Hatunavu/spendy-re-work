import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';

abstract class ProfileState extends Equatable {
  final bool? isActive;
  final PhotoEntity? avatar;

  ProfileState({this.isActive, this.avatar});
}

class TypingState extends ProfileState {
  @override
  final bool? isActive;
  @override
  final PhotoEntity? avatar;

  TypingState({this.isActive, this.avatar})
      : super(isActive: isActive, avatar: avatar);

  @override
  List<Object> get props => throw UnimplementedError();
}

class ProfileInitialState extends ProfileState {
  @override
  final bool? isActive;
  @override
  final PhotoEntity? avatar;
  final DataState? dataState;

  ProfileInitialState({this.isActive = false, this.avatar, this.dataState})
      : super(
          isActive: isActive,
          avatar: avatar,
        );

  @override
  List<Object?> get props => [
        isActive,
        avatar,
        dataState,
      ];

  ProfileInitialState update(
          {bool? isActive, PhotoEntity? avatar, DataState? dataState}) =>
      ProfileInitialState(
        isActive: isActive ?? this.isActive,
        avatar: avatar ?? this.avatar,
        dataState: dataState ?? this.dataState,
      );
}

class ProfileLoadingState extends ProfileState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class UploadImageState extends ProfileState {
  @override
  final bool isActive;
  @override
  final PhotoEntity avatar;

  UploadImageState({required this.isActive, required this.avatar})
      : super(
          isActive: isActive,
          avatar: avatar,
        );

  @override
  List<Object> get props => [isActive, avatar];
}

class UpdateProfileState extends ProfileState {
  @override
  final bool isActive;
  @override
  final PhotoEntity avatar;

  UpdateProfileState({
    required this.isActive,
    required this.avatar,
  }) : super(
          isActive: isActive,
          avatar: avatar,
        );

  @override
  List<Object> get props => [isActive, avatar];
}

class DenisPermissionState extends ProfileState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class UpdateProfileSuccessState extends ProfileState {
  @override
  List<Object> get props => throw UnimplementedError();
}
