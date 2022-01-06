import 'package:flutter_test/flutter_test.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/usecases/expense_usecase.dart';

main() {
  final dynamic expenseDynamics = {
    "-MTqmlYQ75V03xRww-4_": {
      "for_who": ["RgPmCvlV31P5W42lJUVH"],
      "who_paid": ["AOx8ulULv7mZK70VxAup"],
      "last_update": 1613679499482,
      "category": "rj7j7bxR4wfxmsYtazmS",
      "create_at": 1613667600000,
      "user": "nn1taI6Q6HPeigacS2zjgI63h1V2",
      "transaction": "oo63heZkdiFLjxBjNIkX",
      "group": 0
    },
    "-MTqmHTgHTfrkygYgC6c": {
      "for_who": ["mXck4zQkqaUylwzjWn78"],
      "who_paid": ["3EjjXEvdqciu0kyBnmpl"],
      "last_update": 1613679372200,
      "category": "K1lDChE6MyPODLMnWUqi",
      "create_at": 1613667600000,
      "user": "nn1taI6Q6HPeigacS2zjgI63h1V2",
      "transaction": "tB0DkPnD7matMuOm2vob",
      "group": 0
    }
  };
  group('Expense Use Case', () {
    group('Get Expense Entities From dynamic value', () {
      test('Get Data', () async {
        ExpenseUseCase expenseUseCase = ExpenseUseCase(
            expenseRepository: null,
            categoriesUseCase: null,
            transactionUseCase: null);

        List<ExpenseEntity> expenseEntities =
            await expenseUseCase.getExpenseEntities(expenseDynamics);

        expect(expenseEntities.length, 2);
        // expect(expenseEntities[0].expenseId, '-MTqmlYQ75V03xRww-4_');
        // expect(expenseEntities[0].categoryNode, 'rj7j7bxR4wfxmsYtazmS');
        // expect(expenseEntities[0].forWhoNodes[0], 'RgPmCvlV31P5W42lJUVH');
        // expect(expenseEntities[0].lastUpdate, 1613679499482);
        // expect(expenseEntities[0].createAt, 1613667600000);
        // expect(expenseEntities[0].userNode, 'nn1taI6Q6HPeigacS2zjgI63h1V2');
        // expect(expenseEntities[0].transactionNode, 'oo63heZkdiFLjxBjNIkX');
        expect(expenseEntities[0].group, 0);
      });
    });
  });
}
