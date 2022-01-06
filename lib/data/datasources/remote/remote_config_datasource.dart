import 'dart:convert';
import 'dart:developer';

import 'package:spendy_re_work/common/configs/remote_config_default.dart';
import 'package:spendy_re_work/data/model/app_default_model/payment_model.dart';
import 'package:spendy_re_work/data/model/user/group_model.dart';
import 'package:spendy_re_work/domain/entities/app_default_entity/payment_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';

class RemoteConfigDataSource {
  final RemoteConfigDefault remoteConfigDefault;

  RemoteConfigDataSource({required this.remoteConfigDefault});

  List<PaymentEntity> getPaymentsRemoteConfig() {
    final payments = (jsonDecode(remoteConfigDefault.payments) as List)
        .map((e) => PaymentModel.fromJson(e))
        .toList();
    return payments;
  }

  List<GroupEntity> getGroupsRemoteConfig() {
    final groups = (jsonDecode(remoteConfigDefault.defaultGroups) as List)
        .map((e) => GroupModel.fromJson(e, ''))
        .toList();
    log('$groups');
    return groups;
  }
}
