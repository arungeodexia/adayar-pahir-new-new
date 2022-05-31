import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ACI/Model/create_edit_profile_model.dart';
import 'package:ACI/Model/device_info_model.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import '../../device_info.dart';
import 'api_intercepter.dart';

class ProfileRepo {
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);
  Future<http.Response?> createProfile(String filePath,
      {required CreateEditProfileModel createEditProfileModel}) async {
    try {
      log(createEditProfileModel.toJson().toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();


      http.Response response1 = await client.put(
          Uri.parse('${AppStrings.BASE_URL}api/v1/user'),

          body: jsonEncode(createEditProfileModel));
      log(response1.body);
      if (response1.statusCode == 200) await prefs.setBool(IS_LOGGED_IN, true);
      await prefs.setString("name", createEditProfileModel.firstName!);
      prefs.setString(MOBILE_NO_VERIFIED_JSON_DATA, utf8.decode(response1.bodyBytes));

      if (filePath != "") {
        var postUri = Uri.parse(
            '${AppStrings.BASE_URL}api/v1/user/${globalCountryCode}/${globalPhoneNo}/picture');

        File imageFile = File(filePath);
        print(await imageFile.length());
        var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
        // get file length
        var length = await imageFile.length();
        // create multipart request
        var request = new http.MultipartRequest("PUT", postUri);

        // multipart that takes file
        var multipartFile = new http.MultipartFile('picture', stream, length,
            filename: basename(imageFile.path));

        // add file to multipart
        request.files.add(multipartFile);

        // send

        var at =  prefs.getString( "accessToken");
        var uph =  prefs.getString( "userFingerprintHash");

        if (at != null) {
          request.headers["Authorization"] = "Bearer " + at;
          request.headers["userFingerprintHash"] = uph!;
          request.headers["appcode"] = "100000";
          request.headers["licensekey"] =
          "33783ui7-hepf-3698-tbk9-so69eq185173";
        }
        var response = await request.send();

        print(response.statusCode);

        if (response.statusCode == 200) {
          List<int> imageBytes = File(filePath).readAsBytesSync();

          String base64Image = base64Encode(imageBytes);

          prefs.setString(USER_PROFILE_IMAGE_64, base64Image);
        }
        try {
          http.Response responseold = await client.get(
            Uri.parse(
                '${AppStrings.BASE_URL}api/v1/user/${globalCountryCode}/${globalPhoneNo}'),
          );
          log(responseold.body);
          CreateEditProfileModel profileModel = CreateEditProfileModel.fromJson(
              json.decode(utf8.decode(responseold.bodyBytes)));
          createEditProfileModel.profilePicture =
              profileModel.profilePicture.toString();
        } on Exception catch (e) {
          // TODO
        }
      }

      await getProfile();
      return response1;
    } on SocketException {
      return null;
    }
  }

  Future<http.Response?> getProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      http.Response response = await client.get(
          Uri.parse(
              '${AppStrings.BASE_URL}api/v2/user/${globalCountryCode}/${globalPhoneNo}'),
           );
      print(response.body);
      print(response.request!.headers);
      log(response.request!.url.toString());
      CreateEditProfileModel profileModel = CreateEditProfileModel.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
      if (response.statusCode == 200) {
        await prefs.setBool(IS_LOGGED_IN, true);
        prefs.setString(MOBILE_NO_VERIFIED_JSON_DATA, utf8.decode(response.bodyBytes));
      }
      return response;
    } on SocketException {
      return null;
    }
  }
}
