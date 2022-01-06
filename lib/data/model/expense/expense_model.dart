import 'package:spendy_re_work/data/model/for_me_model.dart';
import 'package:spendy_re_work/data/model/participant_in_transaction_model.dart';
import 'package:spendy_re_work/data/model/photo_model.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  ExpenseModel({
    String? id,
    required int amont,
    String? note,
    required String category,
    List<PhotoModel>? photos,
    List<ParticipantInTransactionModel>? whoPaid,
    List<ParticipantInTransactionModel>? forWho,
    required int spendTime,
    required int updateAt,
    ForMeModel? forMe,
  }) : super(
            id: id,
            amount: amont,
            category: category,
            note: note,
            whoPaid: whoPaid ?? [],
            forWho: forWho ?? [],
            photos: photos ?? [],
            spendTime: spendTime,
            updateAt: updateAt,
            forMe: forMe);

  factory ExpenseModel.normalSpendTime() =>
      ExpenseModel(amont: 0, category: '', spendTime: 0, updateAt: 0);

  factory ExpenseModel.fromJson(
      Map<String, dynamic> json, String transactionId) {
    final whoPaids = <ParticipantInTransactionModel>[];
    for (final whoPaid in json['who_paid']) {
      whoPaids.add(ParticipantInTransactionModel.fromJson(
          whoPaid as Map<String, dynamic>));
    }
    final forWhos = <ParticipantInTransactionModel>[];
    for (final forWho in json['for_who']) {
      forWhos.add(ParticipantInTransactionModel.fromJson(
          forWho as Map<String, dynamic>));
    }
    final photos = <PhotoModel>[];
    for (final photo in json['photos'] ?? []) {
      photos.add(PhotoModel.fromJson(photo));
    }
    return ExpenseModel(
      id: transactionId,
      amont: json['amount'],
      category: json['category'],
      whoPaid: whoPaids,
      forWho: forWhos,
      photos: photos,
      note: json['note'],
      spendTime: json['spend_time'],
      updateAt: json['update_at'],
      // forMe: ForMeModel.fromJson(json['me'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'category': category,
      'who_paid': whoPaid
          .map((e) => e.toParticipantInTransactionModel().toJson())
          .toList(),
      'for_who': forWho
          .map((e) => e.toParticipantInTransactionModel().toJson())
          .toList(),
      'note': note,
      'spend_time': spendTime,
      'update_at': updateAt,
      'me': forMe?.toModel().toJson()
    };
  }
}

// import 'package:spendy_re_work/data/model/photo_model.dart';
// import 'package:spendy_re_work/data/model/expense/participant_expense_model.dart';
// import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';

// class ExpenseModel extends ExpenseEntity {
//   ExpenseModel({
//     String? id,
//     int? amount,
//     String? group,
//     String? isoCode,
//     String? category,
//     String? remarks,
//     List<ParticipantExpenseModel>? paid,
//     List<ParticipantExpenseModel>? debts,
//     List<PhotoModel>? photos,
//     int? timeSpend,
//     int? searchTime,
//     int? createAt,
//     int? lastUpdate,
//   }) : super(
//           id: id,
//           amount: amount,
//           group: group,
//           isoCode: isoCode,
//           category: category,
//           remarks: remarks,
//           paid: paid,
//           debts: debts,
//           photos: photos,
//           timeSpend: timeSpend,
//           searchTime: searchTime,
//           createAt: createAt,
//           lastUpdate: lastUpdate,
//         );

//   ExpenseModel.fromJson(
//     Map<String, dynamic> json,
//     String docId,
//   ) {
//     final List<ParticipantExpenseModel> paid =
//         getParticipantList(json['paids']);
//     final List<ParticipantExpenseModel> debts =
//         getParticipantList(json['debts']);
//     id = docId;
//     amount = json['amount'];
//     group = json['group'];
//     isoCode = json['iso_code'];
//     category = json['category'];
//     remarks = json['remarks'];
//     this.paid = paid;
//     this.debts = debts;
//     photos = getPhotoList(json['photos']);
//     timeSpend = json['time_spend'] ?? 0;
//     searchTime = json['search_time'] ?? 0;
//     createAt = json['create_at'] ?? 0;
//     lastUpdate = json['last_update'] ?? 0;
//   }

//   factory ExpenseModel.normal() => ExpenseModel(
//         id: '',
//         amount: 0,
//         group: '',
//         isoCode: '',
//         category: '',
//         remarks: '',
//         paid: [],
//         debts: [],
//         timeSpend: 0,
//         searchTime: 0,
//         createAt: 0,
//         lastUpdate: 0,
//       );

//   factory ExpenseModel.normalSpendTime() => ExpenseModel(
//         id: '',
//         amount: 0,
//         group: '',
//         isoCode: '',
//         category: '',
//         remarks: '',
//         paid: [],
//         debts: [],
//         timeSpend: DateTime.now().millisecondsSinceEpoch,
//         searchTime: 0,
//         createAt: 0,
//         lastUpdate: 0,
//       );

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['amount'] = amount;
//     data['group'] = group;
//     data['iso_code'] = isoCode;
//     data['category'] = category;
//     data['remarks'] = remarks;
//     data['paids'] = getParticipantDynamicList(paid!);
//     data['debts'] = getParticipantDynamicList(debts!);
//     data['photos'] = photoPathList;
//     data['time_spend'] = timeSpend;
//     data['search_time'] = searchTime;
//     data['create_at'] = createAt;
//     data['last_update'] = lastUpdate;
//     return data;
//   }

//   List<dynamic> getParticipantDynamicList(List participantList) {
//     final participantDynamicList = [];
//     for (final ParticipantExpenseModel participant in participantList) {
//       participantDynamicList.add(participant.toJson());
//     }
//     return participantDynamicList;
//   }

//   // List<dynamic> getParticipantDynamicList(
//   //     List<ParticipantExpenseEntity> participantList) {
//   //   List<dynamic> participantDynamicList = [];
//   //   for (ParticipantExpenseEntity participant in participantList) {
//   //     participantDynamicList.add(participant.toJson());
//   //   }
//   //   return participantDynamicList;
//   // }

//   List<ParticipantExpenseModel> getParticipantList(dynamic json) {
//     final List<ParticipantExpenseModel> participantList = [];
//     if (json != null) {
//       for (final participantJson in json) {
//         participantList.add(ParticipantExpenseModel.fromJson(
//             Map<String, dynamic>.from(participantJson)));
//       }
//     }
//     return participantList;
//   }

//   List<PhotoModel> getPhotoList(dynamic json) {
//     final List<PhotoModel> photoList = [];
//     if (json != null) {
//       for (final photoPath in json) {
//         photoList.add(PhotoModel(path: photoPath.toString()));
//       }
//     }
//     return photoList;
//   }

//   List<String> get photoPathList {
//     final List<String> photoPathList = [];
//     if (photos != null && photos!.isNotEmpty) {
//       for (final photo in photos!) {
//         photoPathList.add(photo.path!);
//       }
//     }
//     return photoPathList;
//   }
// }
