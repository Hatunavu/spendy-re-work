import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';

abstract class PaymentsEvent extends Equatable {}

class InitialPaymentsEvent extends PaymentsEvent {
  @override
  List<Object?> get props => [];
}

class ChangeContentEvent extends PaymentsEvent {
  final int? indexInitSplashContent;

  ChangeContentEvent({this.indexInitSplashContent});

  @override
  List<Object?> get props => [indexInitSplashContent];
}

class ChangePaymentsMoneyEvent extends PaymentsEvent {
  final int? indexMoney;

  ChangePaymentsMoneyEvent({this.indexMoney});

  @override
  List<Object?> get props => [indexMoney];
}
