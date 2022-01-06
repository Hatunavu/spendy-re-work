import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';

class NewExpenseUtil {
  static List<ParticipantInTransactionEntity> getAmountOfParticipant(
      Map<String, dynamic> message) {
    final groupParticipants = message[NewExpenseConstants.groupParticipantsKey];
    final expenseParticipants =
        message[NewExpenseConstants.expenseParticipantsKey];
    final groupParticipantLength = groupParticipants.length;
    final expenseParticipantLength = expenseParticipants.length;
    for (var indexGP = 0; indexGP < groupParticipantLength; indexGP++) {
      for (var indexEP = 0; indexEP < expenseParticipantLength; indexEP++) {
        final groupParticipant = groupParticipants[indexGP];
        final expenseParticipant = expenseParticipants[indexEP];
        if (groupParticipant.id == expenseParticipant.id) {
          groupParticipant
            ..amount = expenseParticipant.amount
            ..isSelected = true;
        }
        groupParticipants[indexGP] = groupParticipant;
      }
    }
    return groupParticipants;
  }
}
