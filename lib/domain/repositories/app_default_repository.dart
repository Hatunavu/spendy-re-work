import 'package:spendy_re_work/domain/entities/app_default_entity/payment_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';

abstract class AppDefaultRepository {
  List<PaymentEntity> getDataRemoteConfig();
  List<GroupEntity> getGroupRemoteConfig();
}
