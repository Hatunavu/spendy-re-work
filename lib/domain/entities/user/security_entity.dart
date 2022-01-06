import 'package:spendy_re_work/data/model/user/security_model.dart';

class SecurityEntity {
  bool? isPin;
  bool? isBio;
  String? pinCode;

  SecurityEntity({this.isPin, this.isBio, this.pinCode});

  factory SecurityEntity.defaultSecurity() =>
      SecurityEntity(isBio: false, isPin: false, pinCode: '');

  SecurityModel toModel() => SecurityModel(isBio, isPin, pinCode);

  @override
  String toString() {
    return 'SecurityEntity{isPin: $isPin, isBio: $isBio, pinCode: $pinCode}';
  }
}
