import 'package:bloc/bloc.dart';

import 'bloc.dart';

class LoaderBloc extends Bloc<LoaderEvent, LoaderState> {
  LoaderBloc() : super(InitLoader());

  @override
  Stream<LoaderState> mapEventToState(LoaderEvent event) async* {
    if (event is StartLoading) {
      yield* _loading(event);
    }
    if (event is FinishLoading) {
      yield Loaded();
    }
  }

  Stream<LoaderState> _loading(StartLoading event) async* {
    yield Loading(isTopLoading: event.isTopLoading);
  }
}
