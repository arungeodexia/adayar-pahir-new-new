import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:intl/intl.dart';
import 'package:ACI/Bloc/message/message_model_class.dart';
import 'package:ACI/Model/MembersModel.dart';
import 'package:ACI/Model/OrganizationModel.dart';
import 'package:ACI/data/api/repository/api_intercepter.dart';
import 'package:ACI/utils/values/app_strings.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../globals.dart';



class ResourceRepository {
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);
  Future<OrganizationModel?> getOrganisationData() async {
    OrganizationModel? resourceList;
    try {
      final response = await client.get(
          Uri.parse('${AppStrings.BASE_URL}api/v1/organization/user/${globalCountryCode}/${globalPhoneNo}/'),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        resourceList = OrganizationModel.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
        return resourceList;
      } else {
        return resourceList;
      }
    } on Exception catch (e) {
      return resourceList;
    }
  }

  Future<MessagesModel> fetchMessages(
      {required String mobileNumber, required String countryCode}) async {
    MessagesModel messageResponse;
    //https://api.pahir.com/api/v1/message/+91/9994081073
    try {
      final response = await client.get(
          Uri.parse('${AppStrings.BASE_URL}api/v1/message/$countryCode/$mobileNumber'),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      // log(response.body.toString());
      // print("GetReviewResponse request :==>"+response.request.url.toString());
      if (response.statusCode == 200) {
        // print("GetReviewResponse response :==>" + response.body.toString());
        // print("GetReviewResponse response :==>" + response.request.url.toString());
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
        messageResponse = MessagesModel();
        globalReviewResponse = null;
      }
    } on Exception catch (e) {
      print(e.toString());
      messageResponse = MessagesModel();
      globalReviewResponse = null;
    }
    return messageResponse;
  }
  Future<MembersModel> getSubOrganisationData(String orgid) async {
    late MembersModel resourceList;
    try {
      final response = await client.get(
          Uri.parse('${AppStrings.BASE_URL}api/v1/organization/user/${globalCountryCode}/${globalPhoneNo}/organization/${orgid}/leaders'),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      print("GetReviewResponse response :==>" + response.request!.url.toString());
      print("GetReviewResponse response :==>" + response.body.toString());

      if (response.statusCode == 200) {
        print(response.body);
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        resourceList =
            MembersModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));

        return resourceList;
      } else {
        resourceList =MembersModel();
        return resourceList;
      }
    } on Exception catch (e) {
      return resourceList;
    }
  }
  Future<String> getlike(String orgmemberid,String messageid,String reaction,String reactionid,) async {
    String resourceList="";
    try {
      final response = await client.post(
          Uri.parse('${AppStrings.BASE_URL}api/v1/message/member/$orgmemberid/message/$messageid/$reaction/$reactionid'),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      log(response.request!.url.toString());
      log(response.body.toString());
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        resourceList="200";

        return resourceList;
      } else {
        return resourceList;
      }
    } on Exception catch (e) {
      return resourceList;
    }
  }
  Future<String> shareApi(String orgmemberid,String messageid,String reaction,String reactionid,) async {
    String resourceList="";
    try {
      final response = await client.post(
          Uri.parse('${AppStrings.BASE_URL}api/v1/message/member/$orgmemberid/message/$messageid/$reaction/$reactionid'),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      log(response.request!.url.toString());
      log(response.body.toString());
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        resourceList="200";

        return resourceList;
      } else {
        return resourceList;
      }
    } on Exception catch (e) {
      return resourceList;
    }
  }

}

