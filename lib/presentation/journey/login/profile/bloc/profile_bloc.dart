import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:spendy_re_work/common/configs/default_env.dart';
import 'package:spendy_re_work/common/constants/category_constants/default_category.dart';
import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
import 'package:spendy_re_work/domain/usecases/app_default_usecase.dart';
import 'package:spendy_re_work/domain/usecases/categories_usecase.dart';
import 'package:spendy_re_work/domain/usecases/group_usecase.dart';
import 'package:spendy_re_work/domain/usecases/profile_user_usecase.dart';
import 'package:spendy_re_work/domain/usecases/storage_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/profile/bloc/profile_event.dart';
import 'package:spendy_re_work/presentation/journey/login/profile/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileUserUseCase profileUserUseCase;
  final StorageUseCase storageUseCase;
  final AuthenticationBloc authenticationBloc;
  final GroupUseCase groupUseCase;
  final AppDefaultUsecase appDefaultUsecase;
  final CategoriesUseCase categoriesUseCase;
  bool _isActive = false;
  PhotoEntity _avatar = PhotoEntity.normal();
  ProfileBloc(
      {required this.profileUserUseCase,
      required this.storageUseCase,
      required this.authenticationBloc,
      required this.groupUseCase,
      required this.appDefaultUsecase,
      required this.categoriesUseCase})
      : super(ProfileInitialState(dataState: DataState.none));

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    switch (event.runtimeType) {
      case TypingNameEvent:
        yield* _mapTypingEventToState(event as TypingNameEvent);
        break;
      case OpenGalleryEvent:
        yield* _mapOpenGalleryEvent();
        break;
      case OpenCameraEvent:
        yield* _mapOpenCameraEvent();
        break;
      case UpdateProfileEvent:
        yield* _mapUpdateProfileEventToState(event as UpdateProfileEvent);
        break;
    }
  }

  Stream<ProfileState> _mapTypingEventToState(TypingNameEvent event) async* {
    yield TypingState(isActive: _isActive, avatar: _avatar);
    if (event.name.trim().isNotEmpty) {
      _isActive = true;
    } else {
      _isActive = false;
    }
    yield ProfileInitialState(isActive: _isActive, avatar: _avatar);
  }

  Stream<ProfileState> _mapOpenGalleryEvent() async* {
    final List<Asset> assets = await storageUseCase.openGallery();
    // final currentState = state;
    if (assets.isNotEmpty) {
      yield UploadImageState(isActive: false, avatar: _avatar);
      await _getAvatar(asset: assets[0]);
    }
    yield ProfileInitialState(isActive: _isActive, avatar: _avatar);
  }

  Stream<ProfileState> _mapOpenCameraEvent() async* {
    final XFile imageFile = await storageUseCase.openCamera() as XFile;
    yield UploadImageState(isActive: false, avatar: _avatar);
    await _getAvatar(file: imageFile);

    yield ProfileInitialState(isActive: _isActive, avatar: _avatar);
  }

  Stream<ProfileState> _mapUpdateProfileEventToState(
      UpdateProfileEvent event) async* {
    final currentState = state;
    if (currentState is ProfileInitialState) {
      yield currentState.update(dataState: DataState.loading);
      final UserEntity userEntity = authenticationBloc.userEntity
        ..avatar = _avatar.path!
        ..fullName = event.fullName
        ..setting;
      await profileUserUseCase.updateProfile(userEntity);
      await categoriesUseCase.createDefaultCategory(userEntity.uid ?? '',
          DefaultCategory.getDefault(DateTime.now().millisecondsSinceEpoch));
      await groupUseCase.createDefaultGroup(authenticationBloc.userEntity.uid!,
          appDefaultUsecase.getGroupRemoteConfig());
      yield currentState.update(dataState: DataState.success);
    }
  }

  Future<void> _getAvatar({Asset? asset, XFile? file}) async {
    final UserEntity user = authenticationBloc.userEntity;
    final List<PhotoEntity> imageUrls = await storageUseCase.uploadImageUrls(
      DefaultConfig.profileDoc,
      imageFiles: file != null ? [file] : null,
      imageAssets: asset != null ? [asset] : null,
      uid: user.uid,
    );
    if (imageUrls.isNotEmpty) {
      _avatar = await storageUseCase.getPhotoUri(imageUrls[0]);
      await _updateProfile();
    }
  }

  Future<void> _updateProfile() async {
    final UserEntity userEntity = authenticationBloc.userEntity
      ..avatar = _avatar.path!;
    await profileUserUseCase.updateProfile(userEntity);
  }
}
