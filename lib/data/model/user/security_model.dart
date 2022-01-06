import 'package:spendy_re_work/domain/entities/user/security_entity.dart';

class SecurityModel extends SecurityEntity {
  SecurityModel(bool? isBio, bool? isPin, String? pinCode)
      : super(isBio: isBio, isPin: isPin, pinCode: pinCode);

  factory SecurityModel.fromJson(Map<String, dynamic> json) {
    return SecurityModel(json['bio'], json['pin'], json['pin_code']);
  }

  Map<String, dynamic> toJson() {
    return {'bio': isBio, 'pin': isPin, 'pin_code': pinCode};
  }
}
