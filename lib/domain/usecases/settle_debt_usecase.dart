import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';
import 'package:spendy_re_work/common/utils/algorithm/settle_debt_algorithm/settle_debt.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/expense_participants_entity.dart';
import 'package:spendy_re_work/domain/entities/transaction_entity.dart';
import 'package:spendy_re_work/domain/repositories/category_repository.dart';
import 'package:spendy_re_work/domain/repositories/expense_repository.dart';
import 'package:spendy_re_work/domain/repositories/participant_repository.dart';
import 'package:spendy_re_work/domain/repositories/transaction_repository.dart';

class SettleDebtUseCase {
  final ExpenseRepository expenseRepository;
  final ParticipantRepository participantRepository;
  final CategoryRepository categoryRepository;
  final TransactionRepository transactionRepository;

  SettleDebtUseCase(
      {required this.expenseRepository,
      required this.transactionRepository,
      required this.participantRepository,
      required this.categoryRepository});

  /// settle all debt of user
  Future<SettleDebt> settleAllDebt(
    String uid,
    String nameUser,
  ) async {
    final List<ExpenseEntity> listExpense = [];

    // final query =
    //     await expenseRepository.getExpListByUid(uid: uid, limit: false);
    // query.docs.forEach((element) {
    //   listExpense.add(ExpenseModel.fromJson(element.data(), element.id));
    // });

    return mapToSettleDebt(nameUser, listExpense);
  }

  /// get map settle debt more days recent date time
  Future<Map<int, SettleDebt>> mapSettleDebtInYear(
    String nameUser,
    List<ExpenseEntity> listExpense,
  ) async {
    final Map<int, SettleDebt> mapListExpenseMonths = {};

    for (int i = 1; i <= 12; i++) {
      final partExpenseListInADay = listExpense.where((element) {
        final spendTime =
            DateTime.fromMicrosecondsSinceEpoch(element.updateAt * 1000);
        return spendTime.month == i;
      }).toList();
      final settleResult =
          await settleDebtByListExpense(nameUser, partExpenseListInADay);

      mapListExpenseMonths[i] = settleResult;
    }

    return mapListExpenseMonths;
  }

  /// get map settle debt one week contains date time
  Future<Map<int, SettleDebt>> mapSettleDebtOneWeekRecentTime(
    String nameUser,
    DateTime dateTime,
    List<ExpenseEntity> listExpense,
  ) async {
    final Map<int, SettleDebt> mapListExpenseWeek = {};

    for (int i = dateTime.startOfWeek().day;
        i <= dateTime.endOfWeek().day;
        i++) {
      final partExpenseListInADay = listExpense.where((element) {
        final spendTime =
            DateTime.fromMicrosecondsSinceEpoch(element.updateAt * 1000);
        return dateTime.weekOfYear == spendTime.weekOfYear &&
            i == spendTime.day;
      }).toList();

      final settleResult =
          await settleDebtByListExpense(nameUser, partExpenseListInADay);

      mapListExpenseWeek[i] = settleResult;
    }

    return mapListExpenseWeek;
  }

  /// get map settle debt more days recent date time
  Future<Map<int, SettleDebt>> mapSettleDebtMoreDaysRecentTime(
    String nameUser,
    int rangeDay,
    DateTime dateTime,
    List<ExpenseEntity> listExpense,
  ) async {
    final Map<int, SettleDebt> mapSettleDebt = {};
    DateTime tempDateTime = dateTime;

    for (int i = rangeDay - 1; i >= 0; i--) {
      tempDateTime = dateTime.subDay(value: i);
      final partExpenseListInADay = listExpense.where((element) {
        final spendTime =
            DateTime.fromMicrosecondsSinceEpoch(element.updateAt * 1000);
        return tempDateTime.day == spendTime.day;
      }).toList();

      final settleResult =
          await settleDebtByListExpense(nameUser, partExpenseListInADay);

      mapSettleDebt[tempDateTime.day] = settleResult;
    }

    return mapSettleDebt;
  }

  /// settle debt between start time and end time
//   Future<SettleDebt> settleDebtBetweenTime(
//       String uid, String nameUser, int startTime, int endTime,
//       {bool endIsLessThanEqual = true}) async {
// //    print(startTime.toString());
// //    print(endTime.toString());
//
//     // final filter = DateFilterEntity(
//     //     earlyMonthMillisecond: startTime, endMonthMillisecond: endTime);
//
//     // final listExpense = await expenseRepository.getExpenseListBetweenDateTime(
//     //     monthFilter: filter.toModel(),
//     //     uid: uid,
//     //     endIsLessThanEqual: endIsLessThanEqual);
//
//     // return await mapToSettleDebt(nameUser, listExpense);
//   }

  /// settle debt when input is list expense
  Future<SettleDebt> settleDebtByListExpense(
          String nameUser, List<ExpenseEntity> listExpense) =>
      mapToSettleDebt(nameUser, listExpense);

  /// call settle debt
  /// [listExpense] is list of expenses for debt calculation
  Future<SettleDebt> mapToSettleDebt(
      String nameUser, List<ExpenseEntity> listExpense) async {
    final List<TransactionEntity> transactionList = [];
    final List<ExpenseParticipantsEntity> expenseParticipantList = [];
    // List<ParticipantModel> whoPaidList = [];
    // List<ParticipantModel> forWhoList = [];

    // if (listExpense != null && listExpense.isNotEmpty) {
    //   for (int i = 0; i < listExpense.length; i++) {
    //     // get transaction of expense
    //     final transaction = await transactionRepository
    //         .getTransactionById(listExpense[i].transactionNode);
    //     transactionList.add(transaction);
    //
    //     // get who paid and for who list
    //     whoPaidList = [];
    //     forWhoList = [];
    //     for (final participantID in listExpense[i].whoPaidNodes) {
    //       final whoPaid =
    //           await participantRepository.getParticipantById(participantID);
    //       if (whoPaid != null && whoPaid.isPaid ?? true) {
    //         whoPaidList.add(whoPaid);
    //       }
    //     }
    //     for (final participantID in listExpense[i].forWhoNodes) {
    //       final forWho =
    //           await participantRepository.getParticipantById(participantID);
    //       if (forWho != null && forWho.isPaid ?? true) {
    //         forWhoList.add(forWho);
    //       }
    //     }
    //     expenseParticipantList.add(ExpenseParticipantsEntity(
    //         whoPaids: whoPaidList, forWhos: forWhoList));
    //   }
    // }
    final settle = SettleDebt(
        listExpense: listExpense,
        listExpenseParticipant: expenseParticipantList,
        listTransaction: transactionList,
        nameUser: nameUser);
    await settle.settleDebt();
    return settle;
  }

  /// Get All list of expense
}
