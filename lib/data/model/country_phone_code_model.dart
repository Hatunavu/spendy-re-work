import 'package:spendy_re_work/domain/entities/country_phone_code_entity.dart';

class CountryPhoneCodeModel extends CountryPhoneCodeEntity {
  CountryPhoneCodeModel(
      {String? name, String? flag, String? code, String? dialCode})
      : super(name: name!, flag: flag!, code: code!, dialCode: dialCode!);

  factory CountryPhoneCodeModel.fromJson(Map<String, dynamic> json) =>
      CountryPhoneCodeModel(
          name: json['name'],
          flag: json['flag'],
          code: json['code'],
          dialCode: json['dial_code']);
}
