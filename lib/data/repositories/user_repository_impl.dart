import 'package:spendy_re_work/data/datasources/remote/user_remote_datasource.dart';
import 'package:spendy_re_work/data/model/user/user_model.dart';
import 'package:spendy_re_work/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource userRemoteDataSource;

  UserRepositoryImpl({required this.userRemoteDataSource});

  @override
  Future<void> addUserToFirebase(String uid, UserModel userModel) =>
      userRemoteDataSource.addModel(uid, userModel);

  @override
  Future<UserModel?> getUser(String uid) => userRemoteDataSource.getModel(uid);

  @override
  Future<void> removeUser(String uid) => userRemoteDataSource.removeModel(uid);

  @override
  Future<void> updateUser(String uid, UserModel userModel) =>
      userRemoteDataSource.updateModel(uid, userModel);
}
