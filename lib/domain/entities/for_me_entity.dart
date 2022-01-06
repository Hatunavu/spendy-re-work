import 'package:spendy_re_work/data/model/for_me_model.dart';

class ForMeEntity {
  final int? forWho;
  final int? whoPaid;
  final int? spendTime;

  ForMeEntity({this.forWho, this.whoPaid, this.spendTime});

  ForMeModel toModel() => ForMeModel(forWho, whoPaid, spendTime);

  ForMeEntity copyWith({
    int? forWho,
    int? whoPaid,
    int? spendTime,
  }) {
    return ForMeEntity(
      forWho: forWho ?? this.forWho,
      whoPaid: whoPaid ?? this.whoPaid,
      spendTime: spendTime ?? this.spendTime,
    );
  }
}
