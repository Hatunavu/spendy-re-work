import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';

abstract class PaymentsState extends Equatable {}

class PaymentsInitialState extends PaymentsState {
  final int? indexInitSplashContent;
  final int? indexInitMoney;

  PaymentsInitialState({this.indexInitSplashContent, this.indexInitMoney});
  @override
  List<Object?> get props => [indexInitSplashContent, indexInitMoney];
}

class PaymentsChangeSplashContentState extends PaymentsState {
  final int? indexSplashContent;

  PaymentsChangeSplashContentState({this.indexSplashContent});
  @override
  List<Object?> get props => [indexSplashContent];
}

class PaymentsChangeMoneyState extends PaymentsState {
  final int? indexMoney;

  PaymentsChangeMoneyState({this.indexMoney});
  @override
  List<Object?> get props => [indexMoney];
}
