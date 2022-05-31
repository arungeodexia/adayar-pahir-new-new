import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String token;

  const LoggedIn({required this.token});

  @override
  List<Object> get props => [token];

  @override
  String toString() => 'LoggedIn { token: $token }';
}

class SignUp extends AuthenticationEvent {}

class SignInLogin extends AuthenticationEvent{}

class SignUpMobileNo extends AuthenticationEvent {
  final String phoneNo;
  final String countryCode;

  const SignUpMobileNo({required this.countryCode,required this.phoneNo});

  @override
  List<Object> get props => [countryCode,phoneNo];

  @override
  String toString() => 'MobileNoEntered { countryCode: $countryCode, phoneNo:$phoneNo }';
}

class SignIn extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}