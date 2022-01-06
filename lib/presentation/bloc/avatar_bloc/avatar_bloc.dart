import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:spendy_re_work/common/configs/default_env.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
import 'package:spendy_re_work/domain/usecases/profile_user_usecase.dart';
import 'package:spendy_re_work/domain/usecases/storage_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';

import 'avatar_event.dart';
import 'avatar_state.dart';

class AvatarBloc extends Bloc<AvatarEvent, AvatarState> {
  final ProfileUserUseCase profileUserUseCase;
  final StorageUseCase storageUseCase;
  final AuthenticationBloc authenticationBloc;

  late PhotoEntity _avatar;

  AvatarBloc({
    required this.authenticationBloc,
    required this.storageUseCase,
    required this.profileUserUseCase,
  }) : super(LoadingAvatarState());

  @override
  Stream<AvatarState> mapEventToState(AvatarEvent event) async* {
    if (event is LoaderAvatarEvent) {
      yield* _mapLoaderAvatarEventToState(event);
    }
    if (event is ChangeAvatarEvent) {
      yield* _mapChangeAvatarEventToState(event);
    }
    if (event is OpenGalleryEvent) {
      yield* _mapOpenGalleryEvent();
    }
    if (event is OpenCameraEvent) {
      yield* _mapOpenCameraEvent();
    }
  }

  Stream<AvatarState> _mapLoaderAvatarEventToState(LoaderAvatarEvent event) async* {
    yield LoadingAvatarState();
    _avatar = await storageUseCase.getPhotoUri(PhotoEntity(path: event.avatarUrl));

    yield LoaderAvatarState(avatar: _avatar);
  }

  Stream<AvatarState> _mapChangeAvatarEventToState(ChangeAvatarEvent event) async* {}

  Stream<AvatarState> _mapOpenGalleryEvent() async* {
    final List<Asset> assets = await storageUseCase.openGallery();
    if (assets.isNotEmpty) {
      yield LoadingAvatarState();
      await _getAvatar(asset: assets[0]);
    }
    yield LoaderAvatarState(avatar: _avatar);
  }

  Stream<AvatarState> _mapOpenCameraEvent() async* {
    final XFile? imageFile = await storageUseCase.openCamera();
    if (imageFile != null) {
      yield LoadingAvatarState();
      await _getAvatar(file: imageFile);
    }
    yield LoaderAvatarState(avatar: _avatar);
  }

  Future<void> updateProfile() async {
    final UserEntity userEntity = authenticationBloc.userEntity..avatar = _avatar.path!;
    await profileUserUseCase.updateProfile(userEntity);
  }

  Future<void> _getAvatar({Asset? asset, XFile? file}) async {
    final UserEntity user = authenticationBloc.userEntity;
    final List<PhotoEntity>? imageUrls = await storageUseCase.uploadImageUrls(
      DefaultConfig.profileDoc,
      imageFiles: file != null ? [file] : null,
      imageAssets: asset != null ? [asset] : null,
      uid: user.uid,
    );
    if (imageUrls != null && imageUrls.isNotEmpty) {
      _avatar = await storageUseCase.getPhotoUri(imageUrls[0]);
      await updateProfile();
    }
  }
}
