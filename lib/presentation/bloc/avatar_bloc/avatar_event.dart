import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';

abstract class AvatarEvent extends Equatable {}

class LoaderAvatarEvent extends AvatarEvent {
  final String avatarUrl;

  LoaderAvatarEvent(this.avatarUrl);
  @override
  List<Object> get props => [avatarUrl];
}

class ChangeAvatarEvent extends AvatarEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class OpenGalleryEvent extends AvatarEvent {
  @override
  List<Object> get props => [];
}

class OpenCameraEvent extends AvatarEvent {
  @override
  List<Object> get props => [];
}
