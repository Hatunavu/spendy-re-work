import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spendy_re_work/common/constants/category_constants/default_category.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/domain/usecases/currency_usecase.dart';
import 'package:spendy_re_work/domain/usecases/profile_user_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';

part 'choose_currency_event.dart';

part 'choose_currency_state.dart';

/// @Singleton
class ChooseCurrencyBloc
    extends Bloc<ChooseCurrencyEvent, ChooseCurrencyState> {
  ChooseCurrencyBloc({
    required this.currencyUseCase,
    required this.profileUserUseCase,
    required this.authenticationBloc,
  }) : super(ChooseCurrencyInitial());

  final CurrencyUseCase currencyUseCase;
  final ProfileUserUseCase profileUserUseCase;
  final AuthenticationBloc authenticationBloc;

  @override
  Stream<ChooseCurrencyState> mapEventToState(
    ChooseCurrencyEvent event,
  ) async* {
    if (event is FetchCurrencyEvent) {
      yield* _mapFetchCurrencyEventToState();
    } else if (event is SelectedCurrencyEvent) {
      yield* _mapSelectedCurrencyEventToState(event);
    } else if (event is SaveCurrencyEvent) {
      yield* _mapSaveCurrencyEventToState(event);
    } else if (event is SearchingCurrencySubmitEvent) {
      yield* _mapSearchingCurrencyEventToState(event);
    } else if (event is SearchingCurrencyOnChangedEvent) {
      yield* _mapSearchingCurrencyOnChangedEventToState(event);
    }
  }

  Stream<ChooseCurrencyState> _mapFetchCurrencyEventToState() async* {
    yield CurrencyLoadingState();
    try {
      if (currencyUseCase.currencies.isEmpty) {
        await currencyUseCase.getCurrentCurrency();
      }
      final currencies = currencyUseCase.currencies;
      final mapCurrencies = currencyUseCase.mapAlphaBet;
      final currencySelected = currencyUseCase.currency;
      final bool saveBtnActive = currencySelected != null;

      yield ChooseCurrencyLoaded(
        mapCurrencies: mapCurrencies,
        listCurrencies: currencies.toSet(),
        currencySelected: currencies.first,
      );
    } catch (e) {
      yield CurrencyLoadFailure();
    }
  }

  Stream<ChooseCurrencyState> _mapSelectedCurrencyEventToState(
      SelectedCurrencyEvent event) async* {
    final currentState = state;
    if (currentState is ChooseCurrencyLoaded) {
      final bool saveBtnActive = event.currencyEntity != null;
      yield currentState.copyWith(
        currencySelected: event.currencyEntity,
        saveBtnActive: saveBtnActive,
      );
    }
  }

  Stream<ChooseCurrencyState> _mapSaveCurrencyEventToState(
      SaveCurrencyEvent event) async* {
    final currentState = state;
    if (currentState is ChooseCurrencyLoaded) {
      yield CurrencyActionLoadingState();
      yield currentState.copyWith();

      try {
        final user = authenticationBloc.userEntity;
        authenticationBloc.userEntity.isoCode = event.currencyEntity.isoCode!;
        await profileUserUseCase.updateProfile(user);
        currencyUseCase.setDefaultCurrency(
            isoCode: event.currencyEntity.isoCode);
        DefaultCategory.getDefault(DateTime.now().millisecondsSinceEpoch);

        authenticationBloc.add(LoggedIn(user));
        yield CurrencySaveSuccess(
            currencySelected: currentState.currencySelected,
            listCurrencies: currentState.listCurrencies,
            mapCurrencies: currentState.mapCurrencies);
      } catch (e) {
        debugPrint('ChooseCurrencyBloc - save currency - error: $e');
        yield CurrencySaveFailure(
            currencySelected: currentState.currencySelected,
            listCurrencies: currentState.listCurrencies,
            mapCurrencies: currentState.mapCurrencies);
      }
    }
  }

  Stream<ChooseCurrencyState> _mapSearchingCurrencyEventToState(
      SearchingCurrencySubmitEvent event) async* {
    final currentState = state;
    if (currentState is ChooseCurrencyLoaded) {
      if (event.key.isNotEmpty) {
        final currencies = currencyUseCase.currencies;
        final results = currencies.where((element) {
          final name = element.name?.toLowerCase();
          final isoCode = element.isoCode?.toLowerCase();
          final word = event.key.toLowerCase();

          return name!.contains(word) || isoCode!.contains(word);
        }).toSet();
        yield currentState.copyWith(listCurrencies: results, isSearching: true);
      } else {
        yield currentState.copyWith(
            listCurrencies: currencyUseCase.currencies.toSet(),
            isSearching: false);
      }
    }
  }

  Stream<ChooseCurrencyState> _mapSearchingCurrencyOnChangedEventToState(
      SearchingCurrencyOnChangedEvent event) async* {
    final currentState = state;
    if (currentState is ChooseCurrencyLoaded) {
      if (event.key.isNotEmpty) {
        yield currentState.copyWith(showCleanButton: true);
      } else {
        yield currentState.copyWith(showCleanButton: false);
      }
    }
  }
}
