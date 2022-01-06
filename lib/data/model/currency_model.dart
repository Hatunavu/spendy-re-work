import 'package:spendy_re_work/domain/entities/currency_entity.dart';

class CurrencyModel extends CurrencyEntity {
  CurrencyModel({
    int? id,
    String? name,
    String? code,
    String? locale,
    String? isoCode,

//  'vi', 'en-us',
    String? flag,
  }) : super(
            id: id,
            name: name,
            code: code,
            locale: locale,
            flag: flag,
            isoCode: isoCode);

  // CurrencyModel.fromMap(Map<String, dynamic> map)
  //     => CurrencyModel(
  //         id : map['id'],
  //         name : map['name'],
  //         code : map['code'],
  //         locale : map['locale'],
  //         flag :: map['flag'],
  //         isoCode : map['isoCode'];
  //     );

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        locale: json['locale'],
        flag: json['flag'],
        isoCode: json['isoCode']);
  }
}
