import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendy_re_work/common/configs/default_env.dart';
import 'package:spendy_re_work/common/firebase_setup.dart';
import 'package:spendy_re_work/data/datasources/remote/base_remote_storage_datasource.dart';
import 'package:spendy_re_work/data/model/user/user_model.dart';

class UserRemoteDataSource implements BaseRemoteStorageDataSource<UserModel> {
  final SetupFirebaseDatabase setupFirebase;

  UserRemoteDataSource({required this.setupFirebase});

  @override
  Future<bool> addModel(String uid, UserModel model) async {
    try {
      // uid: uid when authentication firebase
      // model.uid: phone number
      await setupFirebase.collectionRef!
          .doc(model.uid)
          .set(model.toJson())
          .whenComplete(() {});
    } catch (e) {
      throw FirebaseException(
          plugin: 'Spendy',
          message: 'UserRemote-addModel-error:${e.toString()}');
    }
    return false;
  }

  @override
  Future<UserModel?> getModel(String uid) async {
    try {
      final response = await setupFirebase.collectionRef!.doc(uid).get();
      if (response.data() != null) {
        final user =
            UserModel.fromJson(response.data() as Map<String, dynamic>, uid)
              ..uid = uid;
        return user;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  // @override
  // Future<bool> removeModel(String uid) async {
  //
  // }

  @override
  Future<bool> updateModel(String uid, UserModel user) async {
    try {
      await setupFirebase.collectionRef!
          .doc(uid)
          .update(user.toJson())
          .whenComplete(() {});
    } catch (e) {
      throw FirebaseException(
          plugin: 'Spendy',
          message: 'UserRemote-updateModel-error:${e.toString()}');
    }
    return false;
  }

  //@override
  Future getField(String id, String field) async {
    try {
      final snapshot = await setupFirebase.collectionRef!
          .doc(id)
          .collection(DefaultConfig.profileCollection)
          .doc(id)
          .get();
      snapshot.get(field);
    } catch (e) {
      throw FirebaseException(
          plugin: 'Spendy',
          message: 'UserRemote-getField-error:${e.toString()}');
    }
  }

  @override
  Future<bool> removeModel(String uid) {
    throw UnimplementedError();
  }
}
