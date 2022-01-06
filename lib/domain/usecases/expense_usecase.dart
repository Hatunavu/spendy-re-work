import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';
import 'package:spendy_re_work/common/utils/spend_time_util.dart';
import 'package:spendy_re_work/data/model/expense/expense_model.dart';
import 'package:spendy_re_work/data/model/participant_in_transaction_model.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_detail_entity.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
import 'package:spendy_re_work/domain/repositories/expense_repository.dart';
import 'package:spendy_re_work/domain/usecases/storage_usecase.dart';
import 'categories_usecase.dart';

class ExpenseUseCase {
  final ExpenseRepository expenseRepository;
  final CategoriesUseCase categoriesUseCase;
  final StorageUseCase storageUseCase;

  ExpenseUseCase({
    required this.expenseRepository,
    required this.categoriesUseCase,
    required this.storageUseCase,
  });

  /// ===== CREATE =====
  Future createExpense({
    String? uid,
    String? strAmount,
    String? group,
    String? isoCode,
    String? category,
    String? remarks,
    List<ParticipantInTransactionEntity>? whoPaid,
    List<ParticipantInTransactionEntity>? forWho,
    List<PhotoEntity>? photos,
    int? selectTime,
    int? searchTime,
    int? createAt,
  }) async {
    final int timeSpend = getTimeSpend(selectTime!, DateTime.now());
    final ExpenseEntity expenseEntity = ExpenseEntity(
      amount: int.parse(strAmount!),
      category: category ?? '',
      note: remarks,
      whoPaid: whoPaid ?? [],
      forWho: forWho ?? [],
      photos: photos ?? [],
      spendTime: timeSpend,
      updateAt: createAt ?? DateTime.now().millisecondsSinceEpoch,
    );
    await expenseRepository.createExpense(uid!, expenseEntity);
  }

  /// ===== UPDATE =====
  Future<void> updateExpense({
    String? id,
    String? uid,
    String? strAmount,
    String? group,
    String? isoCode,
    String? category,
    String? remarks,
    List<ParticipantInTransactionEntity>? whoPaid,
    List<ParticipantInTransactionEntity>? forWho,
    List<PhotoEntity>? photos,
    int? selectTime,
    int? currentSpendTime,
    int? createAt,
    int? searchTime,
  }) async {
    final int spendTime = getTimeSpend(
        selectTime!, DateTime.fromMillisecondsSinceEpoch(currentSpendTime!));
    final ExpenseEntity expenseEntity = ExpenseEntity(
        id: id,
        amount: int.parse(strAmount!),
        category: category ?? '',
        note: remarks,
        whoPaid: whoPaid ?? [],
        forWho: forWho ?? [],
        photos: photos ?? [],
        spendTime: spendTime,
        updateAt: DateTime.now().millisecondsSinceEpoch);
    await expenseRepository.updateExpense(uid!, expenseEntity.toModel());
  }

  Future<void> updateSearchTimeExpense(
      {String? uid, ExpenseEntity? expense}) async {
    // final now = DateTime.now();
    // expense!.copyWith(searchTime: now.millisecondsSinceEpoch);
    // await expenseRepository.updateExpense(uid!, expense.toModel());
  }

  // Stream<Event> fetchExpenseListBetweenTimeStream(
  //     String uid, DateTime startTime, DateTime endTime) async* {
  //   final startDate = startTime.millisecondsSinceEpoch;
  //   final endDate = endTime.millisecondsSinceEpoch;
  //
  //   final filter = DateFilterEntity(
  //       earlyMonthMillisecond: startDate, endMonthMillisecond: endDate);
  //   yield* expenseRepository.getExpenseListBetweenDateTimeRealtime(
  //       uid, filter.toModel());
  // }

  Future<Map<int, List<ExpenseEntity>>> getExpenseByDayMap(
      List<ExpenseEntity> expenseList) async {
    final Map<int, List<ExpenseEntity>> expenseMap =
        Map<int, List<ExpenseEntity>>();
    for (final ExpenseEntity expense in expenseList) {
      final DateTime dtSpendTime =
          DateTime.fromMillisecondsSinceEpoch(expense.spendTime);
      if (expenseMap[dtSpendTime.intYmd] == null) {
        expenseMap[dtSpendTime.intYmd] = [expense];
      } else {
        expenseMap[dtSpendTime.intYmd]!.add(expense);
      }
    }
    return expenseMap;
  }

  List<ExpenseEntity> mapExpenseDetailsToExpenseEntitiesBeetWeenTime(
      List<ExpenseDetailEntity> expenseDetailRecentlyList,
      DateTime startTime,
      DateTime endTime) {
    final List<ExpenseEntity> expenseEntities = [];
    final expenseDetails = expenseDetailRecentlyList.where((expenseDetail) =>
        expenseDetail.expenseEntity!.updateAt >=
            startTime.millisecondsSinceEpoch &&
        expenseDetail.expenseEntity!.updateAt <=
            endTime.millisecondsSinceEpoch);
    for (final ExpenseDetailEntity expenseDetail in expenseDetails) {
      expenseEntities.add(expenseDetail.expenseEntity!);
    }
    return expenseEntities;
  }

