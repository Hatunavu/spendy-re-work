import 'dart:typed_data';
import 'package:spendy_re_work/data/datasources/remote/storage_datasource.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';
import 'package:spendy_re_work/domain/repositories/storage_repository.dart';

class StorageRepositoryImpl extends StorageRepository {
  final StorageDataSource storageDataSource;

  StorageRepositoryImpl({required this.storageDataSource});

  @override
  Future<List<String>> uploadImage(
          {required List<Uint8List> imageUint8ListArray,
          required String uid,
          required String collection}) =>
      storageDataSource.uploadImages(
          imageUint8ListArray: imageUint8ListArray,
          uid: uid,
          collection: collection);

  @override
  Future<void> deleteImage({required String path}) =>
      storageDataSource.deleteImage(path);

  @override
  Future<PhotoEntity> getUrl({required String path}) =>
      storageDataSource.getImageUrl(path);
}
