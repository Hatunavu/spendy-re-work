import 'package:flutter_test/flutter_test.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/common/injector/injector_config.dart';
import 'package:spendy_re_work/domain/entities/participant_entity.dart';
import 'package:spendy_re_work/domain/usecases/new_expense_usecase.dart';

Map<String, ParticipantEntity> whoPaidMapMock1 = {
  'A': ParticipantEntity(name: 'A', amount: 100000, isEdit: true, isPaid: true),
  'B': ParticipantEntity(name: 'B', amount: 50000, isEdit: true, isPaid: true),
  'C': ParticipantEntity(name: 'C', amount: 200000, isEdit: true, isPaid: true),
  'D': ParticipantEntity(name: 'D', amount: 150000, isEdit: true, isPaid: true),
};
Map<String, ParticipantEntity> whoPaidMapMock2 = {
  'A':
      ParticipantEntity(name: 'A', amount: 100000, isEdit: false, isPaid: true),
  'B': ParticipantEntity(name: 'B', amount: 50000, isEdit: false, isPaid: true),
  'C':
      ParticipantEntity(name: 'C', amount: 200000, isEdit: false, isPaid: true),
  'D':
      ParticipantEntity(name: 'D', amount: 150000, isEdit: false, isPaid: true),
};
Map<String, ParticipantEntity> whoPaidMapMock3 = {
  'A': ParticipantEntity(
      name: 'A', amount: 100000, isEdit: false, isPaid: false),
  'B':
      ParticipantEntity(name: 'B', amount: 50000, isEdit: false, isPaid: false),
  'C': ParticipantEntity(
      name: 'C', amount: 200000, isEdit: false, isPaid: false),
  'D': ParticipantEntity(
      name: 'D', amount: 150000, isEdit: false, isPaid: false),
};
Map<String, ParticipantEntity> whoPaidMapMock4 = {
  'A': ParticipantEntity(name: 'A', amount: 100000, isEdit: true, isPaid: true),
  'B': ParticipantEntity(name: 'B', amount: 50000, isEdit: false, isPaid: true),
  'C': ParticipantEntity(
      name: 'C', amount: 200000, isEdit: false, isPaid: false),
  'D': ParticipantEntity(name: 'D', amount: 150000, isEdit: true, isPaid: true),
};
Map<String, ParticipantEntity> whoPaidMapMock5 = {
  'A': ParticipantEntity(name: 'A', amount: 100000, isEdit: true, isPaid: true),
  'B': ParticipantEntity(name: 'B', amount: 50000, isEdit: true, isPaid: true),
  'C':
      ParticipantEntity(name: 'C', amount: 200000, isEdit: false, isPaid: true),
  'D':
      ParticipantEntity(name: 'D', amount: 150000, isEdit: false, isPaid: true),
};
Map<String, ParticipantEntity> whoPaidMapMock6 = {
  'A': ParticipantEntity(name: 'A', amount: 100000, isEdit: true, isPaid: true),
  'B': ParticipantEntity(name: 'B', amount: 50000, isEdit: true, isPaid: true),
  'C': ParticipantEntity(
      name: 'C', amount: 200000, isEdit: false, isPaid: false),
  'D': ParticipantEntity(
      name: 'D', amount: 150000, isEdit: false, isPaid: false),
};
Map<String, ParticipantEntity> whoPaidMapMock7 = {
  'A':
      ParticipantEntity(name: 'A', amount: 100000, isEdit: false, isPaid: true),
  'B': ParticipantEntity(name: 'B', amount: 50000, isEdit: false, isPaid: true),
  'C': ParticipantEntity(
      name: 'C', amount: 200000, isEdit: false, isPaid: false),
  'D': ParticipantEntity(
      name: 'D', amount: 150000, isEdit: false, isPaid: false),
};

Map<String, ParticipantEntity> whoPaidMapMock8 = {
  'A': ParticipantEntity(name: 'A', amount: 100000, isEdit: true, isPaid: true),
  'B': ParticipantEntity(name: 'B', amount: 50000, isEdit: false, isPaid: true),
  'C': ParticipantEntity(
      name: 'C', amount: 200000, isEdit: false, isPaid: false),
  'D': ParticipantEntity(name: 'D', amount: 150000, isEdit: true, isPaid: true),
  'E':
      ParticipantEntity(name: 'E', amount: 150000, isEdit: false, isPaid: true),
};

