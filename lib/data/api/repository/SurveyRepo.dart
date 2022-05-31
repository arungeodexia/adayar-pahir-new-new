import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ACI/Model/AnswerModel.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_intercepter.dart';

class SurveyRepo {
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);

  Future<http.Response?> getSurvey() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response = await client.get(
        Uri.parse('${AppStrings.BASE_URL}api/v1/survey/user/1/questions'),
      );
      return response;
    } on SocketException {
      return null;
    }
  }

  Future<http.Response?> getSurveyDetails(String questionid) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response = await client.get(
        Uri.parse('${AppStrings.BASE_URL}api/v1/question/${questionid}'),
      );
      log(response.body);
      return response;
    } on SocketException {
      return null;
    }
  }

  Future<http.Response?> getAppointments() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response = await client.get(
        Uri.parse('${AppStrings.BASE_URL}api/v1/appointment/1'),
      );
      return response;
    } on SocketException {
      return null;
    }
  }

  Future<http.Response?> getTasks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response = await client.get(
        Uri.parse('${AppStrings.BASE_URL}api/v1/tasks'),
      );

      return response;
    } on SocketException {
      return null;
    }
  }

  Future<http.Response?> getTrailInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response = await client.get(
        Uri.parse('${AppStrings.BASE_URL}api/v1/info/videos'),
      );

      return response;
    } on SocketException {
      return null;
    }
  }

  Future<http.Response?> getTasksDetails(String taskId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response = await client.get(
        Uri.parse('${AppStrings.BASE_URL}api/v1/task/${taskId}'),
      );
      return response;
    } on SocketException {
      return null;
    }
  }

  Future<http.Response?> getorgchannelmember() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response = await client.get(
        Uri.parse(
            '${AppStrings.BASE_URL}api/v1/admin/org-channel-member/organization/1/channel/1'),
      );
      log(response.body);
      print(response.request!.headers);
      log(response.request!.url.toString());
      ;
      return response;
    } on SocketException {
      return null;
    }
  }

  Future<http.Response?> submitanswers(
      String questionId, AnswerModel answerModel) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response = await client.post(
          Uri.parse(
              '${AppStrings.BASE_URL}api/v1/answer/user/${globalCurrentUserId}/question/${questionId}'),
          body: jsonEncode(answerModel));
      log(response.body);
      return response;
    } on SocketException {
      return null;
    }
  }
}
