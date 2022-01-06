import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:spendy_re_work/common/i18n/language_constants.dart';

import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(StartAppState(const Locale(LanguageConstants.en)));

  @override
  Stream<LanguageState> mapEventToState(LanguageEvent event) async* {
    if (event is LoadLanguageFromSharedPreferenceEvent) {
      yield* _mapLoadLangToState(event);
    } else if (event is SetLanguageToSharedPreferenceEvent) {
      yield* _mapUpdateLocaleToState(event);
    }
  }

  Stream<LanguageState> _mapLoadLangToState(
      LoadLanguageFromSharedPreferenceEvent event) async* {
    final prefs = await SharedPreferences.getInstance();
    final locale = Locale(prefs.getString('lang') ?? LanguageConstants.en);

    yield LoadedLocaleState(locale);
  }

  Stream<LanguageState> _mapUpdateLocaleToState(
      SetLanguageToSharedPreferenceEvent event) async* {
    yield LoadingLocaleState(event.locale);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', event.locale.toString());

    yield LoadedLocaleState(event.locale);
  }
}
