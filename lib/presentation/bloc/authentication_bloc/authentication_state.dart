part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

// when nothing is initialized
class Uninitialized extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationLoading extends AuthenticationState {
  @override
  List<Object> get props => [];
}

// the there is a valid token
class Authenticated extends AuthenticationState {
  final String uid;

  Authenticated({required this.uid});

  @override
  List<Object> get props => [uid];
}

// when the app has not got a valid token
class UnAuthenticated extends AuthenticationState {
  final String nextRoute;

  UnAuthenticated({required this.nextRoute});

  @override
  List<Object> get props => [nextRoute];
}

class AuthenticatedFailed extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class VerifiedPinAuthenticateState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class InitAuthenticatePIN extends AuthenticationState {
  final String uid;

  InitAuthenticatePIN({required this.uid});

  @override
  List<Object> get props => [uid];
}

//class LoggedOutToPinState extends AuthenticationState {
//  @override
//  List<Object> get props => [];
//
//}
