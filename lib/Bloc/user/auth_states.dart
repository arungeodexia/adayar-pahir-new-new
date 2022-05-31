import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {

  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationSignUpSelected extends AuthenticationState {}

class AuthenticationSignInSelected extends AuthenticationState {}

class AuthenticationMobileNoProvided extends AuthenticationState {
  final String mobileNo;
  final String countryCode;
  AuthenticationMobileNoProvided(this.mobileNo, this.countryCode);

}

class AuthenticationLoggedIn extends AuthenticationState{}

class AuthenticationIsLoggedIn extends AuthenticationState{}