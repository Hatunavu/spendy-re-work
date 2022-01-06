import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/payments/bloc/payments_event.dart';
import 'package:spendy_re_work/presentation/journey/personal/payments/bloc/payments_state.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  PaymentsBloc()
      : super(
            PaymentsInitialState(indexInitSplashContent: 0, indexInitMoney: 0));

  @override
  Stream<PaymentsState> mapEventToState(PaymentsEvent event) async* {
    if (event is InitialPaymentsEvent) {
      yield* _mapInitialPaymentsEventEventToState(event);
    }
    if (event is ChangeContentEvent) {
      yield* _mapChangeContentEventToState(event);
    }
    if (event is ChangePaymentsMoneyEvent) {
      yield* _mapChangePaymentsMoneyEventToState(event);
    }
  }

  Stream<PaymentsState> _mapInitialPaymentsEventEventToState(
      InitialPaymentsEvent event) async* {
    yield PaymentsInitialState(indexInitMoney: 0, indexInitSplashContent: 0);
  }

  Stream<PaymentsState> _mapChangeContentEventToState(
      ChangeContentEvent event) async* {
    yield PaymentsChangeSplashContentState(
        indexSplashContent: event.indexInitSplashContent);
  }

  Stream<PaymentsState> _mapChangePaymentsMoneyEventToState(
      ChangePaymentsMoneyEvent event) async* {
    yield PaymentsChangeMoneyState(indexMoney: event.indexMoney);
  }
}
