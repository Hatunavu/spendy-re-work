import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';

abstract class ProfileEvent extends Equatable {}

class TypingNameEvent extends ProfileEvent {
  final String name;

  TypingNameEvent(this.name);

  @override
  List<Object> get props => [name];
}

class OpenGalleryEvent extends ProfileEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class OpenCameraEvent extends ProfileEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class UpdateProfileEvent extends ProfileEvent {
  final String fullName;

  UpdateProfileEvent({required this.fullName});

  @override
  List<Object> get props => throw UnimplementedError();
}
