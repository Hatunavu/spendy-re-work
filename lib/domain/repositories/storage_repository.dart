import 'dart:typed_data';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';

abstract class StorageRepository {
  Future<List<String>> uploadImage(
      {required List<Uint8List> imageUint8ListArray,
      required String uid,
      required String collection});

  Future<void> deleteImage({required String path});

  Future<PhotoEntity> getUrl({required String path});
}
