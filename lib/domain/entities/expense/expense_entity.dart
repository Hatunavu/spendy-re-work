import 'package:spendy_re_work/data/model/expense/expense_model.dart';
import 'package:spendy_re_work/domain/entities/for_me_entity.dart';
import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';

class ExpenseEntity {
  final String? id;
  final int amount;
  final String category;
  final List<ParticipantInTransactionEntity> whoPaid;
  final List<ParticipantInTransactionEntity> forWho;
  final String? note;
  final List<PhotoEntity> photos;
  final int spendTime;
  final int updateAt;
  final ForMeEntity? forMe;

  ExpenseEntity(
      {this.id,
      required this.amount,
      required this.category,
      required this.whoPaid,
      required this.forWho,
      required this.note,
      required this.photos,
      required this.spendTime,
      required this.updateAt,
      this.forMe});
  factory ExpenseEntity.normal() => ExpenseEntity(
      amount: 0,
      category: '',
      whoPaid: [],
      forWho: [],
      note: '',
      photos: [],
      spendTime: 0,
      updateAt: 0);

  ExpenseModel toModel() => ExpenseModel(
      id: id,
      amont: amount,
      category: category,
      whoPaid: whoPaid.map((e) => e.toParticipantInTransactionModel()).toList(),
      forWho: forWho.map((e) => e.toParticipantInTransactionModel()).toList(),
      note: note,
      photos: photos.map((e) => e.toModel()).toList(),
      spendTime: spendTime,
      updateAt: updateAt,
      forMe: forMe?.toModel());

  ExpenseEntity copyWith(
      {String? id,
      int? amount,
      String? category,
      List<ParticipantInTransactionEntity>? whoPaid,
      List<ParticipantInTransactionEntity>? forWho,
      String? note,
      List<PhotoEntity>? photos,
      int? spendTime,
      int? updateAt,
      ForMeEntity? forMe}) {
    return ExpenseEntity(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      whoPaid: whoPaid ?? this.whoPaid,
      forWho: forWho ?? this.forWho,
      note: note ?? this.note,
      photos: photos ?? this.photos,
      spendTime: spendTime ?? this.spendTime,
      updateAt: updateAt ?? this.updateAt,
      forMe: forMe ?? this.forMe,
    );
  }

  @override
  String toString() {
    return 'TransactionEntity(id: $id, amount: $amount, category: $category, whoPaid: $whoPaid, forWho: $forWho, note: $note, photos: $photos, spendTime: $spendTime, updateAt: $updateAt, forMe: $forMe)';
  }
}


// import 'package:spendy_re_work/data/model/photo_model.dart';
// import 'package:spendy_re_work/data/model/expense/expense_model.dart';
// import 'package:spendy_re_work/data/model/expense/participant_expense_model.dart';
// import 'package:spendy_re_work/domain/entities/photo_entity.dart';
// import 'package:spendy_re_work/domain/entities/expense/participant_expense_entity.dart';

// class ExpenseEntity {
//   String? id;
//   int? amount;
//   String? group;
//   String? isoCode;
//   String? category;
//   String? remarks;
//   List<ParticipantExpenseEntity>? paid;
//   List<ParticipantExpenseEntity>? debts;
//   List<PhotoEntity>? photos;
//   int? timeSpend;
//   int? searchTime;
//   int? createAt;
//   int? lastUpdate;

//   ExpenseEntity({
//     this.id,
//     this.amount,
//     this.group,
//     this.isoCode,
//     this.category,
//     this.remarks,
//     this.paid,
//     this.debts,
//     this.photos,
//     this.timeSpend,
//     this.searchTime,
//     this.createAt,
//     this.lastUpdate,
//   });

//   factory ExpenseEntity.normal() => ExpenseEntity(
//         id: '',
//         amount: 0,
//         group: '',
//         isoCode: '',
//         category: '',
//         remarks: '',
//         paid: [],
//         debts: [],
//         photos: [],
//         timeSpend: 0,
//         searchTime: 0,
//         createAt: 0,
//         lastUpdate: 0,
//       );

//   ExpenseModel toModel() {
//     return ExpenseModel(
//       id: id,
//       amount: amount,
//       group: group,
//       isoCode: isoCode,
//       category: category,
//       remarks: remarks,
//       paid: toParticipantExpenseModelList(paid!),
//       debts: toParticipantExpenseModelList(debts!),
//       photos: toPhotoModelList,
//       timeSpend: timeSpend,
//       searchTime: searchTime,
//       createAt: createAt,
//       lastUpdate: lastUpdate,
//     );
//   }

//   List<ParticipantExpenseModel> toParticipantExpenseModelList(
//       List<ParticipantExpenseEntity> participantExpenseEntityList) {
//     final List<ParticipantExpenseModel> participantExpenseModelList = [];
//     for (final ParticipantExpenseEntity participantExpenseEntity
//         in participantExpenseEntityList) {
//       participantExpenseModelList.add(participantExpenseEntity.toModel());
//     }
//     return participantExpenseModelList;
//   }

//   List<PhotoModel> get toPhotoModelList {
//     final List<PhotoModel> photoModelList = [];
//     if (photos != null && photos!.isNotEmpty) {
//       for (final PhotoEntity entity in photos!) {
//         photoModelList.add(entity.toModel());
//       }
//     }
//     return photoModelList;
//   }

//   void updatePhotos(List<PhotoEntity> photos) {
//     this.photos = [];
//     this.photos = photos;
//   }

//   void update({
//     String? id,
//     int? amount,
//     String? group,
//     String? isoCode,
//     String? category,
//     String? remarks,
//     List<ParticipantExpenseEntity>? paids,
//     List<ParticipantExpenseEntity>? debts,
//     List<PhotoEntity>? photos,
//     int? timeSpend,
//     int? searchTime,
//     int? createAt,
//     int? lastUpdate,
//   }) {
//     this.id = id ?? this.id;
//     this.amount = amount ?? this.amount;
//     this.group = group ?? this.group;
//     this.isoCode = isoCode ?? this.isoCode;
//     this.category = category ?? this.category;
//     this.remarks = remarks ?? this.remarks;
//     paid = paids ?? paid;
//     this.debts = debts ?? this.debts;
//     this.photos = photos ?? this.photos;
//     this.timeSpend = timeSpend ?? this.timeSpend;
//     this.searchTime = searchTime ?? this.searchTime;
//     this.createAt = createAt ?? this.createAt;
//     this.lastUpdate = lastUpdate ?? this.lastUpdate;
//   }

//   @override
//   String toString() {
//     return 'ExpenseEntity{id: $id, amount: $amount, group: $group, isoCode: $isoCode, category: $category, remarks: $remarks, paids: $paid, debts: $debts, photos: $photos, timeSpend: $timeSpend, searchTime: $searchTime, createAt: $createAt, lastUpdate: $lastUpdate}';
//   }
// }
