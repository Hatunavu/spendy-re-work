import 'dart:collection';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';
import 'package:spendy_re_work/common/utils/algorithm/settle_debt_algorithm/model/settle_debt_model.dart';
import 'package:spendy_re_work/presentation/journey/transaction/debt/debt_constants.dart';

class DebtUseCase {
  Future<Map<String, double>> getUserTransactionsList(
      List<SettleDebtModel> settleDebtsList, String fullName) async {
    Map<String, double> transactionDebtsMap = {};

    for (final SettleDebtModel settleDebtModel in settleDebtsList) {
      transactionDebtsMap[settleDebtModel.payerName.trim()] = 0;
      transactionDebtsMap[settleDebtModel.payeeName.trim()] = 0;
    }

    // getTransactionDebtsList
    for (final String name in transactionDebtsMap.keys.toList()) {
      for (final SettleDebtModel settleDebtModel in settleDebtsList) {
        if (settleDebtModel.payerName.trim() == name.trim()) {
          transactionDebtsMap[name] =
              transactionDebtsMap[name]! + settleDebtModel.debtAmount;
        } else if (settleDebtModel.payeeName.trim() == name.trim()) {
          transactionDebtsMap[name] =
              transactionDebtsMap[name]! - settleDebtModel.debtAmount;
        }
      }
    }
    transactionDebtsMap = cleanTransactionDebtsMap(transactionDebtsMap);
    transactionDebtsMap = await userOnTopDebtMap(
        debtMap: transactionDebtsMap, userFullName: fullName);
//    debugPrint('transactionDebtsMap: $transactionDebtsMap');

    return transactionDebtsMap;
  }

  Map<String, double> cleanTransactionDebtsMap(
      Map<String, double> transactionDebtsMap) {
    for (int i = 0; i < transactionDebtsMap.keys.toList().length; i++) {
      if (transactionDebtsMap.values.toList()[i] == 0 ||
          transactionDebtsMap.values.toList()[i].toString().contains('e')) {
        transactionDebtsMap.remove(transactionDebtsMap.keys.toList()[i]);
        i--;
      }
    }
    return transactionDebtsMap;
  }

  List<SettleDebtModel> optimizeDebtsList(
      List<SettleDebtModel> listSettleDebtModel,
      Map<String, double> transactionDebtsMap,
      String userFullName) {
    final List<SettleDebtModel> optimizeSettleDebtsList = [];

//    _optimizeSettleDebtsList.clear();
    // _optimizeSettleDebtsList.addAll(listSettleDebtModel);
    final Map<String, double> creditors = Map<String, double>(); // chủ nợ
    final Map<String, double> debtor = Map<String, double>(); // trả nợ
    for (int i = 0; i < transactionDebtsMap.values.toList().length; i++) {
      if (transactionDebtsMap.values.toList()[i] > 0) {
        creditors[transactionDebtsMap.keys.toList()[i]] =
            transactionDebtsMap.values.toList()[i];
      } else {
        debtor[transactionDebtsMap.keys.toList()[i]] =
            transactionDebtsMap.values.toList()[i];
      }
    }
    int count = 1;
    while (count > 0) {
      count = 0;
      final sortedKeysCreditors = creditors.keys.toList(growable: false)
        ..sort((k1, k2) => creditors[k2]!.compareTo(creditors[k1]!));
      final sortedKeysDebtor = debtor.keys.toList(growable: false)
        ..sort((k1, k2) => debtor[k1]!.compareTo(debtor[k2]!));
      final LinkedHashMap sortedMapCreditors = LinkedHashMap.fromIterable(
          sortedKeysCreditors,
          key: (k) => k,
          value: (k) => creditors[k]);
      final LinkedHashMap sortedMapDebtor = LinkedHashMap.fromIterable(
          sortedKeysDebtor,
          key: (k) => k,
          value: (k) => debtor[k]);
      if (sortedKeysCreditors.isNotEmpty && sortedKeysDebtor.isNotEmpty) {
        if (sortedMapCreditors[sortedKeysCreditors.first] >
            -sortedMapDebtor[sortedKeysDebtor.first]) {
          if (!(sortedMapCreditors[sortedKeysCreditors.first] +
                  sortedMapDebtor[sortedKeysDebtor.first])
              .toString()
              .contains('e')) {
            optimizeSettleDebtsList.add(SettleDebtModel(
                debtAmount: -sortedMapDebtor[sortedKeysDebtor.first],
                payeeName: sortedKeysDebtor.first,
                payerName: sortedKeysCreditors.first));
            debtor.remove(sortedKeysDebtor.first);
            creditors[sortedKeysCreditors.first] =
                sortedMapCreditors[sortedKeysCreditors.first] +
                    sortedMapDebtor[sortedKeysDebtor.first];
            count++;
          } else {
            optimizeSettleDebtsList.add(SettleDebtModel(
                debtAmount: -sortedMapDebtor[sortedKeysDebtor.first],
                payeeName: sortedKeysDebtor.first,
                payerName: sortedKeysCreditors.first));
            debtor.remove(sortedKeysDebtor.first);
            creditors.remove(sortedKeysCreditors.first);
            count++;
          }
        } else if (sortedMapCreditors[sortedKeysCreditors.first] <
            -sortedMapDebtor[sortedKeysDebtor.first]) {
          if (!(sortedMapCreditors[sortedKeysCreditors.first] +
                  sortedMapDebtor[sortedKeysDebtor.first])
              .toString()
              .contains('e')) {
            optimizeSettleDebtsList.add(SettleDebtModel(
                debtAmount: sortedMapCreditors[sortedKeysCreditors.first],
                payeeName: sortedKeysDebtor.first,
                payerName: sortedKeysCreditors.first));
            creditors.remove(sortedKeysCreditors.first);
            debtor[sortedKeysDebtor.first] =
                sortedMapCreditors[sortedKeysCreditors.first] +
                    sortedMapDebtor[sortedKeysDebtor.first];
            count++;
          } else {
            optimizeSettleDebtsList.add(SettleDebtModel(
                debtAmount: sortedMapCreditors[sortedKeysCreditors.first],
                payeeName: sortedKeysDebtor.first,
                payerName: sortedKeysCreditors.first));
            debtor.remove(sortedKeysDebtor.first);
            creditors.remove(sortedKeysCreditors.first);
            count++;
          }
        } else {
          optimizeSettleDebtsList.add(SettleDebtModel(
              debtAmount: sortedMapCreditors[sortedKeysCreditors.first],
              payeeName: sortedKeysDebtor.first,
              payerName: sortedKeysCreditors.first));
          creditors.remove(sortedKeysCreditors.first);
          debtor.remove(sortedKeysDebtor.first);
          count++;
        }
      }
    }

    // FLOW: User (me) always at the top of the list
    _sortSettleDebtsList(optimizeSettleDebtsList, userFullName);

    return optimizeSettleDebtsList;
  }

