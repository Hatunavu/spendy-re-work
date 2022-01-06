import 'package:flutter_test/flutter_test.dart';
import 'package:spendy_re_work/data/model/__mock__/participant_model_mock.dart';
import 'package:spendy_re_work/data/model/participant_model.dart';
import 'package:spendy_re_work/domain/entities/participant_entity.dart';

void main() {
  group("Participant Model", () {
    test("fromJson Factory", () {
      final ParticipantEntity participantEntity =
          ParticipantModel.fromJson(participantModelMock, 'id');
      // expect(participantModel.name, 'hoang tuan');
      expect(participantEntity.amount, 100000);
      expect(participantEntity.isEdit, true);
      expect(participantEntity.isPaid, false);
      expect(participantEntity.createAt, 1923879143);
      expect(participantEntity.lastUpdate, 9873945345);
    });
  });
}
