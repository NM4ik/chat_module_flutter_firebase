part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent{
  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthEvent{
  @override
  String toString() => 'LoggedIn';
}

class LoggedOut extends AuthEvent{
  @override
  String toString() => 'LoggedOut';
}
