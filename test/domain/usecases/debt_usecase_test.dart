import 'package:flutter_test/flutter_test.dart';
import 'package:spendy_re_work/common/utils/algorithm/settle_debt_algorithm/model/settle_debt_model.dart';
import 'package:spendy_re_work/domain/usecases/debt_usecase.dart';

main() {
  group('Debt UseCase', () {
    DebtUseCase debtUseCase;
    List<SettleDebtModel> mockSettleDebtList;

    setUp(() {
      debtUseCase = DebtUseCase();
      mockSettleDebtList = [
        SettleDebtModel(payerName: 'A', payeeName: 'B', debtAmount: 10),
        SettleDebtModel(payerName: 'C', payeeName: 'A', debtAmount: 8),
        SettleDebtModel(payerName: 'B', payeeName: 'C', debtAmount: 9),
      ];
    });

    group('Clean Transaction Debt Map', () {
      test('Clean Normal TransactionDebtsMap', () {
        final Map<String, double> cleanResult =
            debtUseCase.cleanTransactionDebtsMap({
          'A': 1,
          'B': 2,
          'C': 3,
        });

        expect(cleanResult.length, 3);
        expect(cleanResult['A'], 1);
        expect(cleanResult['B'], 2);
        expect(cleanResult['C'], 3);
      });

      test('[SPE-237] Clean TransactionDebtsMap with 1 value equal to 0', () {
        final Map<String, double> cleanResult =
            debtUseCase.cleanTransactionDebtsMap({
          'A': 0,
          'B': 2,
          'C': 3,
        });

        expect(cleanResult.length, 2);
        expect(cleanResult['B'], 2);
        expect(cleanResult['C'], 3);
      });
    });

    group('User must on top of the Debt List', () {
      final String userName = 'Dev';
      final Map<String, double> mockDebMap = {
        'A': 1,
        'B': 2,
        userName: 5,
        'C': 3,
      };

      test('User on top of the Debt List', () async {
        final Map<String, double> resultDebtMap = await debtUseCase
            .userOnTopDebtMap(debtMap: mockDebMap, userFullName: userName);
        print('resultDebtMap: $resultDebtMap');
        expect(resultDebtMap.keys.first, userName);
        expect(resultDebtMap.values.first, 5);
      });
    });
  });
}
