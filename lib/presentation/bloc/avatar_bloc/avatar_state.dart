import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';

abstract class AvatarState extends Equatable {
  // final PhotoEntity avatar;
  //
  // AvatarState(this.avatar);
}

class LoadingAvatarState extends AvatarState {
  //LoadingAvatarState({PhotoEntity? avatar}) : super(avatar!);
  //LoadingAvatarState();
  @override
  List<Object> get props => [];
}

class LoaderAvatarState extends AvatarState {
  final PhotoEntity avatar;
  LoaderAvatarState({required this.avatar});

  @override
  List<Object> get props => [avatar];
}

class UpdateAvatarFailedState extends AvatarState {
  final PhotoEntity avatar;
  UpdateAvatarFailedState({required this.avatar});

  @override
  List<Object> get props => [avatar];
}
