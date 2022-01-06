import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:spendy_re_work/common/configs/default_env.dart';
import 'package:spendy_re_work/data/model/photo_model.dart';

class StorageDataSource {
  /// ===== UPLOAD IMAGES =====
  Future<List<String>> uploadImages(
      {List<Uint8List>? imageUint8ListArray,
      String? uid,
      String? collection}) async {
    final pathList = <String>[];
    try {
      for (final Uint8List item in imageUint8ListArray!) {
        final int timer = DateTime.now().millisecondsSinceEpoch;
        final String path =
            'images/${DefaultConfig.storagePath}/$collection/$timer';
        final firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref(path);
        await ref.putData(item).whenComplete(() {
          pathList.add(path);
        });
      }
    } on Exception catch (e) {
      throw FirebaseException(
          plugin: 'Spendy',
          message:
              'TransactionRemoteDataSource - uploadImageAssets - error: ${e.toString()}');
    }
    return pathList;
  }

  Future<PhotoModel> getImageUrl(String path) async {
    final firebase_storage.Reference ref =
        FirebaseStorage.instance.ref().child(path);
    String uri = '';
    try {
      uri = await ref.getDownloadURL();
      return PhotoModel(path: path, uri: uri);
    } on Exception catch (e) {
      log('err: ${e.toString()}');
    }
    return PhotoModel(path: path, uri: uri);
  }

  Future<void> deleteImage(String path) async {
    final firebase_storage.Reference ref =
        FirebaseStorage.instance.ref().child(path);
    await ref.delete();
  }
}
