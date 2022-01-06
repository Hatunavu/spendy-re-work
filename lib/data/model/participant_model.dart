import 'package:spendy_re_work/domain/entities/participant_entity.dart';

class ParticipantModel extends ParticipantEntity {
  ParticipantModel({String? id, required String name})
      : super(id: id, name: name);

  factory ParticipantModel.fromJson(Map<String, dynamic> json, String id) {
    return ParticipantModel(id: id, name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