void main() {
  group('Test Create New Expense', () {

    group('Update Amount Participant List', () {
      NewExpenseUseCase newExpenseUseCase;

      setUp(() {
        newExpenseUseCase = NewExpenseUseCase();
      });

      test('Update Amount Participant List - All isPaid == true'
          ', all isEdit == false', () async {
        final Map<String, ParticipantEntity> mockOwnerMap = {
          'A': ParticipantEntity(
              name: 'A', amount: 1, isEdit: false, isPaid: true),
          'B': ParticipantEntity(
              name: 'B', amount: 2, isEdit: false, isPaid: true),
          'C': ParticipantEntity(
              name: 'C', amount: 3, isEdit: false, isPaid: true),
          'D': ParticipantEntity(
              name: 'D', amount: 4, isEdit: false, isPaid: true),
        };

        final Map<String, ParticipantEntity> resultOwnerMap =
            await newExpenseUseCase.updateAmountParticipantsList(
          participantsMap: mockOwnerMap,
              spend: 20
        );

        expect(resultOwnerMap['A'].amount, 5);
        expect(resultOwnerMap['B'].amount, 5);
        expect(resultOwnerMap['C'].amount, 5);
        expect(resultOwnerMap['D'].amount, 5);
      });

      test('Update Amount Participant List - Some isPaid == false'
          ', all isEdit == false', () async {
        final Map<String, ParticipantEntity> mockOwnerMap = {
          'A': ParticipantEntity(
              name: 'A', amount: 1, isEdit: false, isPaid: false),
          'B': ParticipantEntity(
              name: 'B', amount: 2, isEdit: false, isPaid: false),
          'C': ParticipantEntity(
              name: 'C', amount: 3, isEdit: false, isPaid: true),
          'D': ParticipantEntity(
              name: 'D', amount: 4, isEdit: false, isPaid: true),
        };

        final Map<String, ParticipantEntity> resultOwnerMap =
        await newExpenseUseCase.updateAmountParticipantsList(
            participantsMap: mockOwnerMap,
            spend: 10
        );

        expect(resultOwnerMap['A'].amount, 1);
        expect(resultOwnerMap['B'].amount, 2);
        expect(resultOwnerMap['C'].amount, 5);
        expect(resultOwnerMap['D'].amount, 5);
      });

      test('Update Amount Participant List - All isPaid == true, some isEdit == true', () async {
        final Map<String, ParticipantEntity> mockOwnerMap = {
          'A': ParticipantEntity(
              name: 'A', amount: 1, isEdit: true, isPaid: true),
          'B': ParticipantEntity(
              name: 'B', amount: 2, isEdit: false, isPaid: true),
          'C': ParticipantEntity(
              name: 'C', amount: 3, isEdit: false, isPaid: true),
          'D': ParticipantEntity(
              name: 'D', amount: 4, isEdit: false, isPaid: true),
        };

        final Map<String, ParticipantEntity> resultOwnerMap =
        await newExpenseUseCase.updateAmountParticipantsList(
            participantsMap: mockOwnerMap,
            spend: 16
        );

        expect(resultOwnerMap['A'].amount, 1);
        expect(resultOwnerMap['B'].amount, 5);
        expect(resultOwnerMap['C'].amount, 5);
        expect(resultOwnerMap['D'].amount, 5);
      });

      test('Update Amount Participant List - All isPaid == true,'
          'some isEdit == true', () async {
        final Map<String, ParticipantEntity> mockOwnerMap = {
          'A': ParticipantEntity(
              name: 'A', amount: 1, isEdit: true, isPaid: true),
          'B': ParticipantEntity(
              name: 'B', amount: 2, isEdit: false, isPaid: true),
          'C': ParticipantEntity(
              name: 'C', amount: 3, isEdit: false, isPaid: true),
          'D': ParticipantEntity(
              name: 'D', amount: 4, isEdit: false, isPaid: true),
        };

        final Map<String, ParticipantEntity> resultOwnerMap =
        await newExpenseUseCase.updateAmountParticipantsList(
            participantsMap: mockOwnerMap,
            spend: 16
        );

        expect(resultOwnerMap['A'].amount, 1);
        expect(resultOwnerMap['B'].amount, 5);
        expect(resultOwnerMap['C'].amount, 5);
        expect(resultOwnerMap['D'].amount, 5);
      });

      test('Update Amount Participant List - some isPaid == false,'
          'some isEdit == true', () async {
        final Map<String, ParticipantEntity> mockOwnerMap = {
          'A': ParticipantEntity(
              name: 'A', amount: 1, isEdit: true, isPaid: true),
          'B': ParticipantEntity(
              name: 'B', amount: 2, isEdit: false, isPaid: false),
          'C': ParticipantEntity(
              name: 'C', amount: 3, isEdit: false, isPaid: true),
          'D': ParticipantEntity(
              name: 'D', amount: 4, isEdit: false, isPaid: true),
        };

        final Map<String, ParticipantEntity> resultOwnerMap =
        await newExpenseUseCase.updateAmountParticipantsList(
            participantsMap: mockOwnerMap,
            spend: 15
        );

        expect(resultOwnerMap['A'].amount, 1);
        expect(resultOwnerMap['B'].amount, 2);
        expect(resultOwnerMap['C'].amount, 7);
        expect(resultOwnerMap['D'].amount, 7);
      });
    });
  });
}
