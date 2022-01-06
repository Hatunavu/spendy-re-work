import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';

class CurrencyEntity extends Equatable {
  final int? id;
  final String? name;
  final String? code;
  final String? locale;
  final String? isoCode;

//  'vi', 'en-us',
  final String? flag;

  CurrencyEntity({
    this.id,
    this.name,
    this.code,
    this.locale,
    this.flag,
    this.isoCode,
  });

  CurrencyEntity.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        code = map['code'],
        locale = map['locale'],
        flag = map['flag'],
        isoCode = map['isoCode'];

  @override
  String toString() {
    return 'CurrencyEntity{id: $id, name: $name, code: $code, locale: $locale, isoCode: $isoCode, flag: $flag}';
  }
  // CurrencyEntity.fromJson(Map<String, dynamic> json) {
  //   late id: json['id'];
  //   late name = json['name'];
  //   late code = json['code'];
  //   late locale = json['locale'];
  //   late isoCode = json['isoCode'];
  //   late flag = json['flag'];
  // }

  @override
  List<Object?> get props => [id, name, code, locale, isoCode, flag];
}
