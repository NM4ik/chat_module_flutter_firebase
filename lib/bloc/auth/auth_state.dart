part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {}

class Uninitialized extends AuthState {
  @override
  String toString() => 'Uninitialized';

  @override
  List<Object> get props => [];
}

class Authenticated extends AuthState {
  final UserCredential user;

  Authenticated(this.user);

  @override
  String toString() => 'Authenticated { displayName: ${user.user!.email} }';

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {
  @override
  String toString() => 'Unauthenticated';

  @override
  List<Object> get props => [];
}
