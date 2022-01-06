part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class VerifyPhoneSuccess extends LoginState {
  final String? verificationId;
  final String? phone;
  final String? phoneCode;

  final bool _current;

  VerifyPhoneSuccess(this.verificationId, this.phone, this.phoneCode,
      [this._current = true]);

  VerifyPhoneSuccess copyWith(
    String? id,
    String? phone,
    String? phoneCode,
  ) {
    return VerifyPhoneSuccess(id ?? verificationId, phone ?? this.phone,
        phoneCode ?? this.phoneCode, !_current);
  }

  @override
  List<Object?> get props => [verificationId, phone, phoneCode, _current];
}

class VerifyPhoneFailed extends LoginState {
  final Exception exception;

  VerifyPhoneFailed({required this.exception});

  @override
  List<Object> get props => [];
}

class LoginNoInternetState extends LoginState {
  @override
  List<Object> get props => [];
}
