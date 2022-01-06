part of 'choose_currency_bloc.dart';

abstract class ChooseCurrencyState extends Equatable {
  const ChooseCurrencyState();
}

class ChooseCurrencyInitial extends ChooseCurrencyState {
  @override
  List<Object> get props => [];
}

class ChooseCurrencyLoaded extends ChooseCurrencyState {
  final Map<String, Set<CurrencyEntity>> mapCurrencies;
  final Set<CurrencyEntity> listCurrencies;
  final CurrencyEntity currencySelected;
  final bool isSearching;
  final bool showCleanButton;

  const ChooseCurrencyLoaded({
    required this.mapCurrencies,
    this.showCleanButton = false,
    this.isSearching = false,
    required this.listCurrencies,
    required this.currencySelected,
  });

  ChooseCurrencyLoaded copyWith({
    Map<String, Set<CurrencyEntity>>? mapCurrencies,
    Set<CurrencyEntity>? listCurrencies,
    CurrencyEntity? currencySelected,
    bool? isSearching,
    bool? showCleanButton,
    bool? saveBtnActive,
  }) {
    return ChooseCurrencyLoaded(
      showCleanButton: showCleanButton ?? this.showCleanButton,
      isSearching: isSearching ?? this.isSearching,
      mapCurrencies: mapCurrencies ?? this.mapCurrencies,
      listCurrencies: listCurrencies ?? this.listCurrencies,
      currencySelected: currencySelected ?? this.currencySelected,
    );
  }

  @override
  List<Object?> get props => [
        mapCurrencies,
        listCurrencies,
        currencySelected,
        isSearching,
        showCleanButton,
      ];
}

class CurrencyLoadingState extends ChooseCurrencyState {
  @override
  List<Object> get props => [];
}

class CurrencyActionLoadingState extends ChooseCurrencyState {
  @override
  List<Object> get props => [];
}

class CurrencyLoadFailure extends ChooseCurrencyState {
  @override
  List<Object> get props => [];
}

class CurrencySaveFailure extends ChooseCurrencyLoaded {
  CurrencySaveFailure(
      {required Map<String, Set<CurrencyEntity>> mapCurrencies,
      required Set<CurrencyEntity> listCurrencies,
      required CurrencyEntity currencySelected})
      : super(
            mapCurrencies: mapCurrencies,
            listCurrencies: listCurrencies,
            currencySelected: currencySelected);
}

class CurrencySaveSuccess extends ChooseCurrencyLoaded {
  CurrencySaveSuccess(
      {required Map<String, Set<CurrencyEntity>> mapCurrencies,
      required Set<CurrencyEntity> listCurrencies,
      required CurrencyEntity currencySelected})
      : super(
            mapCurrencies: mapCurrencies,
            listCurrencies: listCurrencies,
            currencySelected: currencySelected);
}
