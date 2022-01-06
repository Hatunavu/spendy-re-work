import 'package:spendy_re_work/domain/entities/for_me_entity.dart';

class ForMeModel extends ForMeEntity {
  ForMeModel(int? forWho, int? whoPaid, int? spendTime)
      : super(forWho: forWho, whoPaid: whoPaid, spendTime: spendTime);

  factory ForMeModel.fromJson(Map<String, dynamic> json) {
    return ForMeModel(json['for_who'], json['who_paid'], json['spend_time']);
  }

  Map<String, dynamic> toJson() {
    return {'for_who': forWho, 'who_paid': whoPaid, 'spend_time': spendTime};
  }
}
