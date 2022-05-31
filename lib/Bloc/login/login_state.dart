part of 'login_bloc.dart';

abstract class LoginState extends Equatable {

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
}
class LoginSuccess extends LoginState {
  final int response;

  LoginSuccess(this.response);

}
class LoginFailure extends LoginState {
}
class OTPVerifySuccess extends LoginState {
   int response;

  OTPVerifySuccess(this.response);
   List<Object> get props => [this.response];

}
class OTPVerifyFailure extends LoginState {
   int response;
   OTPVerifyFailure(this.response);
}
class OTPVerifyLoading extends LoginState {
}