  Stream<Event> getExpenseStream(String uid) =>
      expenseRepository.getExpenseStream(uid);

  List<ExpenseEntity> getExpenseEntities(dynamic value) {
    final List<ExpenseEntity> expenseEntities = [];
    value.forEach((key, value) {
      //Map valueMap = Map<String, dynamic>.from(value);
      final ExpenseModel expenseModel = ExpenseModel.fromJson(
          Map<String, dynamic>.from(value), key.toString());
      expenseEntities.add(expenseModel);
    });
    return expenseEntities;
  }

  /// ===== FILTER =====

  /// ===== DELETE =====

  Future<Map<String, int>> removeGroupFilter(
      {Map<String, int>? groupsFilterMap, String? groupName}) async {
    groupsFilterMap!.remove(groupName);
    return groupsFilterMap;
  }

  Future<void> deleteExpense(String uid, ExpenseEntity expense) async {
    for (final PhotoEntity photo in expense.photos) {
      await storageUseCase.deleteImage(photo.path!);
    }
    await expenseRepository.deleteExpense(uid, expense.id!);
  }

  /// ===== OTHER =====

  Future<List<ExpenseEntity>> docsToExpenseEntities(
      {List<QueryDocumentSnapshot>? docs}) async {
    final List<ExpenseEntity> expenseEntities = [];
    if (docs != null && docs.isNotEmpty) {
      for (final doc in docs) {
        final ExpenseModel expenseModel =
            ExpenseModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
        expenseEntities.add(expenseModel);
      }
    }
    return expenseEntities;
  }

  List<ParticipantInTransactionModel> toModel(
      List<ParticipantInTransactionEntity> participantEntities) {
    final List<ParticipantInTransactionModel> participantModels = [];
    for (final ParticipantInTransactionEntity in participantEntities) {
      participantModels.add(
          ParticipantInTransactionEntity.toParticipantInTransactionModel());
    }
    return participantModels;
  }

  Future<Map<int, Set<ExpenseDetailEntity>>> addToExpenseDetailMap(
      {Map<int, Set<ExpenseDetailEntity>>? currentExpenseDetailMap,
      List<ExpenseDetailEntity>? expenseDetails}) async {
    if (expenseDetails == null || expenseDetails.isEmpty) {
      return currentExpenseDetailMap!;
    }
    for (final ExpenseDetailEntity expenseDetail in expenseDetails) {
      final int milliDate = expenseDetail.transactionEntity!.spendTime;
      if (currentExpenseDetailMap![milliDate] == null ||
          currentExpenseDetailMap[milliDate]!.isEmpty) {
        currentExpenseDetailMap[milliDate] = Set();
      }
      currentExpenseDetailMap[milliDate]!.add(expenseDetail);
    }
    currentExpenseDetailMap =
        await sortKeyExpenseDetailMap(currentExpenseDetailMap!);
    currentExpenseDetailMap =
        await sortValueExpenseDetailMap(currentExpenseDetailMap);
    return currentExpenseDetailMap;
  }

  Future<Map<int, Set<ExpenseDetailEntity>>> sortValueExpenseDetailMap(
      Map<int, Set<ExpenseDetailEntity>>? expenseDetailMap) async {
    final Map<int, Set<ExpenseDetailEntity>> expenseDetailSortMap = {};
    if (expenseDetailMap != null && expenseDetailMap.isNotEmpty) {
      for (final key in expenseDetailMap.keys) {
        Set<ExpenseDetailEntity> expDetailSet = expenseDetailMap[key]!;
        expDetailSet = await sortExpDetailByCreateTrans(expDetailSet);
        expenseDetailSortMap[key] = expDetailSet;
      }
    }
    return expenseDetailSortMap;
  }

  Future<Map<int, Set<ExpenseDetailEntity>>> sortKeyExpenseDetailMap(
      Map<int, Set<ExpenseDetailEntity>> expenseDetailMap) async {
    final Map<int, Set<ExpenseDetailEntity>> expenseDetailSortMap = {};
    final List<int> spendTimes = expenseDetailMap.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    for (final int spendTime in spendTimes) {
      expenseDetailSortMap[spendTime] = expenseDetailMap[spendTime]!;
    }
    return expenseDetailSortMap;
  }

  Future<Set<ExpenseDetailEntity>> sortExpDetailByCreateTrans(
      Set<ExpenseDetailEntity> expDetailSet) async {
    final List<ExpenseDetailEntity> expDetailList = expDetailSet.toList()
      ..sort((a, b) => b.transactionEntity!.updateAt
          .compareTo(a.transactionEntity!.updateAt));
    return expDetailList.toSet();
  }

