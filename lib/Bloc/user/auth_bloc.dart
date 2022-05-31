import 'dart:async';
import 'dart:io';
//import 'dart:js';

import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:meta/meta.dart';
import 'package:ACI/Bloc/user/user_repository.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_events.dart';
import 'auth_states.dart';


class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  String fcmToken = "";
  AuthenticationBloc({required this.userRepository})
      : super(AuthenticationUninitialized());

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    
    if (event is AppStarted) {
      final bool isLoggedIn = await userRepository.hasToken();
      final bool isMobileNumberVerified = await userRepository.isMobileNumberVerified();
      if (isLoggedIn) {      
        if(isMobileNumberVerified){
        }
        yield AuthenticationIsLoggedIn();

      } else {
        if(isMobileNumberVerified){
          yield AuthenticationAuthenticated();
        }
          else
          yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepository.persistToken(event.token);
      yield AuthenticationAuthenticated();
    }

    if (event is SignUp) {
      yield AuthenticationSignUpSelected();
    }
    if (event is SignUpMobileNo) {
   /*  bool response =  await userRepository.askForOTP(countryCode:event.countryCode, phoneNo:event.phoneNo);
     if(response)*/
   //print(event.phoneNo);
      yield AuthenticationMobileNoProvided(event.phoneNo,event.countryCode);


    }
    if (event is SignIn) {
      yield AuthenticationSignInSelected();
    }
    if(event is SignInLogin)
      {
        yield AuthenticationLoggedIn();
      }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }


   void toastMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }



   Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(FCM_KEY, token);
  }
  
}

