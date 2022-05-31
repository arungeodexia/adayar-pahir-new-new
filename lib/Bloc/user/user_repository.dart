import 'dart:convert';
import 'dart:io';
//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:meta/meta.dart';
import 'package:ACI/data/api/repository/api_intercepter.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserRepository {
  // Create storage
  String fcmToken = "";

  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);
  Future<String> authenticate({required String token}) async {
    await Future.delayed(Duration(seconds: 1));
    return 'token';
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(IS_LOGGED_IN) ?? false) {
      final response = await client.get(
          Uri.parse('${AppStrings.BASE_URL}api/v1/user/${prefs.getString(USER_COUNTRY_CODE) ?? ""}/${prefs.getString(USER_MOBILE_NUMBER) ?? ""}'),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      if (response.statusCode == 200)
        return true;
      else {
        prefs.setBool(IS_MOBILE_NO_VERIFIED, false);
        prefs.setBool(IS_LOGGED_IN, false);
        prefs.setString(MOBILE_NO_VERIFIED_JSON_DATA, "");
        prefs.setString(USER_PROFILE_IMAGE_64, "");
        prefs.setString(USER_COUNTRY_CODE, "");
        prefs.setString(USER_MOBILE_NUMBER, "");
        return false;
      }

      //return true;
    } else {
      return false;
    }
  }

  Future<bool> isMobileNumberVerified() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(IS_MOBILE_NO_VERIFIED) ?? false) {
      final response = await client.get(
          Uri.parse('${AppStrings.BASE_URL}api/v1/user/${prefs.getString(USER_COUNTRY_CODE) ?? ""}/${prefs.getString(USER_MOBILE_NUMBER) ?? ""}'),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      if (response.statusCode == 200)
        return true;
      else {
        prefs.setBool(IS_MOBILE_NO_VERIFIED, false);
        prefs.setBool(IS_LOGGED_IN, false);
        prefs.setString(MOBILE_NO_VERIFIED_JSON_DATA, "");
        prefs.setString(USER_PROFILE_IMAGE_64, "");
        prefs.setString(USER_COUNTRY_CODE, "");
        prefs.setString(USER_MOBILE_NUMBER, "");
        return false;
      }
      //return true;
    } else
      return false;
  }


  // Future<GeneralStatus> verifyOtp(
  //     {required OtpVerifyRequest otpVerifyRequest,DeviceInfoModel deviceInfoModel}) async {
  //   GeneralStatus generalStatus = GeneralStatus();
  //
  //   final response = await client.post(
  //       '${AppStrings.BASE_URL}api/v1/user/${otpVerifyRequest.countryCode}/${otpVerifyRequest.mobileNumber}/otp/${otpVerifyRequest.otp}',
  //       headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  //       body: '{}');
  //
  //   generalStatus.statuscode = response.statusCode;
  //   if (response.statusCode == 200) {
  //
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setBool(IS_MOBILE_NO_VERIFIED, true);
  //     await prefs.setString(
  //         MOBILE_NO_VERIFIED_JSON_DATA, response.body.toString());
  //     await prefs.setString(USER_COUNTRY_CODE, otpVerifyRequest.countryCode);
  //     await prefs.setString(USER_MOBILE_NUMBER, otpVerifyRequest.mobileNumber);
  //
  //
  //     CreateEditProfileModel createEditProfileModel;
  //     createEditProfileModel = CreateEditProfileModel.fromJson(
  //         json.decode(utf8.decode(response.bodyBytes)));
  //     await storage.write(key: "accessToken",value: createEditProfileModel.accessToken);
  //     await storage.write(key: "userFingerprintHash", value: createEditProfileModel.userFingerprintHash);
  //
  //
  //
  //       //print("verifyOtp UserRepos request :==>"+response.request.toString());
  //      // print("verifyOtp UserRepos Response :==>"+response.body.toString());
  //       //print("verifyOtp UserRepos Response accessToken :==>"+createEditProfileModel.accessToken.toString());
  //
  //
  //     if (createEditProfileModel.firstName != null) {
  //       generalStatus.statusdata = "true";
  //       prefs.setBool(IS_LOGGED_IN, true);
  //       if (createEditProfileModel.profilePicture != null) {
  //         final response = await client.get(
  //             '${AppStrings.BASE_URL}api/v1/user/${otpVerifyRequest.countryCode}/${otpVerifyRequest.mobileNumber}/picture',
  //             headers: {HttpHeaders.contentTypeHeader: 'image/jpeg'});
  //
  //         createEditProfileModel.profilePicture =
  //             base64Encode(response.bodyBytes);
  //         if (response.statusCode == 200) {
  //           String base64Image = createEditProfileModel.profilePicture;
  //           SharedPreferences prefs = await SharedPreferences.getInstance();
  //           prefs.setString(USER_PROFILE_IMAGE_64, base64Image);
  //         }
  //       }
  //     } else {
  //       generalStatus.statusdata = "false";
  //     }
  //
  //
  //     //Send device information.
  //     try{
  //
  //
  //
  //     PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //       DeviceInfoModel deviceInfoModel = new DeviceInfoModel();
  //        deviceInfoModel.appName = packageInfo.appName.toString();
  //       deviceInfoModel.appVersion = packageInfo.version.toString();
  //       deviceInfoModel.buildNumber = packageInfo.buildNumber.toString();
  //       deviceInfoModel.osName = Platform.operatingSystem.toString().trim();
  //       deviceInfoModel.osVersion = Platform.operatingSystemVersion.toString().trim();
  //
  //       SharedPreferences prefs2 = await SharedPreferences.getInstance();
  //       if(fcmToken.isEmpty){
  //          fcmToken = prefs2.getString(FCM_KEY) ?? "";
  //       }
  //       deviceInfoModel.deviceToken = fcmToken;
  //
  //       SharedPreferences prefs1 = await SharedPreferences.getInstance();
  //       String prefAppName = prefs1.getString(APP_NAME) ?? "";
  //       String prefAppVersion = prefs1.getString(APP_VERSION) ?? "";
  //       String prefBuildNumber = prefs1.getString(BUILD_NUMBER) ?? "";
  //       String prefOSName = prefs1.getString(OS_NAME) ?? "";
  //       String prefOSVersion = prefs1.getString(OS_VERSION) ?? "";
  //       String prefDeviceToken = prefs.getString(FCM_TOKEN) ?? "";
  //
  //      // print("Pref Details In USER REPOS :==>"+prefAppName+","+prefAppVersion+","+prefBuildNumber+","+prefOSName+","+prefOSVersion+","+prefDeviceToken);
  //       //toastMessage("Pref Details USER REPOS :==>"+prefAppName+","+prefAppVersion+","+prefBuildNumber+","+prefOSName+","+prefOSVersion+","+prefDeviceToken);
  //
  //        if(prefAppName != deviceInfoModel.appName || prefAppVersion != deviceInfoModel.appVersion
  //        || prefBuildNumber != deviceInfoModel.buildNumber|| prefOSName != deviceInfoModel.osName
  //         || prefOSVersion != deviceInfoModel.osVersion|| prefDeviceToken != deviceInfoModel.deviceToken){
  //         // final bool isDeviceInfoSent = await sendDeviceInfo(deviceInfoModel);
  //        }
  //
  //       }on Exception catch (e){
  //         //print("Exception :==>"+e.toString());
  //     }
  //
  //   }
  //   return generalStatus;
  // }