  ///Function hasnt used. cmt
  // Future<List<QueryDocumentSnapshot>> _getQueryDocumentSnapshotList(
  //     List<QuerySnapshot> categoryFilterQuerySnapshotList) async {
  //   final List<QueryDocumentSnapshot> docs = [];
  //   if (categoryFilterQuerySnapshotList != null &&
  //       categoryFilterQuerySnapshotList.isNotEmpty) {
  //     for (final querySnapshot in categoryFilterQuerySnapshotList) {
  //       if (querySnapshot.docs != null && querySnapshot.docs.isNotEmpty)
  //         docs.addAll(querySnapshot.docs);
  //     }
  //   }
  //   return docs;
  // }

  int getTimeSort(int spendTime) {
    final int timeNowMilli = DateTime.now().millisecondsSinceEpoch;
    final int startTimeNowMilli = DateTime.now().intYmd;
    return spendTime + (timeNowMilli - startTimeNowMilli);
  }

  Future<List<ExpenseEntity>> sortExpDetailByCreateAt(
      List<ExpenseEntity> expEntities) async {
    expEntities.sort((a, b) => b.updateAt.compareTo(a.updateAt));
    return expEntities;
  }

  /// PHOTO
  Future<List<PhotoEntity>> getImageUriList(ExpenseEntity expense) async {
    final List<PhotoEntity> photos = [];
    for (final PhotoEntity item in expense.photos) {
      final PhotoEntity photo = await storageUseCase.getPhotoUri(item);
      photos.add(photo);
    }
    return photos;
  }

  // Just request 3 image when show in transaction detail
  Future<List<PhotoEntity>> getImageUriRecentList(ExpenseEntity expense) async {
    final List<PhotoEntity> photos = [];
    for (final PhotoEntity item in expense.photos) {
      if (photos.length < 3) {
        final PhotoEntity photo = await storageUseCase.getPhotoUri(item);
        photos.add(photo);
      } else {
        photos.add(item);
      }
    }
    return photos;
  }

  bool createExpenseOffline({
    String? uid,
    String? strAmount,
    String? group,
    String? isoCode,
    String? category,
    String? remarks,
    List<ParticipantInTransactionEntity>? whoPaid,
    List<ParticipantInTransactionEntity>? forWho,
    List<PhotoEntity>? photos,
    int? selectTime,
    int? searchTime,
    int? createAt,
  }) {
    final int timeSpend = getTimeSpend(selectTime!, DateTime.now());
    final ExpenseEntity expenseEntity = ExpenseEntity(
      amount: int.parse(strAmount!),
      category: category ?? '',
      whoPaid: whoPaid ?? [],
      forWho: forWho ?? [],
      photos: photos ?? [],
      spendTime: timeSpend,
      updateAt: createAt ?? DateTime.now().millisecondsSinceEpoch,
      note: remarks,
    );
    return expenseRepository.createExpenseOffline(uid!, expenseEntity);
  }

  bool updateExpenseOffline({
    String? id,
    String? uid,
    String? strAmount,
    String? group,
    String? isoCode,
    String? category,
    String? remarks,
    List<ParticipantInTransactionEntity>? whoPaid,
    List<ParticipantInTransactionEntity>? forWho,
    List<PhotoEntity>? photos,
    int? selectTime,
    int? currentSpendTime,
    int? createAt,
  }) {
    final int spendTime = getTimeSpend(
        selectTime!, DateTime.fromMillisecondsSinceEpoch(currentSpendTime!));
    final ExpenseEntity expenseEntity = ExpenseEntity(
        id: id,
        amount: int.parse(strAmount!),
        category: category ?? '',
        note: remarks,
        whoPaid: whoPaid ?? [],
        forWho: forWho ?? [],
        photos: photos ?? [],
        spendTime: spendTime,
        updateAt: DateTime.now().millisecondsSinceEpoch);
    return expenseRepository.updateExpenseOffline(
        uid!, expenseEntity.toModel());
  }

  Future<bool> deleteExpenseOffline(
      {String? uid, ExpenseEntity? expense}) async {
    for (final PhotoEntity photo in expense!.photos) {
      await storageUseCase.deleteImage(photo.path!);
    }
    return expenseRepository.deleteExpenseOffline(uid!, expense.id!);
  }

  // Future<bool> checkPersonalExpense({
  //   Map<String, ParticipantInTransactionEntity>? whoPaidMap,
  //   Map<String, ParticipantInTransactionEntity>? forWhoMap,
  //   UserEntity? user,
  // }) =>
  //     participantUseCase.checkPersonalExpense(
  //         whoPaidMap: whoPaidMap, forWhoMap: forWhoMap, user: user);
}
