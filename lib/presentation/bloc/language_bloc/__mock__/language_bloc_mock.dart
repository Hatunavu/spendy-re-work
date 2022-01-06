import 'package:bloc_test/bloc_test.dart';

import '../bloc.dart';

class MockLanguageBloc extends MockBloc<LanguageEvent, LanguageState>
    implements LanguageBloc {}
