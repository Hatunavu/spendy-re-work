part of 'choose_currency_bloc.dart';

abstract class ChooseCurrencyEvent extends Equatable {
  const ChooseCurrencyEvent();
}

class FetchCurrencyEvent extends ChooseCurrencyEvent {
  @override
  List<Object> get props => [];
}

class SearchingCurrencySubmitEvent extends ChooseCurrencyEvent {
  final String key;

  SearchingCurrencySubmitEvent(this.key);

  @override
  List<Object> get props => [key];
}

class SearchingCurrencyOnChangedEvent extends ChooseCurrencyEvent {
  final String key;

  SearchingCurrencyOnChangedEvent(this.key);

  @override
  List<Object> get props => [key];
}

class SelectedCurrencyEvent extends ChooseCurrencyEvent {
  final CurrencyEntity? currencyEntity;

  SelectedCurrencyEvent(this.currencyEntity);

  @override
  List<Object> get props => [currencyEntity!];
}

class SaveCurrencyEvent extends ChooseCurrencyEvent {
  final CurrencyEntity currencyEntity;

  SaveCurrencyEvent(this.currencyEntity);

  @override
  List<Object> get props => [currencyEntity];
}
