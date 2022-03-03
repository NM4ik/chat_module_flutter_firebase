part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticatedStarted extends AuthEvent{
  @override
  String toString() => 'AppStarted';
}

class AuthenticationLoggedIn extends AuthEvent{
  @override
  String toString() => 'LoggedIn';
}

class AuthenticationLoggedOut extends AuthEvent{
  @override
  String toString() => 'LoggedOut';
}

class AuthenticatedError extends AuthEvent{}
