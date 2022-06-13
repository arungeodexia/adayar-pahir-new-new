import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:ACI/Screen/login_init_view.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiInterceptor implements InterceptorContract {
// Create storage

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    data.headers["appcode"] = "100000";
    data.headers["licensekey"] = "33783ui7-hepf-3698-tbk9-so69eq185173";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accesstoken= prefs.getString("accessToken");
      String? userFingerprintHash= prefs.getString("userFingerprintHash");
      String? pahirAuthHeader= prefs.getString("pahirAuthHeader");
      String? language= prefs.getString("locale");
      if(language.toString() == 'null' || language == "en"){
        language="en";
      }else{
        language="ta";
      }
      print(language);
      var at = accesstoken;
      var uph = userFingerprintHash;
      if (at != null) {
        data.headers["Authorization"] = "Bearer " + at;
        data.headers["userFingerprintHash"] = uph!;
        data.headers["Content-Type"] = "application/json";
        data.headers["Access-Control-Expose-Headers"]= "*";
        data.headers["Accept-Language"]= language;
        if(kIsWeb){
          data.headers["pahiruserauth"]= pahirAuthHeader!;
        }
      }
    } on Exception catch (e) {
      // TODO
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print(data.request!.url.toString());
    print(data.body);
    print(data.statusCode);
   if (kIsWeb) {
     if (data.statusCode==200) {
      try{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var resourceDetailsResponse = json.decode(data.body.toString());
        String pahirAuthHeader = resourceDetailsResponse['pahirAuthHeader'];
        prefs.setString("pahirAuthHeader", pahirAuthHeader);
        log(pahirAuthHeader.toString());
      }catch(e){
        log(e.toString());
      }
     }else if (data.statusCode==401) {
       Fluttertoast.showToast(msg: "401");
       SharedPreferences prefs =
       await SharedPreferences.getInstance();
       prefs.setBool(IS_LOGGED_IN, false);
       await prefs.clear();
       Navigator.pushAndRemoveUntil(
           globalcontext!, _dashBoardRoute, (Route<dynamic> r) => false);

     }
   }
    return data;
  }
  final PageRouteBuilder _dashBoardRoute = new PageRouteBuilder(
    pageBuilder: (BuildContext context, _, __) {
      return LoginInitView();
    },
  );
}
