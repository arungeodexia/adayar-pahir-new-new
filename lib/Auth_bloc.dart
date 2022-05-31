import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/api/repository/LoginRepo.dart';
import 'data/sp/shared_keys.dart';


part 'Auth_event.dart';

part 'Auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());
  var dio = Dio();

  Future<Response> fetchAlbum() {
    return dio.post('${AppStrings.BASE_URL}api/v1/user/+91/8667236028/otp/958106');
  }
  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthRequested) {
      emit (AuthLoadInProgress());
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? accesstoken=await prefs.getString("accessToken");
        String? userFingerprintHash=await prefs.getString("userFingerprintHash");
        if (prefs.getBool(IS_LOGGED_IN) ?? false) {
          requestHeaders = {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'appcode': '700000',
            'licensekey': '33783ui7-hepf-3698-tbk9-so69eq185173',
            'Authorization': "Bearer " +accesstoken!,
            'userFingerprintHash': userFingerprintHash!

          };
          print(requestHeaders);
          globalCountryCode=await prefs.getString(USER_COUNTRY_CODE)??"";
          globalPhoneNo=await prefs.getString(USER_MOBILE_NUMBER)??"";
          emit( AuthLoadSuccess(AuthCheck: true));
        } else {
          emit (AuthLoadSuccess(AuthCheck: false));

        }



      } catch (_) {
        emit (AuthLoadFailure());
      }
    }
  }
}
