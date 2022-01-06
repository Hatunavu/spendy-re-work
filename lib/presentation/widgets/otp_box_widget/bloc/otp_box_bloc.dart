import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'otp_box_event.dart';

part 'otp_box_state.dart';

class OtpBoxBloc extends Bloc<OtpBoxEvent, OtpBoxState> {
  OtpBoxBloc() : super(OtpBoxInitial());

  @override
  Stream<OtpBoxState> mapEventToState(
    OtpBoxEvent event,
  ) async* {
    if (event is OtpVerifyFailedEvent) {
      yield OtpBoxVerifyFailed();
    }
  }
}
