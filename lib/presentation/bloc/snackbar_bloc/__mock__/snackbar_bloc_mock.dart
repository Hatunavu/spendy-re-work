import 'package:bloc_test/bloc_test.dart';

import 'package:spendy_re_work/presentation/bloc/snackbar_bloc/snackbar_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/snackbar_bloc/snackbar_event.dart';
import 'package:spendy_re_work/presentation/bloc/snackbar_bloc/snackbar_state.dart';

class MockSnackbarBloc extends MockBloc<SnackbarEvent, SnackbarState>
    implements SnackbarBloc {}
