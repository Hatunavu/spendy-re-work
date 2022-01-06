import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/common/utils/algorithm/settle_debt_algorithm/model/settle_debt_model.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/usecases/debt_usecase.dart';

abstract class DebtState extends Equatable {}

class DebtLoadingState extends DebtState {
  @override
  List<Object> get props => [];
}

class DebtInitialState extends DebtState {
  final Map<String, double> mapDebt;
  final List<SettleDebtModel> optimizeDebtsList;
  final List<ShareSettleDebtEntity> shareSettleDebtList;
  final CategoryEntity categoryEntity;

  DebtInitialState(
      {required this.mapDebt,
      required this.categoryEntity,
      required this.shareSettleDebtList,
      required this.optimizeDebtsList});

  DebtInitialState copyWith({
    Map<String, double>? mapDebt,
    List<SettleDebtModel>? optimizeDebtsList,
    List<ShareSettleDebtEntity>? shareSettleDebtList,
    CategoryEntity? categoryEntity,
  }) =>
      DebtInitialState(
        mapDebt: mapDebt ?? this.mapDebt,
        optimizeDebtsList: optimizeDebtsList ?? this.optimizeDebtsList,
        shareSettleDebtList: shareSettleDebtList ?? this.shareSettleDebtList,
        categoryEntity: categoryEntity ?? this.categoryEntity,
      );

  @override
  List<Object> get props => [
        mapDebt,
        optimizeDebtsList,
        shareSettleDebtList,
        categoryEntity,
      ];
}

class DebtFailedState extends DebtState {
  @override
  List<Object> get props => [];
}

class SelectShareSettleDebtState extends DebtState {
  @override
  List<Object> get props => [];
}
