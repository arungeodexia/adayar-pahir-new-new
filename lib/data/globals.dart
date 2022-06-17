library ishare.globals;

import 'package:flutter/material.dart';
import 'package:ACI/Bloc/message/message_model_class.dart';
import 'package:ACI/Model/GetReviewResponse.dart';
import 'package:ACI/Model/ResourceSearchNew.dart';
import 'package:ACI/Model/add_resource_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


bool isResource = false;
String globalCountryCode = "";
String globalPhoneNo = "";
int globalUserId = 0;
int globalTaskID = 0;
int currentIndex = 0;
String globalResourceId = "";
String globalTaskName = "";
String globalSearchData = "";
String timezone = 'Unknown';
List finalSelectedList = [];
List<String> channelsname=[];


bool globalIsLaunch = false;
bool globalAndroidIsOnMsgExecuted = false;
bool globalAndroidIsOnResumeExecuted = false;
String globalCurrentUserMobileNo = "";
int globalCurrentUserId = 0;
String globalResourceType = "";
bool globalISPNPageOpened = false;
bool globalqr = false;

String listKey = "Tamil Nadu";
String listid = "";
String unreads = "0";
String notifyread = "0";
AddResourceModel? globalAddResourceModel;
//SearchResultDetailsModel globalSearchResourceModel;
ResourceResults? globalSearchResourceModel;
GetReviewResponse? globalReviewResponse;
MessagesModel? globalMessagesResponse;
/// 加法事件
const actionIncrement = 'actionIncrement';

/// 减法事件
const actionDecrease = 'actionDecrease';
BuildContext? globalcontext;

/// 直接修改事件
const actionChange = 'actionChange';
Map<String, String> requestHeaders = {
  'Content-type': 'application/json; charset=UTF-8',
  "Access-Control-Expose-Headers": "*",
  'Accept': 'application/json',
  'appcode': '700000',
  'licensekey': '33783ui7-hepf-3698-tbk9-so69eq185173',
};

