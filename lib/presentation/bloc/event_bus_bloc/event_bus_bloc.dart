import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/event_bus_bloc/event_bus_event.dart';
import 'package:spendy_re_work/presentation/bloc/event_bus_bloc/event_bus_state.dart';

class EventBusBloc extends Bloc<EventBusEvent, EventBusState> {
  EventBusBloc() : super(EventBusInitState());

  @override
  Stream<EventBusState> mapEventToState(EventBusEvent event) async* {
    switch (event.runtimeType) {
      case RefreshParticipantInTransactionEvent:
        {
          yield EventBusLoadingState();
          yield RefreshParticipantInTransactionState();
        }
    }
  }
}
