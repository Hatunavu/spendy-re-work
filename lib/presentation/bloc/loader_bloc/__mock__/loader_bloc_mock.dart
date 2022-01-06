import 'package:bloc_test/bloc_test.dart';

import 'package:spendy_re_work/presentation/bloc/loader_bloc/loader_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/loader_bloc/loader_event.dart';
import 'package:spendy_re_work/presentation/bloc/loader_bloc/loader_state.dart';

class MockLoaderBloc extends MockBloc<LoaderEvent, LoaderState>
    implements LoaderBloc {}
