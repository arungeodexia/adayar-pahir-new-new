import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ACI/data/api/repository/LoginRepo.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is Login) {
      emit( OTPVerifyLoading());
      LoginRepo loginRepo = LoginRepo();
      var res = await loginRepo.askForOTP(countryCode: event.countrycode, phoneNo: event.mobile);
      yield LoginSuccess(res);
    }else if (event is OTPVerify) {
      LoginRepo loginRepo = LoginRepo();
      yield OTPVerifyLoading();
      int res = await loginRepo.verifyOTP(countryCode: event.countrycode, phoneNo: event.phoneno,otp: event.otp);
      if (res!=0) {
        yield OTPVerifySuccess(res);
      }  else{
        yield OTPVerifyFailure(res);
      }

    }
  }
}
