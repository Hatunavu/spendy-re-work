import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';

abstract class FilterEvent extends Equatable {}

class FilterInitialEvent extends FilterEvent {
  final String? languageCode;

  FilterInitialEvent({this.languageCode});
  @override
  List<Object> get props => [languageCode!];
}

class SelectFilterEvent extends FilterEvent {
  final String? optionKey;
  final String? selectOption;
  final bool? active;
  final double? startRange;
  final double? endRange;
  final bool? spendRangeInfinity;

  SelectFilterEvent({
    this.optionKey,
    this.selectOption,
    this.active,
    this.startRange,
    this.endRange,
    this.spendRangeInfinity,
  });

  @override
  List<Object> get props => [
        selectOption!,
        active!,
        startRange!,
        endRange!,
      ];
}

class ResetFilterEvent extends FilterEvent {
  final String? optionKey;

  ResetFilterEvent({this.optionKey});

  @override
  List<Object> get props => [optionKey!];
}

class ApplyFilterEvent extends FilterEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class AddMoreSpendTimerEvent extends FilterEvent {
  final String? languageCode;

  AddMoreSpendTimerEvent({this.languageCode});

  @override
  List<Object> get props => [languageCode!];
}

class SpendRangeInfinityEvent extends FilterEvent {
  final bool spendRangeInfinity;

  SpendRangeInfinityEvent({required this.spendRangeInfinity});

  @override
  List<Object> get props => [spendRangeInfinity];
}
