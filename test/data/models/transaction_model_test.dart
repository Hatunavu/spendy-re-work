import 'package:flutter_test/flutter_test.dart';
import 'package:spendy_re_work/data/model/__mock__/transaction_model_mock.dart';
import 'package:spendy_re_work/data/model/transaction_model.dart';

void main() {
  group('Transaction model', () {
    test("fromJson factory", () {
      final TransactionModel transactionModel = TransactionModel.fromJson(transactionModelMock, '');

      expect(transactionModel.spend, 120000);
      expect(transactionModel.note, "Nothing to note");
      expect(transactionModel.currencyIsoCode, 1);
      expect(transactionModel.imagesUrls[0], "google.com");
      expect(transactionModel.createAt, 1923879143);
      expect(transactionModel.lastUpdate, 9873945345);
      expect(transactionModel.isPersonal, true);
    });
  });
}