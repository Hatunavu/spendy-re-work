import 'package:flutter_test/flutter_test.dart';
import 'package:spendy_re_work/domain/entities/participant_entity.dart';

void main() {
  group('Test Participant Entity', () {
    test('should update amount', () {
      ParticipantEntity participantEntity1 = ParticipantEntity(
          name: "A", amount: 1000000, isPaid: true, isEdit: false);
      participantEntity1.updateAmount(200000);
      expect(participantEntity1.amount, 200000);
      expect(participantEntity1.isEdit, false);
      expect(participantEntity1.isPaid, true);

      ParticipantEntity participantEntity2 = ParticipantEntity(
          name: "A", amount: 1000000, isPaid: true, isEdit: true);
      participantEntity1.updateAmount(200000);
      expect(participantEntity2.amount, 1000000);
      expect(participantEntity2.isEdit, true);
      expect(participantEntity2.isPaid, true);
    });

    // test(description, body)
  });

  test('should edit amount', () {
    ParticipantEntity participantEntity1 = ParticipantEntity(
        name: "A", amount: 1000000, isPaid: true, isEdit: false);
    participantEntity1.editAmount(200000);
    expect(participantEntity1.amount, 200000);
    expect(participantEntity1.isEdit, true);
    expect(participantEntity1.isPaid, true);

    ParticipantEntity participantEntity2 = ParticipantEntity(
        name: "A", amount: 1000000, isPaid: true, isEdit: true);
    participantEntity2.editAmount(0);
    expect(participantEntity2.amount, 0);
    expect(participantEntity2.isEdit, false);
    expect(participantEntity2.isPaid, false);
  });

  test('Should update isPaid', () {
    ParticipantEntity participantEntity1 = ParticipantEntity(
        name: "A", amount: 1000000, isPaid: true, isEdit: false);
    participantEntity1.updateIsPaid(false);
    expect(participantEntity1.isPaid, false);
    expect(participantEntity1.isEdit, false);

    participantEntity1.updateIsPaid(true);
    expect(participantEntity1.isPaid, true);
    expect(participantEntity1.isEdit, false);
  });
}
