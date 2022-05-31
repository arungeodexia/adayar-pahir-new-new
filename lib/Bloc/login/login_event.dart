part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  List<Object> get props => [];

}
class Login extends LoginEvent{
  final String mobile;
  final String countrycode;
  Login(this.mobile, this.countrycode);
  @override
  List<Object> get props => [mobile,countrycode];

}
class OTPVerify extends LoginEvent{
  final String phoneno;
  final String countrycode;
  final String otp;
  OTPVerify(this.phoneno, this.countrycode, this.otp);
  @override
  List<Object> get props => [phoneno,countrycode,otp];

}
