import 'package:flutter_test/flutter_test.dart';
import 'package:spendy_re_work/domain/repositories/__mocks__/category_repository_mock.dart';
import 'package:spendy_re_work/domain/repositories/__mocks__/expense_repository_mock.dart';
import 'package:spendy_re_work/domain/repositories/__mocks__/participant_repository_mock.dart';
import 'package:spendy_re_work/domain/usecases/report_usecase.dart';

void main(){
  MockExpenseRepository mockExpenseRepository;
  MockCategoryRepository mockCategoryRepository;
  MockParticipantRepository mockParticipantRepository;

  ReportUseCase reportUseCase;

  final mockMapExpense = [

  ];

  setUp((){
    mockExpenseRepository = MockExpenseRepository();
    mockCategoryRepository = MockCategoryRepository();
    mockParticipantRepository = MockParticipantRepository();

    reportUseCase = ReportUseCase(
      expenseRepository: mockExpenseRepository,
      participantRepository: mockParticipantRepository
    );
  });

  group('Report UseCase Test', (){

  });
}