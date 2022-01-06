import 'package:spendy_re_work/data/model/user/user_model.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';

abstract class UserRepository {
  Future<void> addUserToFirebase(String uid, UserModel userModel);

  Future<void> removeUser(String uid);

  Future<void> updateUser(String uid, UserModel userModel);

  Future<UserEntity?> getUser(String uid);
}
