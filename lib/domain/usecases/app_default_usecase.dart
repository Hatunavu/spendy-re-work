import 'package:spendy_re_work/domain/entities/app_default_entity/payment_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/domain/repositories/app_default_repository.dart';

class AppDefaultUsecase {
  final AppDefaultRepository appDefaultRepository;

  AppDefaultUsecase({required this.appDefaultRepository});
  List<PaymentEntity> getDataRemoteConfig() {
    return appDefaultRepository.getDataRemoteConfig();
  }

  List<GroupEntity> getGroupRemoteConfig() {
    return appDefaultRepository.getGroupRemoteConfig();
  }
}