//New Changes

  // Future<bool> sendDeviceInfo( DeviceInfoModel deviceInfoModel) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String countryCode = prefs.getString(USER_COUNTRY_CODE) ?? "";
  //   String mobileNo = prefs.getString(USER_MOBILE_NUMBER) ?? "";
  //  // print("SendDeviceInfo UserRepos countryCode,mobileNo :==>"+countryCode+","+mobileNo);
  //   final response = await client.post('${AppStrings.BASE_URL}api/v1/user/device/${countryCode}/${mobileNo}',
  //       headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  //       body: jsonEncode(deviceInfoModel));
  //
  //      // print("SendDeviceInfo UserRepos request :==>"+response.request.toString());
  //      // print("SendDeviceInfo UserRepos Response :==>"+response.body.toString());
  //   if (response.statusCode == 200){
  //
  //
  //       DeviceInfoModel   resDeviceInfoModel =
  //         DeviceInfoModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  //
  //
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setString(APP_NAME, resDeviceInfoModel.appName ?? "");
  //     await prefs.setString(APP_VERSION, resDeviceInfoModel.appVersion?? "");
  //     await prefs.setString(BUILD_NUMBER, resDeviceInfoModel.buildNumber?? "");
  //     await prefs.setString(OS_NAME, resDeviceInfoModel.osName?? "");
  //     await prefs.setString(OS_VERSION, resDeviceInfoModel.osVersion?? "");
  //     await prefs.setString(FCM_TOKEN, resDeviceInfoModel.deviceToken?? "");
  //
  //
  //     //SharedPreferences prefs = await SharedPreferences.getInstance();
  //       // String prefAppName = prefs.getString(APP_NAME) ?? "";
  //       // String prefAppVersion = prefs.getString(APP_VERSION) ?? "";
  //       // String prefBuildNumber = prefs.getString(BUILD_NUMBER) ?? "";
  //       // String prefOSName = prefs.getString(OS_NAME) ?? "";
  //       // String prefOSVersion = prefs.getString(OS_VERSION) ?? "";
  //       // String prefDeviceToken = prefs.getString(FCM_TOKEN) ?? "";
  //
  //       // print("RESPONSE Pref Details In USER_REPO :==>"+prefAppName+","+prefAppVersion+","+prefBuildNumber+","+prefOSName+","+prefOSVersion);//+","+prefDeviceToken
  //       // toastMessage("RESPONSE Pref Details In USER_REPO :==>"+prefAppName+","+prefAppVersion+","+prefBuildNumber+","+prefOSName+","+prefOSVersion);//+","+prefDeviceToken
  //
  //
  //   return true;
  //   }
  //   else
  //   return false;
  // }


   void toastMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }


}

