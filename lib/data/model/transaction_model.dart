import 'package:spendy_re_work/data/model/for_me_model.dart';
import 'package:spendy_re_work/data/model/participant_in_transaction_model.dart';
import 'package:spendy_re_work/data/model/photo_model.dart';
import 'package:spendy_re_work/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
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

  factory TransactionModel.fromJson(
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
    return TransactionModel(
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
