import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/usecases/debt_usecase.dart';

abstract class DebtEvent extends Equatable {}

class DebtInitialEvent extends DebtEvent {
  @override
  List<Object> get props => [];
}

class ShareSettleDebtEvent extends DebtEvent {
  final List<ShareSettleDebtEntity> shareSettleDebtList;

  ShareSettleDebtEvent(this.shareSettleDebtList);
  @override
  List<Object> get props => [shareSettleDebtList];
}
