part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
}

class AuthenticatedStarted extends AuthEvent {
  @override
  String toString() => 'AppStarted';

  @override
  List<Object> get props => [];
}

class AuthenticationLoggedIn extends AuthEvent {
  @override
  String toString() => 'LoggedIn';

  @override
  List<Object> get props => [];
}

class AuthenticationLoggedOut extends AuthEvent {
  @override
  String toString() => 'LoggedOut';

  @override
  List<Object> get props => [];
}

// class AuthenticatedError extends AuthEvent {}
