import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:ACI/Bloc/message/message_model_class.dart';

import 'package:ACI/Model/AddUpdateReviewModel.dart';
import 'package:ACI/Model/AddUpdtReviewRespModel.dart';
import 'package:ACI/Model/ChannelModel.dart';
import 'package:ACI/Model/ChannelModel.dart';
import 'package:ACI/Model/ChannelModel.dart';
import 'package:ACI/Model/ContentModel.dart';
import 'package:ACI/Model/PrivacyModel.dart';
import 'package:ACI/Model/ResourceSearchNew.dart';
import 'package:ACI/Model/ResourceSearchNew.dart';
import 'package:ACI/Model/create_edit_profile_model.dart';
import 'package:ACI/Model/resources.dart';
import 'package:ACI/Model/skill_item.dart';
import 'package:ACI/data/api/repository/api_intercepter.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

class ResourceRepo {
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);
  Future<http.Response?> gethomedata() async {
    try {
      http.Response response = await client.get(
          Uri.parse(
              '${AppStrings.BASE_URL}api/v1/user/${globalCountryCode}/${globalPhoneNo}/resources'),
           );
      print(response.request!.headers.toString());
      return response;
    } on SocketException {
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<http.Response?> removeResource(Resources resourceModel) async {
    try {
      final response = await client.delete(
          Uri.parse(
              '${AppStrings.BASE_URL}api/v1/user/$globalCountryCode/$globalPhoneNo/resource/${resourceModel.id}'),
           );
      print(response);
      return response;
    } on SocketException {
      return null;
    }
  }

  Future<http.Response?> addreview(Resources resourceModel, String filePath,
      AddUpdateReviewModel addUpdateReviewModel) async {
    try {
      String resource_id = "";
      Resources resourceDetail;
      final response = await client.post(
          Uri.parse(
              '${AppStrings.BASE_URL}api/v1/user/$globalCountryCode/$globalPhoneNo/resources'),

          body: jsonEncode(resourceModel));
      print(response.body);
      if (response.statusCode == 200) {
        // print("Add Resource response :==>"+response.body.toString());

        final resourceCreationResponse =
            json.decode(utf8.decode(response.bodyBytes));

        resource_id = resourceCreationResponse['id'];
        if (filePath.length > 0) {
          String res = await fileuploadresource(
              filePath: filePath, resource_id1: resource_id);
          print(res);
        }

        try {
          resourceDetail =
              Resources.fromJson(json.decode(utf8.decode(response.bodyBytes)));

          if (resourceDetail != null) {
            //print("resourceDetail.id ==>"+resourceDetail.id);
            var res = await addORUpdateReview(
                addUpdateReviewModel, resourceDetail.id);
          }
        } on Exception catch (e) {
          //print("Exception :==>"+e.toString());
          return response;
        }
        return response;
      } else {
        return response;
      }
    } on SocketException {
      return null;
    }
  }
  Future<http.Response?> addreviewresource(ResourceResults resourceModel, String filePath,
      AddUpdateReviewModel addUpdateReviewModel) async {
    try {
      String resource_id = "";
      Resources resourceDetail;
      final response = await client.post(
          Uri.parse(
              '${AppStrings.BASE_URL}api/v1/user/$globalCountryCode/$globalPhoneNo/resources'),

          body: jsonEncode(resourceModel));
      print(response.body);
      print(response.statusCode);
      print(response.request!.url.toString());
      if (response.statusCode == 200) {
        // print("Add Resource response :==>"+response.body.toString());

        final resourceCreationResponse =
            json.decode(utf8.decode(response.bodyBytes));

        resource_id = resourceCreationResponse['id'];
        if (filePath.length > 0) {
          String res = await fileuploadresource(
              filePath: filePath, resource_id1: resource_id);
          print(res);
        }

        try {
          resourceDetail =
              Resources.fromJson(json.decode(utf8.decode(response.bodyBytes)));

          if (resourceDetail != null) {
            //print("resourceDetail.id ==>"+resourceDetail.id);
            var res = await addORUpdateReview(
                addUpdateReviewModel, resourceDetail.id);
          }
        } on Exception catch (e) {
          //print("Exception :==>"+e.toString());
          return response;
        }
        return response;
      } else {
        return response;
      }
    } on SocketException {
      return null;
    }
  }

  Future<AddUpdtReviewRespModel?> addORUpdateReview(
      AddUpdateReviewModel addUpdateReviewModel, String? resourceId) async {
    AddUpdtReviewRespModel? addUpdtReviewRespModel;
    ////api/v1/review/{resourceId}/{userId}
    final response = await client.put(
        Uri.parse(
            '${AppStrings.BASE_URL}api/v1/review/$resourceId/$globalUserId'),

        body: jsonEncode(addUpdateReviewModel));
    // print("AddUpdateReviewModel request :==>"+response.request.url.toString());
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      try {
        addUpdtReviewRespModel = AddUpdtReviewRespModel.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
        if (addUpdtReviewRespModel != null) {}
      } on Exception catch (e) {
        return null;
      }
      return addUpdtReviewRespModel;
    } else
      return null;
  }

  Future<String> fileuploadresource({
    String? filePath,
    String? resource_id1,
  }) async {
    try{
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

        print(response.statusCode);

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
    }catch(_){
      return "";

    }

  }

  Future<List<SkillItemModel>> getSkillList() async {
    late List<SkillItemModel> skillList;
    try {
      final response = await client.get(
          Uri.parse('${AppStrings.BASE_URL}api/v1/skills'),
           );

      skillList = (json.decode(utf8.decode(response.bodyBytes)) as List)
          .map((i) => SkillItemModel.fromJson(i))
          .toList();
      print(">>>${skillList.length}");
    } on Exception catch (e) {
      print(">>>${skillList.length}");
    }
    return skillList;
  }

  Future<http.Response?> fetchResourceData1(
      String resourceId, String resourceType) async {
    try {
      final response = await client.get(
          Uri.parse(
              '${AppStrings.BASE_URL}api/v2.5/user/${globalCountryCode}/${globalPhoneNo}/resource/${resourceId}?resourceType=${resourceType}'),
           );
      print(" fetchResourceData Request Url :==>" +
          response.request!.url.toString());
      print(" fetchResourceData Response data :==>" + response.body.toString());
      if (response.statusCode == 200) {
        return response;
      } else {
        return response;
      }
    } on SocketException {
      return null;
    } on Exception catch (e) {
      return null;
    }
  }
  Future<ContentModel?> uploadchannel(
      String channelId,ContentModel contentModelfrom) async {
    try {
      ContentModel contentModel=ContentModel();
      final response = await client.post(
          Uri.parse(
              "${AppStrings.BASE_URL}api/v1/user/content"),body: jsonEncode(contentModelfrom)
           );
      print(" fetchResourceData Request Url :==>" +
          response.request!.url.toString());
      print(" fetchResourceData Response data :==>" + response.body.toString());
      print(" fetchResourceData Response data :==>" + contentModelfrom.toJson().toString());
      if (response.statusCode == 200) {
        contentModel=ContentModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        return contentModel;
      } else {
        return contentModel;
      }
    } on SocketException {
      return null;
    } on Exception catch (e) {
      return null;
    }
  }
  Future<int?> deletecontent(String channelId) async {
    try {
      final response = await client.post(
          Uri.parse(
              "${AppStrings.BASE_URL}api/v1/user/content/$channelId/delete"),
           );
      print(" fetchResourceData Request Url :==>" +
          response.request!.url.toString());
      print(" fetchResourceData Response data :==>" + response.body.toString());
      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        return response.statusCode;;
      }
    } on SocketException {
      return null;
    } on Exception catch (e) {
      return null;
    }
  }
  Future<ChannelModel> getchannel(
      String orgid) async {
    ChannelModel channelmodel=ChannelModel();
    try {
      final response = await client.get(
          Uri.parse("${AppStrings.BASE_URL}api/v1/user/channels/org/$orgid"));
      print(" fetchResourceData Request Url :==>" +
          response.request!.url.toString());
      print(" fetchResourceData Response data :==>" + response.body.toString());
      if (response.statusCode == 200) {
        channelmodel=ChannelModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        return channelmodel;
      } else {
        return channelmodel;
      }
    } on SocketException {
      return channelmodel;
    } on Exception catch (e) {
      return channelmodel;
    }
  }

  Future<int> upload(File imageFile,String channelid,String contentid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse("${AppStrings.BASE_URL}api/v1/user/content/$contentid/file");

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));
    var at =  prefs.getString( "accessToken");
    var uph =  prefs.getString( "userFingerprintHash");
    if (at != null) {
      request.headers["Authorization"] = "Bearer " + at;
      request.headers["userFingerprintHash"] = uph!;
      request.headers["appcode"] = "100000";
      request.headers["licensekey"] = "33783ui7-hepf-3698-tbk9-so69eq185173";
    }
    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    print(response.stream);
    print(response.request!.url.toString());
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    return response.statusCode;
  }
  Future<int> uploadweb(PlatformFile imageFile,String channelid,String contentid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.readStream!));
    var length = await imageFile.size;

    var uri = Uri.parse("${AppStrings.BASE_URL}api/v1/user/content/$contentid/file");

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: imageFile.name);
    //contentType: new MediaType('image', 'png'));
    var at =  prefs.getString( "accessToken");
    var uph =  prefs.getString( "userFingerprintHash");
    var pahirAuthHeader =  prefs.getString( "pahirAuthHeader");
    if (at != null) {
      request.headers["Authorization"] = "Bearer " + at;
      request.headers["userFingerprintHash"] = uph!;
      request.headers["appcode"] = "100000";
      request.headers["licensekey"] = "33783ui7-hepf-3698-tbk9-so69eq185173";
      request.headers["pahiruserauth"] = pahirAuthHeader!;
    }
    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    print(response.stream);
    print(response.request!.url.toString());
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    return response.statusCode;
  }


  Future<http.Response?> updateResourceData1(
      {required ResourceResults addResourceModel}) async {
    try {
      final response = await client.put(
          Uri.parse(
              '${AppStrings.BASE_URL}api/v1/user/$globalCountryCode/$globalPhoneNo/resource/${addResourceModel.id}'),

          body: jsonEncode(addResourceModel));
      log(response.statusCode.toString());
      log(response.request!.url.toString());
      return response;
    } on SocketException {
      return null;
    } catch (_) {
      return null;
    }
  }
  Future<PrivacyModel> getprivacy(
      CreateEditProfileModel createEditProfileModel) async {
    PrivacyModel resourceList=PrivacyModel();
    try {
      final response = await client.get(
        Uri.parse('${AppStrings.BASE_URL}api/v1/privacy/user/${createEditProfileModel.id.toString()}'),

      );

      print("getHomeData request :==>" + response.request!.url.toString());
      print("getHomeData response :==>" + response.body.toString());

      if (response.statusCode == 200) {
        resourceList =
            PrivacyModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
    } on Exception catch (e) {
      throw e;
    }
    return resourceList;
  }

  Future<PrivacyModel> setprivacy(CreateEditProfileModel createEditProfileModel,
      PrivacyModel privacyModel) async {
    PrivacyModel resourceList=PrivacyModel();
    try {
      final response = await client.post(
          Uri.parse('${AppStrings.BASE_URL}api/v1/privacy/user/${createEditProfileModel.id.toString()}'),

          body: jsonEncode(privacyModel));

      print("getHomeData request :==>" + response.request!.url.toString());
      print("getHomeData response :==>" + response.body.toString());

      if (response.statusCode == 200) {
        resourceList =
            PrivacyModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
    } on Exception catch (e) {
      throw e;
    }
    return resourceList;
  }

  Future<ResourceSearchNew> getSearchData2(
      String searchString, int start, int limit) async {
    List<SearchResults> searchResultList;
    late ResourceSearchNew searchResultResModel;



    try {
      final response = await client.get(
        //'${AppStrings.BASE_URL}api/v2/user/${globalCountryCode}/${globalPhoneNo}/resources/search?limit=$limit&searchString=$searchString&start=$start',
        //Old Url
        // '${AppStrings.BASE_URL}api/v2.2/user/${globalCountryCode}/${globalPhoneNo}/resources/search?limit=$limit&searchString=$searchString&start=$start',

        //New Url
        Uri.parse('${AppStrings.BASE_URL}api/v2.4/user/${globalCountryCode}/${globalPhoneNo}/resources/search?limit=$limit&searchString=$searchString&start=$start'),
        //'https://api.pahir.com/api/v2.3/user/+91/9994081073/resources/search?limit=10&searchString=Electrician&start=0',

      );

      print("getSearchData1 request.url body:==>"+response.request!.url.toString());

      print("getSearchData1 body:==>"+response.body.toString());

      searchResultResModel = ResourceSearchNew.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      if(searchResultResModel != null){

        /////sharedDetails data or Referrer name data start///
        if(searchResultResModel.searchResults != null) {
          for (int arrIndx = 0; arrIndx <searchResultResModel.searchResults!.length; arrIndx++) {
            List<ResourceResults> resourceResults = searchResultResModel.searchResults![arrIndx].resourceResults!;
            if(resourceResults != null){
              // for (int itemIndx = 0; itemIndx <resourceResults.length; itemIndx++) {
              //
              //   List<ResourceSearchNew.SharedDetails> sharedDetails  = resourceResults![itemIndx].sharedDetails!;
              //   String referrerNames = "";
              //   if(sharedDetails != null){
              //     for (int innerItemIndx = 0; innerItemIndx <sharedDetails.length; innerItemIndx++) {
              //       if(referrerNames != ""){
              //         referrerNames =  referrerNames +","+ resourceResults![itemIndx].sharedDetails![innerItemIndx].firstName!;
              //       }else{
              //         referrerNames =  resourceResults[itemIndx].sharedDetails![innerItemIndx].firstName!;
              //       }
              //     }
              //   }
              //   print("Referrer Name in res_repos :==>"+referrerNames);
              //   resourceResults[itemIndx].manualAddedReferrerName = referrerNames;
              //
              // }
            }

          }
        }
        //////////sharedDetails data or Referrer name data start//////

        searchResultList = searchResultResModel.searchResults!;
      }

    } on Exception catch (e) {
      print("Exception :==>"+e.toString());
      // TODO
    }
    return searchResultResModel;
  }
  Future<MessagesModel> fetchMessages(
      String mobileNumber, String countryCode) async {
    MessagesModel? messageResponse;
    try {
      final response = await client.get(
          Uri.parse('${AppStrings.BASE_URL}api/v1/message/$mobileNumber/$countryCode'),
           );
      log(response.body.toString());
      log("GetReviewResponse request :==>"+response.request!.url.toString());
      if (response.statusCode == 200) {
        print("GetReviewResponse response :==>" + response.body.toString());
        messageResponse = MessagesModel.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
        if (messageResponse != null) {
          //print("GetReviewResponse response Username,userid,Review,rating :==>"+reviewResponse.reviews[0].userName+","+reviewResponse.reviews[0].userId.toString()+","+reviewResponse.reviews[0].review+","+reviewResponse.reviews[0].rating.toString());
          globalMessagesResponse = messageResponse;

          // if(messageResponse != null && messageResponse.messages != null && messageResponse.messages.length > 0) {
          //   for(int i = 0; i < messageResponse.messages.length; i++) {
          //     //2020-09-17T05:13:45
          //     DateTime sendTimeFromResponse =
          //     DateFormat("yyyy-MM-ddTHH:mm:ss").parse(messageResponse.messages[i].sentDate);
          //     Duration duration = DateTime.now().difference(sendTimeFromResponse);
          //     String ago = "";
          //     if(duration.inDays > 0) {
          //       int remainingHours = (duration.inHours % 24).toInt();
          //       if(remainingHours > 0) {
          //         ago = '${duration.inDays}day ${remainingHours}h ago';
          //       } else {
          //         ago = '${duration.inDays}day ago';
          //       }
          //     } else if (duration.inHours > 0) {
          //       int remainingMinutes = (duration.inMinutes % 60).toInt();
          //       if (remainingMinutes > 0) {
          //         ago = '${duration.inHours}h ${remainingMinutes}m ago';
          //       } else {
          //         ago = '${duration.inHours}h ago';
          //       }
          //     } else {
          //       ago = '${duration.inMinutes}m ago';
          //     }
          //
          //     messageResponse.messages[i].messageBody.messageSent = ago;
          //
          //
          //   }
          // }
        }
      } else {
        messageResponse = null;
        globalReviewResponse = null;
      }
    } on Exception catch (e) {
      print(e.toString());
      messageResponse = null;
      globalReviewResponse = null;
    }
    return messageResponse!;
  }
  Future<String> getlike(
      String orgmemberid,
      String messageid,
      String reaction,
      String reactionid,
      ) async {
    String resourceList = "";
    try {
      final response = await client.post(
          Uri.parse('${AppStrings.BASE_URL}api/v1/message/member/$orgmemberid/message/$messageid/$reaction/$reactionid'),
           );
      log(response.request!.url.toString());
      log(response.body.toString());
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        resourceList = "200";

        return resourceList;
      } else {
        return resourceList;
      }
    } on Exception catch (e) {
      return resourceList;
    }
  }
  Future<String> shareApi(
      String orgmemberid,
      String messageid,
      String reaction,
      String reactionid,
      ) async {
    String resourceList = "";
    try {
      final response = await client.post(
          Uri.parse('${AppStrings.BASE_URL}api/v1/message/member/$orgmemberid/message/$messageid/$reaction/$reactionid'),
           );
      log(response.request!.url.toString());
      log(response.body.toString());
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        resourceList = "200";

        return resourceList;
      } else {
        return resourceList;
      }
    } on Exception catch (e) {
      return resourceList;
    }
  }

}
