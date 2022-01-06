import 'package:spendy_re_work/data/datasources/remote/remote_config_datasource.dart';
import 'package:spendy_re_work/domain/entities/app_default_entity/payment_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/domain/repositories/app_default_repository.dart';

class AppDefaultRepositoryImpl implements AppDefaultRepository {
  final RemoteConfigDataSource remoteConfigDataSource;

  AppDefaultRepositoryImpl({required this.remoteConfigDataSource});

  @override
  List<PaymentEntity> getDataRemoteConfig() {
    return remoteConfigDataSource.getPaymentsRemoteConfig();
  }

  @override
  List<GroupEntity> getGroupRemoteConfig() {
    return remoteConfigDataSource.getGroupsRemoteConfig();
  }
}
