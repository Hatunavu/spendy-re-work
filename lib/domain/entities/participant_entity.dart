import 'package:spendy_re_work/data/model/participant_model.dart';

class ParticipantEntity {
  String? id;
  final String name;
  ParticipantEntity({this.id, required this.name});

  ParticipantModel toModel() {
    return ParticipantModel(
      id: id,
      name: name,
    );
  }
}