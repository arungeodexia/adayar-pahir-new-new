import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ACI/Bloc/user/user_repository.dart';
import 'package:ACI/Model/create_edit_profile_model.dart';
import 'package:ACI/Model/device_info_model.dart';
import 'package:ACI/data/api/repository/ProfileRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../device_info.dart';
import 'api_intercepter.dart';

class LoginRepo{
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  var _dio = Dio();
  String fcmToken = "";
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);
  Future<int> askForOTP(
      {required String countryCode, required String phoneNo}) async {
    http.Response res =await  client.post(Uri.parse('${AppStrings.BASE_URL}api/v1/user/$countryCode/$phoneNo/otp/?authKey='+'Rrw4-fZkfFa-C9GvfA-cmZheX-PaCRzA-Lz7a'),  body: "{\"app_uuid\":\"asdasdasd\"}");
    print(res.body.toString());
    // final ress=dio.post('${AppStrings.BASE_URL}api/v1/user/$countryCode/$phoneNo/otp/?authKey='+'Rrw4-fZkfFa-C9GvfA-cmZheX-PaCRzA-Lz7a');
    // print(ress.toString());
    return 200;
  }
  Future<int> verifyOTP({required String countryCode, required String phoneNo, required String otp}) async {


    final response = await client.post(
        Uri.parse('${AppStrings.BASE_URL}api/v1/user/$countryCode/$phoneNo/otp/$otp'),
        body: '{}');


    // var res=dio.post('${AppStrings.BASE_URL}api/v1/user/$countryCode/$phoneNo/otp/$otp');
    // print(response.body.toString());
    print(response.headers);
    log(response.headers.toString());

    int value=0;

    if (response.statusCode == 200) {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(IS_MOBILE_NO_VERIFIED, true);
      // await prefs.setString(
      //     MOBILE_NO_VERIFIED_JSON_DATA, response.body.toString());
      prefs.setString(
          MOBILE_NO_VERIFIED_JSON_DATA, utf8.decode(response.bodyBytes));
      await prefs.setString(USER_COUNTRY_CODE, countryCode);
      await prefs.setString(USER_MOBILE_NUMBER, phoneNo);
      log(response.body.toString());


      CreateEditProfileModel createEditProfileModel;
      createEditProfileModel = CreateEditProfileModel.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
      await prefs.setString( "accessToken",createEditProfileModel.accessToken!);
      await prefs.setString("userFingerprintHash", createEditProfileModel.userFingerprintHash!);


      //print("verifyOtp UserRepos request :==>"+response.request.toString());
      // print("verifyOtp UserRepos Response :==>"+response.body.toString());
      print("verifyOtp UserRepos Response accessToken :==>"+createEditProfileModel.accessToken.toString());
      print("verifyOtp UserRepos Response accessToken :==>"+createEditProfileModel.userFingerprintHash.toString());

      requestHeaders = {
        'Content-type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        "Access-Control-Expose-Headers": "*",
        'appcode': '700000',
        'licensekey': '33783ui7-hepf-3698-tbk9-so69eq185173',

        'Authorization': "Bearer " +createEditProfileModel.accessToken!,
        'userFingerprintHash': createEditProfileModel.userFingerprintHash!
      };
      globalCountryCode=countryCode;
      globalPhoneNo=phoneNo;

      if (createEditProfileModel.firstName != null) {
        value=1;
        prefs.setBool(IS_LOGGED_IN, true);
        await prefs.setString("name", createEditProfileModel.firstName!);
        ProfileRepo repository=ProfileRepo();
        repository.getProfile();
      } else {
        value=2;
      }


      //Send device information.
      try{



        if(!kIsWeb){
        firebaseCloudMessagingListeners();
        }
        try {
          fcmToken=(await firebaseMessaging.getToken())!;
          firebaseMessaging.getToken().then((token) {
            //print("User Repository FCM Token:${token}");
            fcmToken = token.toString();
          });
        } on Exception catch (e) {
          // TODO
        }

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
          print(packageInfo.toString());

          
          SharedPreferences prefs2 = await SharedPreferences.getInstance();
          if (fcmToken.isEmpty) {
            fcmToken = prefs2.getString(FCM_KEY) ?? "";
          }
          print(fcmToken);
          DeviceInfoModel deviceInfoModel=new DeviceInfoModel(accessToken: createEditProfileModel.accessToken.toString().trim(), appId: "", appName: packageInfo.appName.toString(), appVersion: packageInfo.version.toString(), buildNumber: packageInfo.buildNumber.toString(), deviceToken: fcmToken, imeiNumber: "imeiNumber", osName: !kIsWeb?Platform.operatingSystem.toString().trim():"Web", osVersion: !kIsWeb?Platform.operatingSystemVersion.toString().trim():"Web", userFingerprintHash: createEditProfileModel.userFingerprintHash.toString().trim());
          final bool isDeviceInfoSent = await sendDeviceInfo(deviceInfoModel,createEditProfileModel.accessToken,createEditProfileModel.userFingerprintHash);


      }on Exception catch (e){
        //print("Exception :==>"+e.toString());
      }

    }

    return value;
  }


  Future<bool> sendDeviceInfo( DeviceInfoModel deviceInfoModel, String? accessToken,String? user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String countryCode = prefs.getString(USER_COUNTRY_CODE) ?? "";
    String mobileNo = prefs.getString(USER_MOBILE_NUMBER) ?? "";

    final response = await client.post(Uri.parse('${AppStrings.BASE_URL}api/v1/user/device/${countryCode}/${mobileNo}'),

        body: jsonEncode(deviceInfoModel));
    // final res=dio.post('${AppStrings.BASE_URL}api/v1/user/device/${countryCode}/${mobileNo}',data: requestHeadersnew);
    // print(res.toString());
    print("SendDeviceInfo UserRepos request :==>"+response.request.toString());
    print("SendDeviceInfo UserRepos Response :==>"+response.body.toString());
    if (response.statusCode == 200){


      DeviceInfo   resDeviceInfoModel =
      DeviceInfo.fromJson(json.decode(utf8.decode(response.bodyBytes)));


      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(APP_NAME, resDeviceInfoModel.appName ?? "");
      await prefs.setString(APP_VERSION, resDeviceInfoModel.appVersion?? "");
      await prefs.setString(BUILD_NUMBER, resDeviceInfoModel.buildNumber?? "");
      await prefs.setString(OS_NAME, resDeviceInfoModel.osName?? "");
      await prefs.setString(OS_VERSION, resDeviceInfoModel.osVersion?? "");
      await prefs.setString(FCM_TOKEN, resDeviceInfoModel.deviceToken?? "");


      //SharedPreferences prefs = await SharedPreferences.getInstance();
      // String prefAppName = prefs.getString(APP_NAME) ?? "";
      // String prefAppVersion = prefs.getString(APP_VERSION) ?? "";
      // String prefBuildNumber = prefs.getString(BUILD_NUMBER) ?? "";
      // String prefOSName = prefs.getString(OS_NAME) ?? "";
      // String prefOSVersion = prefs.getString(OS_VERSION) ?? "";
      // String prefDeviceToken = prefs.getString(FCM_TOKEN) ?? "";

      // print("RESPONSE Pref Details In USER_REPO :==>"+prefAppName+","+prefAppVersion+","+prefBuildNumber+","+prefOSName+","+prefOSVersion);//+","+prefDeviceToken
      // toastMessage("RESPONSE Pref Details In USER_REPO :==>"+prefAppName+","+prefAppVersion+","+prefBuildNumber+","+prefOSName+","+prefOSVersion);//+","+prefDeviceToken


      return true;
    }
    else
      return false;
  }
  Future<bool> sendDeviceInfoVersion(String version) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String countryCode = prefs.getString(USER_COUNTRY_CODE) ?? "";
    String mobileNo = prefs.getString(USER_MOBILE_NUMBER) ?? "";

    final response = await client.post(Uri.parse('${AppStrings.BASE_URL}api/v2/user/${countryCode}/${mobileNo}/appVersion/${version}'),);
    // final res=dio.post('${AppStrings.BASE_URL}api/v1/user/device/${countryCode}/${mobileNo}',data: requestHeadersnew);
    // print(res.toString());
    print("SendDeviceInfo UserRepos request :==>"+response.request.toString());
    print("SendDeviceInfo UserRepos Response :==>"+response.body.toString());
    print("SendDeviceInfo UserRepos Response :==>"+response.statusCode.toString());
    if (response.statusCode == 200){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(APP_VERSION, version??'');


      //SharedPreferences prefs = await SharedPreferences.getInstance();
      // String prefAppName = prefs.getString(APP_NAME) ?? "";
      // String prefAppVersion = prefs.getString(APP_VERSION) ?? "";
      // String prefBuildNumber = prefs.getString(BUILD_NUMBER) ?? "";
      // String prefOSName = prefs.getString(OS_NAME) ?? "";
      // String prefOSVersion = prefs.getString(OS_VERSION) ?? "";
      // String prefDeviceToken = prefs.getString(FCM_TOKEN) ?? "";

      // print("RESPONSE Pref Details In USER_REPO :==>"+prefAppName+","+prefAppVersion+","+prefBuildNumber+","+prefOSName+","+prefOSVersion);//+","+prefDeviceToken
      // toastMessage("RESPONSE Pref Details In USER_REPO :==>"+prefAppName+","+prefAppVersion+","+prefBuildNumber+","+prefOSName+","+prefOSVersion);//+","+prefDeviceToken


      return true;
    }
    else
      return false;
  }

  void firebaseCloudMessagingListeners() async{

  iOSPermission();

  }
  void iOSPermission() {
    if (Platform.isIOS) {
      firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
  }

}