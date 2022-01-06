import 'package:spendy_re_work/data/model/transaction_model.dart';
import 'package:spendy_re_work/domain/entities/for_me_entity.dart';
import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';

class TransactionEntity {
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

  TransactionEntity(
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

  TransactionModel toModel() => TransactionModel(
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

  TransactionEntity copyWith(
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
    return TransactionEntity(
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
