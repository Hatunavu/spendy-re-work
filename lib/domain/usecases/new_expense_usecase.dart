// import 'package:flutter/material.dart';
// import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
// import 'package:spendy_re_work/domain/repositories/expense_repository.dart';
// import 'package:spendy_re_work/domain/repositories/participant_repository.dart';

// /// @Singleton
// class NewExpenseUseCase {
//   final ExpenseRepository expenseRepository;
//   final ParticipantRepository participantRepository;

//   Set<String> _setUserNameRecently = {};

//   List<String> get listUserNameRecently => _setUserNameRecently.toList();

//   bool get listNameRecentlyEmpty => listUserNameRecently.length == 1;

//   NewExpenseUseCase(
//       {required this.expenseRepository, required this.participantRepository});

//   // {'name' : 'entity'}
//   Future<Map<String, ParticipantInTransactionEntity>> createParticipant({
//     String? uid,
//     bool? isForWhom,
//     Map<String, ParticipantInTransactionEntity>? participantsMap,
//     String? participantName,
//     int? spend,
//   }) async {
//     final ParticipantInTransactionEntity newParticipant =
//         ParticipantInTransactionEntity(
//             uid: uid,
//             isForWho: isForWhom ?? true,
//             name: participantName ?? '',
//             amount: 0,
//             isEdit: false,
//             isPaid: true,
//             createAt: DateTime.now().millisecondsSinceEpoch,
//             lastUpdate: DateTime.now().millisecondsSinceEpoch);
//     participantsMap!['$participantName'] = newParticipant;

//     participantsMap = await updateAmountParticipantsList(
//         participantsMap: participantsMap, spend: spend!);

//     _setUserNameRecently.add(participantName!);
//     return participantsMap;
//   }

//   Future<Map<String, ParticipantInTransactionEntity>>
//       updateAmountParticipantsList(
//           {Map<String, ParticipantInTransactionEntity>? participantsMap,
//           int? spend}) async {
//     final List<ParticipantInTransactionEntity> participants =
//         participantsMap!.values.toList();

//     int participantEditTotal = 0;
//     int participantUnpaidTotal = 0;
//     int spendRemain = spend!;
//     for (int index = 0; index < participants.length; index++) {
//       final ParticipantInTransactionEntity participant = participants[index];
//       if (participant.isPaid ?? false) {
//         if (participant.isEdit ?? false) {
//           participantEditTotal++;
//           spendRemain -= participant.amount!;
//         }
//       } else {
//         participantUnpaidTotal++;
//       }
//     }

//     int participantPaidRemainTotal;
//     if (participants.length == participantEditTotal ||
//         participants.length == participantUnpaidTotal ||
//         participants.length == participantEditTotal + participantUnpaidTotal) {
//       participantPaidRemainTotal = 1;
//     } else {
//       participantPaidRemainTotal =
//           participants.length - participantUnpaidTotal - participantEditTotal;
//     }

//     final int participantAmount =
//         (spendRemain / participantPaidRemainTotal).ceil();
//     final List<String> participantKeys = participantsMap.keys.toList();
//     for (int index = 0; index < participantKeys.length; index++) {
//       final key = participantKeys[index];
//       final ParticipantInTransactionEntity participant = participantsMap[key]!
//         ..updateAmount(participantAmount);
//       participantsMap[key] = participant;
//     }

//     return participantsMap;
//   }

//   Future<Map<String, ParticipantInTransactionEntity>> editParticipantAmount(
//       {Map<String, ParticipantInTransactionEntity>? participantsMap,
//       int? spend,
//       String? participantName,
//       String? participantAmount}) async {
//     int amount = int.parse(participantAmount!);
//     if (amount != participantsMap![participantName]!.amount) {
//       if (amount == 0) {
//         participantsMap[participantName]!.updateIsPaid(false);
//       } else {
//         final int spendRemain = await _getSpendRemainWithName(
//             participantsMap: participantsMap,
//             spend: spend!,
//             name: participantName!);
//         if (amount > spendRemain && spendRemain != 0) {
//           amount = spendRemain;
//         }
//         participantsMap[participantName]!.editAmount(amount);
//       }
//       participantsMap = await updateAmountParticipantsList(
//           participantsMap: participantsMap, spend: spend);
//     }

//     return participantsMap;
//   }

//   Future<int> _getSpendRemainWithName(
//       {Map<String, ParticipantInTransactionEntity>? participantsMap,
//       String? name,
//       int? spend}) async {
//     final List<ParticipantInTransactionEntity> participants =
//         participantsMap!.values.toList();
//     int spendRemain = spend!;
//     for (int index = 0; index < participants.length; index++) {
//       final ParticipantInTransactionEntity participant = participants[index];
//       if (participant.name != name && participant.isEdit!) {
//         spendRemain -= participant.amount!;
//       }
//     }
//     // debugPrint('ExpenseUseCase - getSpendRemain: $spendRemain');
//     return spendRemain;
//   }

//   Future<Map<String, ParticipantInTransactionEntity>> checkPaid(
//       {Map<String, ParticipantInTransactionEntity>? participantsMap,
//       int? spend,
//       String? participantName}) async {
//     final bool isPaid = participantsMap![participantName]!.isPaid ?? false;
//     participantsMap[participantName]!.updateIsPaid(!isPaid);
//     return updateAmountParticipantsList(
//         participantsMap: participantsMap, spend: spend);
//   }

