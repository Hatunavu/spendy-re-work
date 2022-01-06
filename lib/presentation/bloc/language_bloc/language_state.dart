import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class LanguageState extends Equatable {
  final Locale locale;
  LanguageState(this.locale);
}

class StartAppState extends LanguageState {
  StartAppState(Locale locale) : super(locale);

  @override
  List<Object> get props => [locale];
}

class LoadingLocaleState extends LanguageState {
  @override
  final Locale locale;
  LoadingLocaleState(this.locale) : super(locale);
  @override
  List<Object> get props => [locale];
}

class LoadedLocaleState extends LanguageState {
  @override
  final Locale locale;
  LoadedLocaleState(this.locale) : super(locale);

  @override
  List<Object> get props => [locale];
}
