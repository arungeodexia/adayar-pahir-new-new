import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:ACI/Model/create_edit_profile_model.dart';
import 'package:ACI/Model/phone_contact_model.dart';
import 'package:ACI/data/api/repository/api_intercepter.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<int> uploadContactsnew(
    {List<PhoneContactModel>? phoneContactList}) async {
  String jsonArray =
      jsonEncode(phoneContactList!.map((e) => e.toJson()).toList());

  //  final stopwatch = Stopwatch()..start();
  // var startTimeNow = new DateTime.now();
  // print(new DateFormat("H:m:s").format(startTimeNow));
  // showToastMessage("UploadContacts startTimeNow Now :==>"+startTimeNow.toString());

  // for(int arrIndx = 0;arrIndx < phoneContactList.length;arrIndx++){
  //  showToastMessage("Uploading contact value:==> "+"Country code: "+phoneContactList[arrIndx].countryCode+"Mobile no :==>"+phoneContactList[arrIndx].mobileNumber);
  // }
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);

  final response = await client.post(
      Uri.parse('${AppStrings.BASE_URL}api/v1/user/${globalUserId}/contacts'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonArray);

  //   var endTimeNow = new DateTime.now();
  //     print(new DateFormat("H:m:s").format(endTimeNow));
  // showToastMessage("UploadContacts EndTime Now :==>"+endTimeNow.toString());

  //  showToastMessage("statusCode :==>"+response.statusCode.toString());

  // print('API executed in : ${stopwatch.elapsed}');

  // showToastMessage("UploadContacts API execution time :==>"+stopwatch.elapsed.toString());

  return response.statusCode;
}

Future<String> fileuploadchat({
  String? filePath,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String resource_id = "";

  if (filePath!.length > 0) {
    var postUri = Uri.parse(
        '${AppStrings.BASE_URL}api/v1/chat/file/${globalCountryCode}/${globalPhoneNo}/resource/${globalCountryCode}/${globalPhoneNo}');

    File imageFile = File(filePath);
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
      request.headers["licensekey"] = "33783ui7-hepf-3698-tbk9-so69eq185173";
    }
    var response = await request.send();

    //print(response.statusCode);

    if (response.statusCode == 200) {
      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = await String.fromCharCodes(responseData);
      print(responseString);

      print(responseString);
      final responseJson = await json.decode(responseString);
      resource_id = responseJson['message'];
    }
  }

  return resource_id;
}
Future<String> fileimageupload({
  String? filePath,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String resource_id = "";

  if (filePath!.length > 0) {

    var postUri = Uri.parse(
        '${AppStrings.BASE_URL}api/v1/chat/user/${globalCountryCode}/${globalPhoneNo}/file');

    File imageFile = File(filePath);
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
      request.headers["licensekey"] = "33783ui7-hepf-3698-tbk9-so69eq185173";
    }
    var response = await request.send();

    print(response.statusCode);
    print(response.request!.url);

    if (response.statusCode == 200) {
      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = await String.fromCharCodes(responseData);
      print(responseString);
      final responseJson = await json.decode(responseString);
      resource_id = responseJson['fileURL'];
    }
  }

  return resource_id;
}

Future<String> fileuploadgroup(
    {String? filePath,
    CreateEditProfileModel? createEditProfileModel,
    String? groupid}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? resource_id = "";

  if (filePath!.length > 0) {
    // var postUri = Uri.parse(
    //     '${AppStrings.BASE_URL}api/v1/chat/file/${globalCountryCode}/${globalPhoneNo}/resource/${globalCountryCode}/${globalPhoneNo}');
    var postUri = Uri.parse(
        '${AppStrings.BASE_URL}api/v1/group/member/${createEditProfileModel!.orgMemberId}/university/${createEditProfileModel.universityId}/group/$groupid/logo');

    print(postUri);
    File imageFile = File(filePath);
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
      request.headers["licensekey"] = "33783ui7-hepf-3698-tbk9-so69eq185173";
    }
    var response = await request.send();

    print(response.statusCode);

    if (response.statusCode == 200) {
      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = await String.fromCharCodes(responseData);
      print(responseString);

      final responseJson = await json.decode(responseString);
      if (responseJson['code'].toString() == "0") {
        resource_id = responseJson['message'].toString();
      } else {
        resource_id = "1";
      }
    }
  }

  return resource_id;
}

Future<String> fileuploadresource({
  String? filePath,
  String? resource_id1,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String resource_id = '';

  if (filePath!.length > 0) {
    var postUri = Uri.parse(
        '${AppStrings.BASE_URL}api/v1/user/${globalCountryCode}/${globalPhoneNo}/picture/$resource_id1');

    File imageFile = File(filePath);
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
      request.headers["licensekey"] = "33783ui7-hepf-3698-tbk9-so69eq185173";
    }
    var response = await request.send();

    //print(response.statusCode);

    if (response.statusCode == 200) {
      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = await String.fromCharCodes(responseData);
      print(responseString);

      print(responseString);
      final responseJson = await json.decode(responseString);
      resource_id = responseJson['message'];
    } else {
      print(response.statusCode);
    }
  }

  return resource_id;
}