  List<SettleDebtModel> _sortSettleDebtsList(
      List<SettleDebtModel> settleDebtsList1, String userFullName) {
    final List<SettleDebtModel> sortSettleDebtsList = [];
    for (int i = 0; i < settleDebtsList1.length; i++) {
      if (settleDebtsList1[i]
          .payerName
          .removeExtraCharacters()
          .toLowerCase()
          .contains(userFullName.toLowerCase())) {
        sortSettleDebtsList.add(settleDebtsList1[i]);
        settleDebtsList1.removeAt(i);
        i--;
      }
    }
    for (int i = 0; i < settleDebtsList1.length; i++) {
      if (settleDebtsList1[i]
          .payeeName
          .removeExtraCharacters()
          .toLowerCase()
          .contains(userFullName.toLowerCase())) {
        sortSettleDebtsList.add(settleDebtsList1[i]);
        settleDebtsList1.removeAt(i);
        i--;
      }
    }
    settleDebtsList1.insertAll(0, sortSettleDebtsList);
    return settleDebtsList1;
  }

  Future<Map<String, double>> userOnTopDebtMap(
      {Map<String, double>? debtMap, String? userFullName}) async {
    final Map<String, double> userOnTopDebtMap = {};
    for (final String participantName in debtMap!.keys) {
      if (participantName
          .removeExtraCharacters()
          .toLowerCase()
          .contains(userFullName!.toLowerCase())) {
        userOnTopDebtMap[participantName] = debtMap[participantName]!;
        debtMap.remove(participantName);
        break;
      }
    }
    userOnTopDebtMap.addAll(debtMap);
    return userOnTopDebtMap;
  }

  List<ShareSettleDebtEntity> initialShareSettleDebtEntityList(
      List<SettleDebtModel> settleDebtModelList) {
    final List<ShareSettleDebtEntity> shareSettleDebtList = [];
    for (final SettleDebtModel settleDebtModel in settleDebtModelList) {
      shareSettleDebtList.add(ShareSettleDebtEntity(
          isShare: false, settleDebtModel: settleDebtModel));
    }
    return shareSettleDebtList;
  }

  String createShareMessage(List<ShareSettleDebtEntity> shareSettleDebtList) {
    String message = 'Debit list:\n';
    for (final ShareSettleDebtEntity shareSettleDebtEntity
        in shareSettleDebtList) {
      if (shareSettleDebtEntity.isShare) {
        message += '- ${shareSettleDebtEntity.settleDebtModel.payeeName} '
            '${DebtConstants.owesText} '
            '${shareSettleDebtEntity.settleDebtModel.payerName} '
            '${shareSettleDebtEntity.settleDebtModel.debtAmount.toInt().toString().formatStringToCurrency(haveSymbol: true)}\n';
      }
    }
    return message.trim();
  }
}

class ShareSettleDebtEntity {
  bool isShare;
  SettleDebtModel settleDebtModel;

  ShareSettleDebtEntity({required this.isShare, required this.settleDebtModel});

  void share() {
    isShare = !isShare;
  }
}
