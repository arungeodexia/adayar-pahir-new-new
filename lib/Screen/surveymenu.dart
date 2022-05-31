import 'dart:convert';

import 'package:ACI/Model/SurveyModel.dart';
import 'package:ACI/Screen/surveymenuDetails.dart';
import 'package:ACI/data/api/repository/SurveyRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class Surveymenu extends StatefulWidget {
  Surveymenu({Key? key}) : super(key: key);

  @override
  _SurveymenuState createState() => _SurveymenuState();
}

class _SurveymenuState extends State<Surveymenu> {
  static final SurveyRepo resourceRepository = new SurveyRepo();
  SurveyModel surveyModel = SurveyModel();

  bool isload = false;

  String username = "";

  String userImage = "";
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    getuserName();
    getsurvey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: survey()
    );
  }

  getuserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String res = prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString();
    var encoded = utf8.encode(res);
    final resourceDetailsResponse = json.decode(utf8.decode(encoded));
    //debugPrint("resourceDetailsResponse:==>" + resourceDetailsResponse.toString());
    setState(() {
      username = resourceDetailsResponse['firstName'];
      globalCurrentUserMobileNo = resourceDetailsResponse['mobile'];
      globalCurrentUserId = resourceDetailsResponse['id'];
      userImage = resourceDetailsResponse['profilePicture'];
      print(userImage);
    });
  }

  Widget survey() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height -
            150,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.only(
            //     left: 25,
            //     top: 20,
            //     right: 20,
            //     bottom: 10,
            //   ),
            //   child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: <Widget>[
            //         new CircleAvatar(
            //             radius: 25.0,
            //             backgroundColor: const Color(0xFF778899),
            //             backgroundImage: userImage.toString()!="null"&&userImage != ""
            //                 ? NetworkImage(userImage.toString())
            //                 : AssetImage("images/photo_avatar.png")
            //                     as ImageProvider),
            //         SizedBox(width: 10),
            //         new Expanded(
            //             child: Text(username == null ? "" : username.trim(),
            //                 style: TextStyle(
            //                     fontWeight: FontWeight.bold, fontSize: 20)))
            //       ]),
            // ),
            // Visibility(
            //   visible:  true,
            //   //visible:isMyResVisible,
            //   child: Padding(
            //     padding: EdgeInsets.only(top: 7, bottom: 7),
            //     child: Container(
            //         padding: const EdgeInsets.only(
            //           left: 45,
            //           top: 7,
            //           right: 45,
            //           bottom: 7,
            //         ),
            //         decoration: BoxDecoration(
            //             color: AppColors.APP_LIGHT_GREY_10,
            //             borderRadius: BorderRadius.only(
            //                 bottomRight: Radius.circular(16.0),
            //                 topRight: Radius.circular(16.0))),
            //         child: Text(
            //           AppStrings.SURVEY_SUB_TITLE,
            //           style:
            //           TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            //         )),
            //   ),
            // ),
            isload
                ? Expanded(child: buildLoading())
                : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only( left: 5,
                      top: 7,
                      right: 15,
                      bottom: 0,),
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        itemCount: surveyModel.questions!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: ListTile(
                              onTap: (){
                                Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (_)=> SurveymenuDetails(
                                  questionId: surveyModel.questions![index].questionId!.toString(),
                                )),)
                                    .then((val)=>getsurvey());

                              },
                                // leading: Icon(Icons.task),

                              leading: CircleAvatar(
                                backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                child: Text(
                                    "${index + 1} ",
                                  style: TextStyle(
                                      fontFamily: "OpenSans",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                  color: Colors.white
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                                title: Text(
                                  surveyModel.questions![index].question!,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 3,
                                  style: TextStyle(
                                      fontFamily: "OpenSans",
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700),
                                ),
                            ),
                          );
                        }),
                  ),
                ),
          ],
        ));
  }

  Widget buildLoading() {
    return Container(
      height:
          MediaQuery.of(context).size.height - (AppBar().preferredSize.height),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }


  void getsurvey() async {
    isload = true;
    http.Response? response = await resourceRepository.getSurvey();
    surveyModel =
        SurveyModel.fromJson(json.decode(utf8.decode(response!.bodyBytes)));
    setState(() {
      isload = false;
    });
  }
}
