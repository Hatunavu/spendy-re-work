import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:spendy_re_work/common/configs/default_env.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';
import 'package:spendy_re_work/domain/repositories/storage_repository.dart';

class StorageUseCase {
  final StorageRepository storageRepository;

  StorageUseCase({required this.storageRepository});

  Future<List<PhotoEntity>> uploadImageUrls(String collection,
      {List<Asset>? imageAssets, List<XFile>? imageFiles, String? uid}) async {
    final List<PhotoEntity> photoList = [];
    final List<Uint8List> byteDataImageList = await getUint8ListArray(imageAssets, imageFiles);
    final List<String> pathList = await storageRepository.uploadImage(
        imageUint8ListArray: byteDataImageList, uid: uid!, collection: '$collection');
    for (final String path in pathList) {
      photoList.add(PhotoEntity(path: path));
    }
    return photoList;
  }

  Future<List<Uint8List>> getUint8ListArray(List<Asset>? imageAssets, List<XFile>? fileList) async {
    final List<Uint8List> uint8ListArray = [];
    if (imageAssets != null && imageAssets.isNotEmpty) {
      final List<Uint8List> assetsUint8ListArray = await optimizeAssetImageList(imageAssets);
      uint8ListArray.addAll(assetsUint8ListArray);
    }
    if (fileList != null && fileList.isNotEmpty) {
      for (final XFile file in fileList) {
        final Uint8List fileUint8List = await file.readAsBytes();
        uint8ListArray.add(fileUint8List);
      }
    }
    return uint8ListArray;
  }

  Future<List<Uint8List>> optimizeAssetImageList(List<Asset> imageAssets) async {
    final List<Uint8List> imageDataList = [];
    for (final Asset asset in imageAssets) {
      final ByteData byteData = await asset.getByteData(quality: 10);
      imageDataList.add(byteData.buffer.asUint8List());
    }
    return imageDataList;
  }

  Future<void> deleteImage(String photoPath) async {
    await storageRepository.deleteImage(path: photoPath);
  }

  Future<PhotoEntity> getPhotoUri(PhotoEntity photo) => storageRepository.getUrl(path: photo.path!);

  Future<XFile?> openCamera() async {
    return ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 10);
  }

  Future<List<Asset>> openGallery() async {
    return MultiImagePicker.pickImages(
      maxImages: 1,
      selectedAssets: [],
      cupertinoOptions: const CupertinoOptions(takePhotoIcon: 'chat'),
      materialOptions: const MaterialOptions(
        actionBarColor: '#676FE5',
        actionBarTitle: 'Photos',
        allViewTitle: '',
        useDetailsView: false,
        selectCircleStrokeColor: '#000000',
      ),
    );
  }

  Future<PhotoEntity> createAndGetImage(String uid, {Asset? asset, XFile? file}) async {
    final List<PhotoEntity> imageUrls = await uploadImageUrls(DefaultConfig.expenseDoc,
        imageFiles: file != null ? [file] : null,
        imageAssets: asset != null ? [asset] : null,
        uid: uid);
    if (imageUrls.isNotEmpty) {
      return getPhotoUri(imageUrls[0]);
    }
    return PhotoEntity.normal();
  }

  List<String> getPathList(List<PhotoEntity>? photos) {
    final List<String> pathList = [];
    if (photos != null && photos.isNotEmpty) {
      for (final PhotoEntity photo in photos) {
        pathList.add(photo.path!);
      }
    }
    return pathList;
  }
}