//   Future<Map<String, ParticipantInTransactionEntity>> checkAllPaid(
//       {Map<String, ParticipantInTransactionEntity>? participantsMap,
//       int? spend,
//       bool? isSelectAll}) async {
//     participantsMap!.forEach((key, participant) {
//       participant.updateIsPaid(isSelectAll!);
//     });
//     if (isSelectAll!) {
//       participantsMap = await updateAmountParticipantsList(
//           participantsMap: participantsMap, spend: spend);
//     }
//     return participantsMap;
//   }

//   Future<bool> isSelectedAllParticipants({
//     Map<String, ParticipantInTransactionEntity>? participantsMap,
//   }) async {
//     final List<ParticipantInTransactionEntity> participants =
//         participantsMap!.values.toList();
//     for (int index = 0; index < participants.length; index++) {
//       if (participants[index].isPaid ?? false) {
//         return true;
//       }
//     }
//     return false;
//   }

//   Future<bool> isActiveButton(
//       {Map<String, ParticipantInTransactionEntity>? participantsMap,
//       int? spend}) async {
//     final bool isSelectAll =
//         await isSelectedAllParticipants(participantsMap: participantsMap);
//     final int spendDivideTotal =
//         await _spendDivideTotal(participants: participantsMap!.values.toList());
//     int absoluteError = 0;
//     participantsMap.forEach((name, participant) {
//       if (participant.isPaid ?? false) {
//         absoluteError++;
//       }
//     });
//     if (isSelectAll == false) {
//       return false;
//     }
//     if (participantsMap.length == 0) {
//       return false;
//     }
//     if (spend! - spendDivideTotal >= absoluteError) {
//       return false;
//     }
//     return true;
//   }

//   Future<int> _spendDivideTotal(
//       {List<ParticipantInTransactionEntity>? participants}) async {
//     int spendDivideTotal = 0;
//     for (final participant
//         in participants ?? <ParticipantInTransactionEntity>[]) {
//       if (participant.isPaid ?? false) {
//         spendDivideTotal += participant.amount!;
//       }
//     }
//     return spendDivideTotal;
//   }

//   bool isActiveButtonMock(
//       {required int spend,
//       required int spendRemain,
//       required int participantsLength,
//       required bool isSelectAll}) {
//     final int absoluteError = participantsLength;

//     if (participantsLength == 0) {
//       return false;
//     }
//     if (spend - spendRemain >= absoluteError) {
//       return false;
//     }
//     return true;
//   }

//   Future<Map<String, FocusNode>> setNodeFocusMap(
//       List<String> participantNameList) async {
//     final Map<String, FocusNode> focusNodeMap = {};
//     for (final String name in participantNameList) {
//       focusNodeMap[name] = FocusNode();
//     }
//     return focusNodeMap;
//   }

//   /// ==== WHO PAID, FOR WHO

//   /// Get all recently user name by uid
//   Future<Set<String>> getAllRecentlyUserParticipant(String uid) async {
//     // fetch query snapshot of user's expenses
//     // final querySnapshot =
//     //     await expenseRepository.getExpListByUid(uid: uid, limit: false);
//     // List<ExpenseEntity> expenseEntities = [];
//     //
//     // if (querySnapshot != null) {
//     //   final List<QueryDocumentSnapshot> docs =
//     //       await _getQueryDocumentSnapshotList([querySnapshot]);
//     //
//     //   // parse query doc to expense model
//     //   // -> add to `expenseEntities` list
//     //   for (final doc in docs) {
//     //     final ExpenseModel expenseModel =
//     //         ExpenseModel.fromJson(doc.data(), doc.id);
//     //     expenseEntities.add(expenseModel);
//     //   }
//     // }

//     // for (int i = 0; i < expenseEntities.length; i++) {
//     //   // fetch user name of `forWho` participant
//     //   // -> add result to `userNameRecently` set
//     //   final listForWho = expenseEntities[i].debts;
//     //
//     //   for (int j = 0; j < listForWho.length; j++) {
//     //     final ParticipantEntity participantEntity =
//     //         await participantRepository.getParticipantById(listForWho[j]);
//     //     if (participantEntity != null) {
//     //       _setUserNameRecently.add(participantEntity.name);
//     //     }
//     //   }
//     // }

//     // return _setUserNameRecently;
//     return [''].toSet();
//   }

//   // Future<List<QueryDocumentSnapshot>> _getQueryDocumentSnapshotList(
//   //     List<QuerySnapshot> categoryFilterQuerySnapshotList) async {
//   //   final List<QueryDocumentSnapshot> docs = [];
//   //   for (final querySnapshot in categoryFilterQuerySnapshotList) {
//   //     docs.addAll(querySnapshot.docs);
//   //   }
//   //   return docs;
//   // }

//   void addSetNameParticipants(List<String> nameParticipants) {
//     _setUserNameRecently.addAll(nameParticipants);
//   }

//   void cleanSingletonData() {
//     _setUserNameRecently = {};
//   }
// }
