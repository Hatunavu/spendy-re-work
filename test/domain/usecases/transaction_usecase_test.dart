import 'package:flutter_test/flutter_test.dart';
import 'package:spendy_re_work/domain/entities/transaction_entity.dart';
import 'package:spendy_re_work/domain/usecases/transaction_usecase.dart';

main() {
  group('Transaction Use Case', () {
    TransactionUseCase transactionUseCase;

    setUp(() {
      transactionUseCase = TransactionUseCase();
    });

    group('Refresh Transaction', () {
      test('Create Transaction', () {
        final TransactionEntity transactionEntity = transactionUseCase
            .refreshTransaction(
          spendTime: 123,
          note: 'test',
          imageUrlList: [],
          currencyIsoCode: 'VND',
          lastUpdate: 123,
          createAt: 123,
          spend: '1000',
          isPersonal: true
        );

        expect(transactionEntity.transactionId.isEmpty, true);
        expect(transactionEntity.spendTime, 123);
        expect(transactionEntity.note, 'test');
        expect(transactionEntity.imagesUrls.isEmpty, true);
        expect(transactionEntity.currencyIsoCode, 'VND');
        expect(transactionEntity.lastUpdate, 123);
        expect(transactionEntity.createAt, 123);
        expect(transactionEntity.spend, 1000);
        expect(transactionEntity.isPersonal, true);
      });

      test('Edit Transaction', () {
        final TransactionEntity mockTransaction = TransactionEntity(
          transactionId: '111',
            spendTime: 123,
            note: 'test',
            imagesUrls: [],
            currencyIsoCode: 'VND',
            lastUpdate: 123,
            createAt: 123,
            spend: 1000,
            isPersonal: true
        );

        final TransactionEntity resultTransaction = transactionUseCase
            .refreshTransaction(
          transactionId: mockTransaction.transactionId,
            spendTime: 12345,
            note: 'test edit',
            imageUrlList: ['1', '2'],
            currencyIsoCode: mockTransaction.currencyIsoCode,
            lastUpdate: 1234,
            createAt: mockTransaction.createAt,
            spend: '12000',
            isPersonal: false
        );

        expect(resultTransaction.transactionId, '111');
        expect(resultTransaction.spendTime, 12345);
        expect(resultTransaction.note, 'test edit');
        expect(resultTransaction.imagesUrls.length, 2);
        expect(resultTransaction.currencyIsoCode, 'VND');
        expect(resultTransaction.lastUpdate, 1234);
        expect(resultTransaction.createAt, 123);
        expect(resultTransaction.spend, 12000);
        expect(resultTransaction.isPersonal, false);
      });
    });

  });
}