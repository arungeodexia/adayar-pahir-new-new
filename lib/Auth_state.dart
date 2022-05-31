part of 'Auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoadInProgress extends AuthState {}

class AuthLoadSuccess extends AuthState {
  final bool AuthCheck;

  const AuthLoadSuccess({required this.AuthCheck}) : assert(AuthCheck != null);

  @override
  List<Object> get props => [AuthCheck];
}

class AuthLoadFailure extends AuthState {}