import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class LanguageEvent extends Equatable {
  LanguageEvent();

  @override
  List<Object> get props => [];
}

class LoadLanguageFromSharedPreferenceEvent extends LanguageEvent {
  LoadLanguageFromSharedPreferenceEvent();
}

class SetLanguageToSharedPreferenceEvent extends LanguageEvent {
  final Locale locale;
  SetLanguageToSharedPreferenceEvent(this.locale);
  @override
  List<Object> get props => [locale];
}

class LoadInitialLanguage extends LanguageEvent {
  LoadInitialLanguage();
}
