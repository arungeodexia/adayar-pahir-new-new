import 'dart:convert';
import 'dart:developer';

import 'package:ACI/Model/AnswerModel.dart';
import 'package:ACI/Model/SuccessModel.dart';
import 'package:ACI/Model/survey_details_model.dart';
import 'package:ACI/data/api/repository/SurveyRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/calls_messages_services.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'ScreenCheck.dart';
import 'mydashboard.dart';

class SurveymenuDetails extends StatefulWidget {
  final String questionId;

  SurveymenuDetails({Key? key, required this.questionId}) : super(key: key);

  @override
  _SurveymenuDetailsState createState() => _SurveymenuDetailsState();
}

class _SurveymenuDetailsState extends State<SurveymenuDetails> {
  static final SurveyRepo resourceRepository = new SurveyRepo();
  SurveyDetailsModel surveyDetailsModel = new SurveyDetailsModel();

  bool isload = false;

  String username = "";

  String userImage = "";
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  int _groupValue = -1;
  int _selectedidValue = -1;
  int _selectedOptionid = -1;

  var isFullNameChangeBtnState = false;

  late Duration videoLength;
  late Duration videoPosition;
  double volume = 0.5;
  String taskpercentage = "0%";
  String expiry = "0";
  List<TextEditingController> _controllers = [];

  var isFullNameChangeBtnStateTextBox=true;

  @override
  void initState() {
    super.initState();
    _controllers.clear();
    getuserName();
    getsurvey();
  }

  void getsurvey() async {
    isload = true;
    http.Response? response =
        await resourceRepository.getSurveyDetails(widget.questionId.toString());

    if (response!.statusCode == 200) {
      surveyDetailsModel = SurveyDetailsModel.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    }
    if (surveyDetailsModel.question != null) {
      taskpercentage = "0." +
          surveyDetailsModel.question!.completionProgress
              .toString()
              .replaceAll("%", "");
    }

    if (surveyDetailsModel.question!.answerType.toString() == "textbox") {
      setState(() {
        isFullNameChangeBtnState = false;
        isFullNameChangeBtnStateTextBox=false;
      });
    }

    if (surveyDetailsModel.question!.expiryDate != null) {
      try {
        var split = surveyDetailsModel.question!.expiryDate!.split("-");
        final birthday = DateTime(
            int.parse(split[2]), int.parse(split[1]), int.parse(split[0]));
        final date3 = DateTime.now();
        final difference = date3.difference(birthday).inDays;
        expiry = difference.toString();
        log(difference.toString());
        log(int.parse(split[2]).toString() +
            int.parse(split[1]).toString() +
            int.parse(split[0]).toString());
      } catch (e) {}
    }

    if (surveyDetailsModel.question == null ||
        surveyDetailsModel.question!.questionType.toString() == "video") {
      videoPlayerController = VideoPlayerController.network(
          surveyDetailsModel.question!.url.toString())
        ..addListener(() => setState(() {
              videoPosition = videoPlayerController.value.position;
            }))
        ..initialize().then((_) => setState(() {
              videoPlayerController.pause();
              videoPlayerController.setLooping(false);
              videoLength = videoPlayerController.value.duration;
            }));
      // await videoPlayerController.initialize();

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: true,
      );
    }
    setState(() {
      isload = false;
    });
  }

  Future<bool> backPressed() async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Mydashboard()),
          (Route<dynamic> route) => false,
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    final isKeyboard=MediaQuery.of(context).viewInsets.bottom != 0;
    return WillPopScope(
      onWillPop: backPressed,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Mydashboard()),
                (Route<dynamic> route) => false,
              ),
            ),
            title: Text(tr("task")),
            centerTitle: true,
            backgroundColor: AppColors.APP_BLUE,
            automaticallyImplyLeading: true,
          ),
          body: isload
              ? buildLoading()
              : surveyDetailsModel.userName.toString() == "null"
                  ? Center(
                      child: Text(
                      "Something went wrong",
                      style: ktextstyle.copyWith(fontSize: 15),
                    ))
                  : survey(itemHeight, itemWidth,isKeyboard)),
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

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController.dispose();
  }

  String convertToMinutesSeconds(Duration duration) {
    final parsedMinutes = duration.inMinutes < 10
        ? '0${duration.inMinutes}'
        : duration.inMinutes.toString();

    final seconds = duration.inSeconds % 60;

    final parsedSeconds =
        seconds < 10 ? '0${seconds % 60}' : (seconds % 60).toString();
    return '$parsedMinutes:$parsedSeconds';
  }

  IconData animatedVolumeIcon(double volume) {
    if (volume == 0)
      return Icons.volume_mute;
    else if (volume < 0.5)
      return Icons.volume_down;
    else
      return Icons.volume_up;
  }

  Widget survey(double itemHeight, double itemWidth,bool isKeyboard) {
    return Stack(
      children: [
        Scrollbar(
          thickness: 8.0,

          hoverThickness: 20,
          isAlwaysShown: true,
          // thumbVisibility: true,
          child: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                  left: 25,
                  top: 7,
                  right: 15,
                  bottom: 100,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //     left: 0,
                    //     top: 20,
                    //     right: 0,
                    //     bottom: 10,
                    //   ),
                    //   child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: <Widget>[
                    //         new CircleAvatar(
                    //             radius: 25.0,
                    //             backgroundColor: const Color(0xFF778899),
                    //             backgroundImage: userImage.toString() != "null" &&
                    //                     userImage != ""
                    //                 ? NetworkImage(userImage.toString())
                    //                 : AssetImage("images/photo_avatar.png")
                    //                     as ImageProvider),
                    //         SizedBox(width: 10),
                    //         new Expanded(
                    //             child: Text(
                    //                 username == null
                    //                     ? ""
                    //                     : "Hi " + username.trim(),
                    //                 style: TextStyle(
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 17)))
                    //       ]),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //     left: 10,
                    //     top: 7,
                    //     right: 15,
                    //     bottom: 15,
                    //   ),
                    //   child: Text(
                    //     surveyDetailsModel.topText.toString(),
                    //     overflow: TextOverflow.ellipsis,
                    //     softWrap: false,
                    //     maxLines: 3,
                    //     style: TextStyle(
                    //         fontFamily: "Poppins",
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.w500),
                    //   ),
                    // ),
                     !surveyDetailsModel.question!.hasSkip!?Container():GestureDetector(
                      onTap: () {
                        if(surveyDetailsModel
                            .question!.nextQuestionId ==
                            surveyDetailsModel
                                .question!.questionId){
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Mydashboard()),
                                (Route<dynamic> route) => false,
                          );
                        }else{
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    SurveymenuDetails(
                                        questionId:
                                        surveyDetailsModel
                                            .question!
                                            .nextQuestionId
                                            .toString())),
                                (Route<dynamic> route) => false,
                          );
                        }
                      },

                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            top: 10,
                            right: 10,
                            bottom: 5,
                          ),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                tr('skip'),
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 3,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.APP_LIGHT_BLUE),
                              ),
                              Icon(Icons.skip_next_sharp,color: AppColors.APP_BLUE,size: 23,),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 10,),
                      child: new LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width-60,
                        animation: true,
                        animationDuration: 1000,
                        lineHeight: 20.0,
                        leading: new Text(""),
                        trailing: new Text(""),
                        percent: double.parse(taskpercentage),
                        center: Text(""),
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: AppColors.APP_LIGHT_BLUE,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width-60,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0, top: 5, right:0, bottom: 0,),
                        child: Text(
                          // "Screening Check Results expire in ${expiry.replaceAll("-", "")} days",
                          surveyDetailsModel.question!.expiryText==null?"":surveyDetailsModel.question!.expiryText!,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          maxLines: 3,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.APP_BLACK),
                        ),
                      ),
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        top: 7,
                        right: 15,
                        bottom: 0,
                      ),
                      child: Text(
                        surveyDetailsModel.question!.question.toString(),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 3,
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.APP_BLACK),
                      ),
                    ),
                    surveyDetailsModel.question!.questionDescription.toString() ==
                            "null"
                        ? Container()
                        : Container(
                            // decoration: BoxDecoration(
                            //     color: AppColors.APP_LIGHT_BLUE_50,
                            //     borderRadius: BorderRadius.circular(5.0)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                top: 10,
                                right: 15,
                                bottom: 7,
                              ),
                              child: Text(
                                "     " +
                                    surveyDetailsModel
                                        .question!.questionDescription
                                        .toString(),
                                // overflow: TextOverflow.ellipsis,
                                // softWrap: false,
                                // maxLines: 3,
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.APP_BLACK,
                                    wordSpacing: 0.6),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    surveyDetailsModel.question!.questionType.toString() ==
                            "image"
                        ? Container(
                            decoration: BoxDecoration(
                                color: AppColors.APP_LIGHT_BLUE_50,
                                borderRadius: BorderRadius.circular(5.0)),
                            margin: EdgeInsets.all(3),
                            padding: EdgeInsets.all(4),
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl:
                                  surveyDetailsModel.question!.url.toString(),
                              placeholder: (context, url) => Center(
                                child: Container(
                                    width: 100,
                                    height: 100,
                                    child: new CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    width: 30,
                                    height: 30,
                                    child: Image.asset(
                                      'images/noimage.png',
                                      width: 30,
                                      height: 30,
                                    )),
                              ),
                            ),
                          )
                        :
                    surveyDetailsModel.question!.questionType.toString() ==
                                "video"
                            ? Container(
                                padding: EdgeInsets.all(4),
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                child: Stack(
                                  children: <Widget>[
                                    videoPlayerController.value.isInitialized
                                        ? AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: Chewie(
                                              controller: chewieController,
                                            ),
                                          )
                                        : Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                  ],
                                ),
                              )
                            : Container(),
                    surveyDetailsModel.question!.options == null
                        ? Container()
                        : Container(
                            margin: EdgeInsets.only(top: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                surveyDetailsModel.question!.answerType ==
                                        "textbox"
                                    ? Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        color: AppColors.APP_LIGHT_BLUE_50,
                                        child: Center(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 20, left: 20, bottom: 20),
                                            // height: 200.0,
                                            width:
                                                MediaQuery.of(context).size.width,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: surveyDetailsModel
                                                    .question!
                                                    .optionGroup!
                                                    .length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10,
                                                            left: 12,
                                                            bottom: 10),
                                                        child: Text(
                                                            surveyDetailsModel
                                                                .question!
                                                                .optionGroup![
                                                                    index]
                                                                .optionGroup!
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .APP_BLUE)),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 3,
                                                            right: 20,
                                                            left: 5,
                                                            bottom: 5),
                                                        child: Divider(
                                                          color: AppColors.APP_BLUE,
                                                        ),
                                                      ),
                                                      ListView.builder(
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                                          itemCount:
                                                              surveyDetailsModel
                                                                  .question!
                                                                  .optionGroup![
                                                                      index]
                                                                  .optionGroups!
                                                                  .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index1) {
                                                            return ListTile(
                                                              title: Row(
                                                                children: [

                                                                  // Container( height:40, width:40,child: Text(surveyDetailsModel.question!.optionGroup![index].optionGroups![index1].optionPrefix.toString(),style:TextStyle(fontFamily: "Poppins", fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),)),
                                                                  // Container(
                                                                  //   height:40,
                                                                  //   width:50,
                                                                  //   child: TextField(
                                                                  //     keyboardType: surveyDetailsModel.question!.optionGroup![index].optionGroups![index1].optionPrefix.toString() ==
                                                                  //         "Others"
                                                                  //         ? TextInputType.name
                                                                  //         : TextInputType.number,
                                                                  //     controller: surveyDetailsModel
                                                                  //         .question!
                                                                  //         .optionGroup![index]
                                                                  //         .optionGroups![index1]
                                                                  //         .textEditingController,
                                                                  //
                                                                  //   ),
                                                                  // ),
                                                                  // Container( height:40, width:40,child: Text(surveyDetailsModel.question!.optionGroup![index].optionGroups![index1].optionSuffix.toString(),style:TextStyle(fontFamily: "Poppins", fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),)),

                                                                  Expanded(
                                                                    flex: surveyDetailsModel
                                                                                .question!
                                                                                .optionGroup![index]
                                                                                .optionGroups![index1]
                                                                                .optionPrefix
                                                                                .toString()
                                                                                .length <
                                                                            15
                                                                        ? 2
                                                                        : 2,
                                                                    child:
                                                                        Container(
                                                                      child: Text(
                                                                        surveyDetailsModel
                                                                            .question!
                                                                            .optionGroup![
                                                                                index]
                                                                            .optionGroups![
                                                                                index1]
                                                                            .optionPrefix
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "Poppins",
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight: FontWeight
                                                                                .w500,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Container(
                                                                          width:40,
                                                                          height:surveyDetailsModel.question!.optionGroup![index].optionGroups![index1].optionPrefix.toString() ==
                                                                              "Others"||surveyDetailsModel.question!.optionGroup![index].optionGroups![index1].optionPrefix.toString() == "மற்றவை"?60:40,
                                                                          child: TextField(
                                                                          keyboardType: surveyDetailsModel.question!.optionGroup![index].optionGroups![index1].optionPrefix.toString() ==
                                                                                "Others" ||surveyDetailsModel.question!.optionGroup![index].optionGroups![index1].optionPrefix.toString() == "மற்றவை"
                                                                            ? TextInputType.name
                                                                            : TextInputType.number,
                                                                            inputFormatters:[
                                                                              LengthLimitingTextInputFormatter(surveyDetailsModel.question!.optionGroup![index].optionGroups![index1].optionPrefix.toString() ==
                                                                                  "Others"||surveyDetailsModel.question!.optionGroup![index].optionGroups![index1].optionPrefix.toString() == "மற்றவை"?300:3),
                                                                            ],
                                                                          controller: surveyDetailsModel
                                                                            .question!
                                                                            .optionGroup![index]
                                                                            .optionGroups![index1]
                                                                            .textEditingController,
                                                                            onChanged: (_){
                                                                            var text=false;
                                                                              for (int i = 0; i < surveyDetailsModel.question!.optionGroup!.length; i++) {
                                                                                for (int j = 0; j < surveyDetailsModel.question!.optionGroup![i].optionGroups!.length; j++) {
                                                                                  if(surveyDetailsModel.question!.optionGroup![i].optionGroups![j].textEditingController!.text.trim().toString().length!=0){
                                                                                    text=true;
                                                                                  }
                                                                                }
                                                                              }
                                                                              if(text){
                                                                                setState(() {
                                                                                  isFullNameChangeBtnState=true;
                                                                                });
                                                                              }else{
                                                                                setState(() {
                                                                                  isFullNameChangeBtnState=false;
                                                                                });
                                                                               }


                                                                            },
                                                                          ),
                                                                        ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Container(
                                                                      margin: EdgeInsets.only(
                                                                          top: 0,
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              0),
                                                                      child: Text(
                                                                        surveyDetailsModel.question!.optionGroup![index].optionGroups![index1].optionSuffix.toString() ==
                                                                                "null"
                                                                            ? ""
                                                                            : surveyDetailsModel
                                                                                .question!
                                                                                .optionGroup![index]
                                                                                .optionGroups![index1]
                                                                                .optionSuffix
                                                                                .toString(),
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "Poppins",
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight: FontWeight
                                                                                .w500,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                            return InkWell(
                                                              onTap: () {
                                                                isFullNameChangeBtnState =
                                                                    true;
                                                                setState(() {});
                                                              },
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  setState(() {});
                                                                },
                                                                child: Container(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  height: 80,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(5),
                                                                  decoration: BoxDecoration(
                                                                      color: AppColors
                                                                          .APP_LIGHT_BLUE_50,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0)),
                                                                  child: Row(
                                                                    children: [
                                                                      // CachedNetworkImage(
                                                                      //   width: 50,
                                                                      //   height: 50,
                                                                      //   fit: BoxFit.cover,
                                                                      //   imageUrl:
                                                                      //   surveyDetailsModel.question!.optionGroup![index].optionGroups![index1].url.toString(),
                                                                      //   placeholder:
                                                                      //       (context, url) =>
                                                                      //       Center(
                                                                      //         child: Container(
                                                                      //             width: 30,
                                                                      //             height: 30,
                                                                      //             child:
                                                                      //             new CircularProgressIndicator()),
                                                                      //       ),
                                                                      //   errorWidget: (context,
                                                                      //       url, error) => Container(),
                                                                      // ),
                                                                      // SizedBox(
                                                                      //   width: 50,
                                                                      //   height: 10,
                                                                      // ),
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          "sfgdhsghjgfjdabhmbdm,bdmfghjadgfhnadvfmndbvfmnfg" +
                                                                              surveyDetailsModel.question!.optionGroup![index].optionGroups![index1].optionPrefix.toString(),
                                                                          style: TextStyle(
                                                                              fontFamily:
                                                                                  "Poppins",
                                                                              fontSize:
                                                                                  15,
                                                                              fontWeight:
                                                                                  FontWeight.w500,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: 10,
                                                                      ),
                                                                      // Container(
                                                                      //   width: 80,
                                                                      //   height: 40,
                                                                      //   child: Center(
                                                                      //     child: TextField(
                                                                      //       controller: surveyDetailsModel.question!.optionGroup![index].optionGroups![index1].textEditingController,
                                                                      //       decoration: InputDecoration(
                                                                      //           border: OutlineInputBorder(
                                                                      //             borderRadius: BorderRadius.circular(10.0),
                                                                      //           ),
                                                                      //           filled: true,
                                                                      //           hintStyle: TextStyle(color: Colors.grey[800],),
                                                                      //           hintText: "",
                                                                      //           fillColor: Colors.white70),
                                                                      //     ),
                                                                      //   ),
                                                                      // ),
                                                                      // SizedBox(
                                                                      //   width: 10,
                                                                      // ),
                                                                      // Container(
                                                                      //   child: Text(
                                                                      //     surveyDetailsModel.question!.optionGroup![index].optionGroups![index1].optionSuffix.toString(),
                                                                      //     style: TextStyle(
                                                                      //         fontFamily:
                                                                      //         "Poppins",
                                                                      //         fontSize: 15,
                                                                      //         fontWeight:
                                                                      //         FontWeight.w500,
                                                                      //         color:
                                                                      //         Colors.black),
                                                                      //   ),
                                                                      // ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }),

                                                    ],
                                                  );
                                                }),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                surveyDetailsModel.question!.answerType == "radio"
                                    ? Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        color: AppColors.APP_LIGHT_BLUE_50,
                                        child: Center(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 10, left: 0, bottom: 10),
                                            // height: 200.0,
                                            width:
                                                MediaQuery.of(context).size.width,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                                itemCount: surveyDetailsModel
                                                    .question!.options!.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      isFullNameChangeBtnState =
                                                          true;
                                                      for (int j = 0;
                                                          j <
                                                              surveyDetailsModel
                                                                  .question!
                                                                  .options!
                                                                  .length;
                                                          j++) {
                                                        surveyDetailsModel
                                                            .question!
                                                            .options![j]
                                                            .selct = -1;
                                                      }
                                                      surveyDetailsModel
                                                          .question!
                                                          .options![index]
                                                          .selct = 0;
                                                      setState(() {});
                                                    },
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        isFullNameChangeBtnState =
                                                            true;
                                                        for (int j = 0;
                                                            j <
                                                                surveyDetailsModel
                                                                    .question!
                                                                    .options!
                                                                    .length;
                                                            j++) {
                                                          surveyDetailsModel
                                                              .question!
                                                              .options![j]
                                                              .selct = -1;
                                                        }
                                                        surveyDetailsModel
                                                            .question!
                                                            .options![index]
                                                            .selct = 0;
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        width:
                                                            MediaQuery.of(context)
                                                                .size
                                                                .width,
                                                        padding:
                                                            EdgeInsets.symmetric(horizontal: 5,vertical: 15),
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .APP_LIGHT_BLUE_50,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [

                                                            Expanded(
                                                              flex: 1,
                                                              child: Image.asset(
                                                                surveyDetailsModel
                                                                    .question!
                                                                    .options![
                                                                index]
                                                                    .select ==
                                                                    0
                                                                    ? 'images/radioonbutton.png'
                                                                    : 'images/radiobutton.png',
                                                                width: 25,
                                                                height: 25,
                                                              ),
                                                            ),
                                                            // SizedBox(
                                                            //   width: 20,
                                                            // ),
                                                            surveyDetailsModel
                                                                        .question!
                                                                        .options![
                                                                            index]
                                                                        .url
                                                                        .toString() ==
                                                                    "null"
                                                                ? Container()
                                                                : CachedNetworkImage(
                                                                    width: 40,
                                                                    height: 40,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    imageUrl: surveyDetailsModel
                                                                        .question!
                                                                        .options![
                                                                            index]
                                                                        .url
                                                                        .toString(),
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            Center(
                                                                      child: Container(
                                                                          width:
                                                                              30,
                                                                          height:
                                                                              30,
                                                                          child:
                                                                              new CircularProgressIndicator()),
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child: Container(
                                                                          // width: 30,
                                                                          // height: 30,
                                                                          // child: Image.asset('images/noimage.png', width: 30, height: 30,)
                                                                          ),
                                                                    ),
                                                                  ),
                                                            surveyDetailsModel
                                                                .question!
                                                                .options![
                                                            index]
                                                                .url
                                                                .toString() ==
                                                                "null"
                                                                ? Container()
                                                                : SizedBox(
                                                              width: 30,
                                                              height: 10,
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                surveyDetailsModel.question!.options![index].option.toString()=="null"?"No Data":surveyDetailsModel.question!.options![index].option.toString(),
                                                                textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),

                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                      )
                                    : surveyDetailsModel.question!.answerType ==
                                            "checkbox"
                                        ? Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            color: AppColors.APP_LIGHT_BLUE_50,
                                            child: Center(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 20,
                                                    left: 20,
                                                    right: 10,
                                                    bottom: 20),
                                                // height: 200.0,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                                    itemCount: surveyDetailsModel
                                                        .question!
                                                        .options!
                                                        .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          // for (int j = 0;j < surveyDetailsModel.question!.options!.length; j++) {
                                                          //   surveyDetailsModel.question!.options![j].selct = -1;
                                                          // }
                                                          if (surveyDetailsModel
                                                                  .question!
                                                                  .options![index]
                                                                  .select ==
                                                              0) {
                                                            surveyDetailsModel
                                                                .question!
                                                                .options![index]
                                                                .selct = -1;
                                                          } else {
                                                            surveyDetailsModel
                                                                .question!
                                                                .options![index]
                                                                .selct = 0;
                                                          }

                                                          int check = 0;

                                                          for (int l = 0;
                                                              l <
                                                                  surveyDetailsModel
                                                                      .question!
                                                                      .options!
                                                                      .length;
                                                              l++) {
                                                            if (surveyDetailsModel
                                                                    .question!
                                                                    .options![l]
                                                                    .select ==
                                                                0) {
                                                              check = 1;
                                                            }
                                                          }
                                                          if (check == 1) {
                                                            isFullNameChangeBtnState =
                                                                true;
                                                          } else {
                                                            isFullNameChangeBtnState =
                                                                false;
                                                          }

                                                          setState(() {});
                                                        },
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            // for (int j = 0;j < surveyDetailsModel.question!.options!.length; j++) {
                                                            //   surveyDetailsModel.question!.options![j].selct = -1;
                                                            // }
                                                            if (surveyDetailsModel
                                                                    .question!
                                                                    .options![
                                                                        index]
                                                                    .select ==
                                                                0) {
                                                              surveyDetailsModel
                                                                  .question!
                                                                  .options![index]
                                                                  .selct = -1;
                                                            } else {
                                                              surveyDetailsModel
                                                                  .question!
                                                                  .options![index]
                                                                  .selct = 0;
                                                            }

                                                            int check = 0;

                                                            for (int l = 0;
                                                                l <
                                                                    surveyDetailsModel
                                                                        .question!
                                                                        .options!
                                                                        .length;
                                                                l++) {
                                                              if (surveyDetailsModel
                                                                      .question!
                                                                      .options![l]
                                                                      .select ==
                                                                  0) {
                                                                check = 1;
                                                              }
                                                            }
                                                            if (check == 1) {
                                                              isFullNameChangeBtnState =
                                                                  true;
                                                            } else {
                                                              isFullNameChangeBtnState =
                                                                  false;
                                                            }

                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(5),
                                                            child: Row(
                                                              children: [

                                                                Image.asset(
                                                                  surveyDetailsModel
                                                                      .question!
                                                                      .options![index]
                                                                      .select ==
                                                                      0
                                                                      ? 'images/checkbox_checked.png'
                                                                      : 'images/checkbox.png',
                                                                  width: 25,
                                                                  height: 25,
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                  height: 10,
                                                                ),
                                                                surveyDetailsModel
                                                                    .question!
                                                                    .options![
                                                                index]
                                                                    .url
                                                                    .toString() ==
                                                                    "null"
                                                                    ? Container(
                                                                  height:
                                                                  40,
                                                                )
                                                                    : CachedNetworkImage(
                                                                  width: 50,
                                                                  height:
                                                                  50,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  imageUrl: surveyDetailsModel
                                                                      .question!
                                                                      .options![
                                                                  index]
                                                                      .url
                                                                      .toString(),
                                                                  placeholder:
                                                                      (context, url) =>
                                                                      Center(
                                                                        child: Container(
                                                                            width:
                                                                            30,
                                                                            height:
                                                                            30,
                                                                            child:
                                                                            new CircularProgressIndicator()),
                                                                      ),
                                                                  errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                      Padding(
                                                                        padding:
                                                                        const EdgeInsets.all(8.0),
                                                                        child: Container(
                                                                            width: 30,
                                                                            height: 30,
                                                                            child: Image.asset(
                                                                              'images/noimage.png',
                                                                              width: 30,
                                                                              height: 30,
                                                                            )),
                                                                      ),
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                  height: 10,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    surveyDetailsModel.question!.options![index].option ==null?"No Data":surveyDetailsModel.question!.options![index].option.toString(),
                                                                    textAlign: TextAlign.start,
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Poppins",
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),

                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            ),
                                          )
                                        : Container(),
                              ],
                            ),
                          ),
                    surveyDetailsModel.question!.choices == null
                        ? Container()
                        : Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                surveyDetailsModel.question!.answerType ==
                                        "choices"
                                    ? Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        color: AppColors.APP_LIGHT_BLUE_50,
                                        child: Center(
                                          child: Column(
                                            children: [
                                              // Row(
                                              //   crossAxisAlignment:
                                              //       CrossAxisAlignment.end,
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.end,
                                              //   children: [
                                              //     for (var i in surveyDetailsModel
                                              //         .question!.choices![0].options!)
                                              //       Container(
                                              //         margin: EdgeInsets.only(
                                              //             right: 30, top: 20),
                                              //         child: Text(
                                              //           i.option!,
                                              //           style: TextStyle(
                                              //             fontFamily: "Poppins",
                                              //             fontSize: 16,
                                              //             fontWeight: FontWeight.bold,
                                              //           ),
                                              //         ),
                                              //       ),
                                              //   ],
                                              // ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 10, left: 10),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: ListView.separated(
                                                    separatorBuilder:
                                                        (context, index) {
                                                      return Divider(
                                                        height: 5,
                                                        color: AppColors.APP_BLUE
                                                            .withOpacity(0.2),
                                                      );
                                                    },
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                                    itemCount: surveyDetailsModel
                                                        .question!
                                                        .choices!
                                                        .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return ListTile(
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        title: Text(
                                                            surveyDetailsModel
                                                                .question!
                                                                .choices![index]
                                                                .question
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                        // subtitle: Container(
                                                        //   margin: EdgeInsets.only(top: 20),
                                                        //   height: surveyDetailsModel
                                                        //       .question!
                                                        //       .choices![index]
                                                        //       .options!
                                                        //       .length>2?100:50,
                                                        //   // width: 50,
                                                        //   child: GridView.builder(
                                                        //
                                                        //     // physics: NeverScrollableScrollPhysics(),
                                                        //       itemCount:
                                                        //           surveyDetailsModel
                                                        //               .question!
                                                        //               .choices![index]
                                                        //               .options!
                                                        //               .length,
                                                        //       itemBuilder:
                                                        //           (BuildContext
                                                        //                   context,
                                                        //               int i) {
                                                        //         return Container(
                                                        //           child: GestureDetector(
                                                        //             onTap: () {
                                                        //               setState(() {
                                                        //                 for (int j = 0; j < surveyDetailsModel.question!.choices![index].options!.length; j++) {
                                                        //                   surveyDetailsModel.question!.choices![index].options![j].selct = -1;
                                                        //                 }
                                                        //                 surveyDetailsModel.question!.choices![index].options![i].selct = 0;
                                                        //                 int selection=0;
                                                        //                 for(int k = 0; k < surveyDetailsModel.question!.choices!.length; k++){
                                                        //                   for(int l = 0; l < surveyDetailsModel.question!.choices![k].options!.length; l++){
                                                        //                     if(surveyDetailsModel.question!.choices![k].options![l].select==0){
                                                        //                       selection=selection+1;
                                                        //                     }
                                                        //                   }
                                                        //                 }
                                                        //                 if(selection==surveyDetailsModel.question!.choices!.length){
                                                        //                   isFullNameChangeBtnState = true;
                                                        //                 }else{
                                                        //                   isFullNameChangeBtnState = false;
                                                        //                 }
                                                        //                 log(selection.toString());
                                                        //                 log(surveyDetailsModel.question!.choices!.length.toString());
                                                        //               });
                                                        //             },
                                                        //             child: Row(
                                                        //               crossAxisAlignment: CrossAxisAlignment.center,
                                                        //               mainAxisAlignment: MainAxisAlignment.end,
                                                        //               children: [
                                                        //                 // Text(surveyDetailsModel.question!.choices![index].options![i].option.toString()),
                                                        //                 Padding(
                                                        //                   padding:  EdgeInsets.only(left: 2.0,right: 5),
                                                        //                   child: Image
                                                        //                       .asset(
                                                        //                     surveyDetailsModel.question!.choices![index].options![i].select ==
                                                        //                         0
                                                        //                         ? 'images/radioonbutton.png'
                                                        //                         : 'images/radiobutton.png',
                                                        //                     width: 25,
                                                        //                     height: 25,
                                                        //                   ),
                                                        //                 ),
                                                        //                 Center(
                                                        //                   child: Container(
                                                        //                     width: MediaQuery.of(context).size.width/3.5,
                                                        //                     // height: 50,
                                                        //                     padding: const EdgeInsets.only(left: 4.0,right: 10),
                                                        //                     child: Text(
                                                        //                       surveyDetailsModel.question!.choices![index].options![i].option!,
                                                        //                       style: TextStyle(
                                                        //                         fontFamily: "Poppins",
                                                        //                         fontSize: 15,
                                                        //                         fontWeight: FontWeight.bold,
                                                        //                       ),
                                                        //                       textAlign: TextAlign.center,
                                                        //                       // overflow: TextOverflow.ellipsis,
                                                        //                     ),
                                                        //                   ),
                                                        //                 ),
                                                        //
                                                        //
                                                        //
                                                        //               ],
                                                        //             ),
                                                        //           ),
                                                        //         );
                                                        //       },
                                                        //
                                                        //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 2,mainAxisSpacing: 0,
                                                        //   crossAxisSpacing: 0,
                                                        //   mainAxisExtent: 40,
                                                        //   crossAxisCount:  surveyDetailsModel
                                                        //       .question!
                                                        //       .choices![index]
                                                        //       .options!
                                                        //       .length>3?2:2),
                                                        //
                                                        //   ),
                                                        // ),
                                                        subtitle: surveyDetailsModel
                                                                    .question!
                                                                    .choices![
                                                                        index]
                                                                    .answerType ==
                                                                "radio"
                                                            ? Container(
                                                                // height: surveyDetailsModel
                                                                //     .question!
                                                                //     .choices![index]
                                                                //     .options!
                                                                //     .length*50/1.3,
                                                                child: ListView
                                                                    .builder(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                  scrollDirection:
                                                                      Axis.vertical,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: surveyDetailsModel
                                                                      .question!
                                                                      .choices![
                                                                          index]
                                                                      .options!
                                                                      .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int i) {
                                                                    return InkWell(
                                                                      onTap: () {
                                                                        setState(
                                                                            () {
                                                                          for (int j =
                                                                                  0;
                                                                              j < surveyDetailsModel.question!.choices![index].options!.length;
                                                                              j++) {
                                                                            surveyDetailsModel
                                                                                .question!
                                                                                .choices![index]
                                                                                .options![j]
                                                                                .selct = -1;
                                                                          }
                                                                          surveyDetailsModel
                                                                              .question!
                                                                              .choices![index]
                                                                              .options![i]
                                                                              .selct = 0;
                                                                          int selection =
                                                                              0;
                                                                          for (int k =
                                                                                  0;
                                                                              k < surveyDetailsModel.question!.choices!.length;
                                                                              k++) {
                                                                            if (surveyDetailsModel.question!.choices![k].answerType ==
                                                                                "radio") {
                                                                              for (int l = 0;
                                                                                  l < surveyDetailsModel.question!.choices![k].options!.length;
                                                                                  l++) {
                                                                                if (surveyDetailsModel.question!.choices![k].options![l].select == 0) {
                                                                                  selection = selection + 1;
                                                                                }
                                                                              }
                                                                            } else if (surveyDetailsModel.question!.choices![k].answerType ==
                                                                                "checkbox") {
                                                                              int check =
                                                                                  0;
                                                                              for (int l = 0;
                                                                                  l < surveyDetailsModel.question!.choices![k].options!.length;
                                                                                  l++) {
                                                                                if (surveyDetailsModel.question!.choices![k].options![l].select == 0) {
                                                                                  check = 1;
                                                                                }
                                                                              }
                                                                              if (check ==
                                                                                  1) {
                                                                                selection = selection + 1;
                                                                              }
                                                                            }
                                                                          }
                                                                          if (selection ==
                                                                              surveyDetailsModel.question!.choices!.length) {
                                                                            isFullNameChangeBtnState =
                                                                                true;
                                                                          } else {
                                                                            isFullNameChangeBtnState =
                                                                                false;
                                                                          }
                                                                          log(selection
                                                                              .toString());
                                                                          log(surveyDetailsModel
                                                                              .question!
                                                                              .choices!
                                                                              .length
                                                                              .toString());
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width,
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                                10),
                                                                        decoration: BoxDecoration(
                                                                            color: AppColors
                                                                                .APP_LIGHT_BLUE_50,
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0)),
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            setState(
                                                                                () {
                                                                              for (int j = 0;
                                                                                  j < surveyDetailsModel.question!.choices![index].options!.length;
                                                                                  j++) {
                                                                                surveyDetailsModel.question!.choices![index].options![j].selct = -1;
                                                                              }
                                                                              surveyDetailsModel.question!.choices![index].options![i].selct =
                                                                                  0;
                                                                              int selection =
                                                                                  0;
                                                                              for (int k = 0;
                                                                                  k < surveyDetailsModel.question!.choices!.length;
                                                                                  k++) {
                                                                                if (surveyDetailsModel.question!.choices![k].answerType == "radio") {
                                                                                  for (int l = 0; l < surveyDetailsModel.question!.choices![k].options!.length; l++) {
                                                                                    if (surveyDetailsModel.question!.choices![k].options![l].select == 0) {
                                                                                      selection = selection + 1;
                                                                                    }
                                                                                  }
                                                                                } else if (surveyDetailsModel.question!.choices![k].answerType == "checkbox") {
                                                                                  int check = 0;
                                                                                  for (int l = 0; l < surveyDetailsModel.question!.choices![k].options!.length; l++) {
                                                                                    if (surveyDetailsModel.question!.choices![k].options![l].select == 0) {
                                                                                      check = 1;
                                                                                    }
                                                                                  }
                                                                                  if (check == 1) {
                                                                                    selection = selection + 1;
                                                                                  }
                                                                                }
                                                                              }
                                                                              if (selection ==
                                                                                  surveyDetailsModel.question!.choices!.length) {
                                                                                isFullNameChangeBtnState = true;
                                                                              } else {
                                                                                isFullNameChangeBtnState = false;
                                                                              }
                                                                              log(selection.toString());
                                                                              log(surveyDetailsModel.question!.choices!.length.toString());
                                                                            });
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              // Text(surveyDetailsModel.question!.choices![index].options![i].option.toString()),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(left: 2.0, right: 5, bottom: 10),
                                                                                child: Image.asset(
                                                                                  surveyDetailsModel.question!.choices![index].options![i].select == 0 ? 'images/radioonbutton.png' : 'images/radiobutton.png',
                                                                                  width: 25,
                                                                                  height: 25,
                                                                                ),
                                                                              ),
                                                                              Flexible(
                                                                                child: Container(
                                                                                  width: MediaQuery.of(context).size.width,
                                                                                  padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 0, top: 3),
                                                                                  child: Text(
                                                                                    surveyDetailsModel.question!.choices![index].options![i].option!,
                                                                                    style: TextStyle(
                                                                                      fontFamily: "Poppins",
                                                                                      fontSize: 15,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                    textAlign: TextAlign.start,
                                                                                    // overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              )
                                                            : surveyDetailsModel
                                                                        .question!
                                                                        .choices![
                                                                            index]
                                                                        .answerType ==
                                                                    "checkbox"
                                                                ? Container(
                                                                    // height: surveyDetailsModel
                                                                    //     .question!
                                                                    //     .choices![index]
                                                                    //     .options!
                                                                    //     .length*50/1.3,
                                                                    child: ListView
                                                                        .builder(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10),
                                                                      physics:
                                                                          NeverScrollableScrollPhysics(),
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount: surveyDetailsModel
                                                                          .question!
                                                                          .choices![
                                                                              index]
                                                                          .options!
                                                                          .length,
                                                                      itemBuilder:
                                                                          (BuildContext
                                                                                  context,
                                                                              int i) {
                                                                        return Container(
                                                                          padding:
                                                                              EdgeInsets.all(10),
                                                                          decoration: BoxDecoration(
                                                                              color:
                                                                                  AppColors.APP_LIGHT_BLUE_50,
                                                                              borderRadius: BorderRadius.circular(5.0)),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                // for (int j = 0; j < surveyDetailsModel.question!.choices![index].options!.length; j++) {
                                                                                //   surveyDetailsModel.question!.choices![index].options![j].selct = -1;
                                                                                // }
                                                                                // surveyDetailsModel.question!.choices![index].options![i].selct = 0;
                                                                                if (surveyDetailsModel.question!.choices![index].options![i].select == 0) {
                                                                                  surveyDetailsModel.question!.choices![index].options![i].selct = -1;
                                                                                } else {
                                                                                  surveyDetailsModel.question!.choices![index].options![i].selct = 0;
                                                                                }
                                                                                int selection = 0;
                                                                                for (int k = 0; k < surveyDetailsModel.question!.choices!.length; k++) {
                                                                                  if (surveyDetailsModel.question!.choices![k].answerType == "radio") {
                                                                                    for (int l = 0; l < surveyDetailsModel.question!.choices![k].options!.length; l++) {
                                                                                      if (surveyDetailsModel.question!.choices![k].options![l].select == 0) {
                                                                                        selection = selection + 1;
                                                                                      }
                                                                                    }
                                                                                  } else if (surveyDetailsModel.question!.choices![k].answerType == "checkbox") {
                                                                                    int check = 0;
                                                                                    for (int l = 0; l < surveyDetailsModel.question!.choices![k].options!.length; l++) {
                                                                                      if (surveyDetailsModel.question!.choices![k].options![l].select == 0) {
                                                                                        check = 1;
                                                                                      }
                                                                                    }
                                                                                    if (check == 1) {
                                                                                      selection = selection + 1;
                                                                                    }
                                                                                  }
                                                                                }
                                                                                if (selection == surveyDetailsModel.question!.choices!.length) {
                                                                                  isFullNameChangeBtnState = true;
                                                                                } else {
                                                                                  isFullNameChangeBtnState = false;
                                                                                }
                                                                                log(selection.toString());
                                                                                log(surveyDetailsModel.question!.choices!.length.toString());
                                                                              });
                                                                            },
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap:
                                                                                  () {
                                                                                setState(() {
                                                                                  // for (int j = 0; j < surveyDetailsModel.question!.choices![index].options!.length; j++) {
                                                                                  //   surveyDetailsModel.question!.choices![index].options![j].selct = -1;
                                                                                  // }
                                                                                  // surveyDetailsModel.question!.choices![index].options![i].selct = 0;
                                                                                  if (surveyDetailsModel.question!.choices![index].options![i].select == 0) {
                                                                                    surveyDetailsModel.question!.choices![index].options![i].selct = -1;
                                                                                  } else {
                                                                                    surveyDetailsModel.question!.choices![index].options![i].selct = 0;
                                                                                  }
                                                                                  int selection = 0;
                                                                                  for (int k = 0; k < surveyDetailsModel.question!.choices!.length; k++) {
                                                                                    if (surveyDetailsModel.question!.choices![k].answerType == "radio") {
                                                                                      for (int l = 0; l < surveyDetailsModel.question!.choices![k].options!.length; l++) {
                                                                                        if (surveyDetailsModel.question!.choices![k].options![l].select == 0) {
                                                                                          selection = selection + 1;
                                                                                        }
                                                                                      }
                                                                                    } else if (surveyDetailsModel.question!.choices![k].answerType == "checkbox") {
                                                                                      int check = 0;
                                                                                      for (int l = 0; l < surveyDetailsModel.question!.choices![k].options!.length; l++) {
                                                                                        if (surveyDetailsModel.question!.choices![k].options![l].select == 0) {
                                                                                          check = 1;
                                                                                        }
                                                                                      }
                                                                                      if (check == 1) {
                                                                                        selection = selection + 1;
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                  if (selection == surveyDetailsModel.question!.choices!.length) {
                                                                                    isFullNameChangeBtnState = true;
                                                                                  } else {
                                                                                    isFullNameChangeBtnState = false;
                                                                                  }
                                                                                  log(selection.toString());
                                                                                  log(surveyDetailsModel.question!.choices!.length.toString());
                                                                                });
                                                                              },
                                                                              child:
                                                                                  Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  // Text(surveyDetailsModel.question!.choices![index].options![i].option.toString()),
                                                                                  Padding(
                                                                                    padding: EdgeInsets.only(left: 2.0, right: 5, bottom: 10),
                                                                                    child: Image.asset(
                                                                                      surveyDetailsModel.question!.choices![index].options![i].select == 0 ? 'images/checkbox_checked.png' : 'images/checkbox.png',
                                                                                      width: 25,
                                                                                      height: 25,
                                                                                    ),
                                                                                  ),
                                                                                  Flexible(
                                                                                    child: Container(
                                                                                      width: MediaQuery.of(context).size.width,
                                                                                      // width: 70,
                                                                                      // height: 50,
                                                                                      padding: const EdgeInsets.only(left: 10.0, right: 20, top: 5, bottom: 10),
                                                                                      child: Text(
                                                                                        surveyDetailsModel.question!.choices![index].options![i].option!,
                                                                                        style: TextStyle(
                                                                                          fontFamily: "Poppins",
                                                                                          fontSize: 15,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                        textAlign: TextAlign.start,
                                                                                        // overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  )
                                                                : Container(),
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                    !isKeyboard?Container():Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
                      child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Flexible(
                                child: SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                        padding: const EdgeInsets.only(left: 20, right: 20),
                                        child: RaisedButton(
                                          shape: new RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(8.0),
                                              side: BorderSide(
                                                  color: AppColors.APP_LIGHT_GREY_20)),
                                          color: ((isFullNameChangeBtnState))
                                              ? AppColors.APP_LIGHT_BLUE
                                              : AppColors.APP_LIGHT_GREY_20,
                                          textColor: AppColors.APP_WHITE,
                                          padding: EdgeInsets.all(8.0),
                                          onPressed: () async {
                                            if (isFullNameChangeBtnState) {
                                              Answer answers = Answer();
                                              AnswerModel answermodel =
                                              AnswerModel(answers: []);
                                              List<Answer> answerslist = [];

                                              if (surveyDetailsModel.question!.answerType.toString() == "textbox") {
                                                for (int i = 0; i < surveyDetailsModel.question!.optionGroup!.length; i++) {
                                                  for (int j = 0; j < surveyDetailsModel.question!.optionGroup![i].optionGroups!.length; j++) {
                                                    if(surveyDetailsModel.question!.optionGroup![i].optionGroups![j].textEditingController!.text.trim().toString().length!=0){
                                                      setState(() {
                                                        isFullNameChangeBtnStateTextBox=true;
                                                      });
                                                    }
                                                    answermodel.answers.add(Answer(
                                                        optionId: int.parse(surveyDetailsModel
                                                            .question!
                                                            .optionGroup![i]
                                                            .optionGroups![j]
                                                            .optionId
                                                            .toString()),
                                                        optionNotes: surveyDetailsModel
                                                            .question!
                                                            .optionGroup![i]
                                                            .optionGroups![j]
                                                            .textEditingController!
                                                            .text
                                                            .trim()
                                                            .toString(),
                                                        questionId: int.parse(
                                                            surveyDetailsModel
                                                                .question!.questionId
                                                                .toString())));
                                                  }
                                                }
                                              } else if (surveyDetailsModel
                                                  .question!.answerType ==
                                                  "radio") {
                                                answers.questionId =
                                                surveyDetailsModel.question!.questionId!;
                                                for (int j = 0;
                                                j <
                                                    surveyDetailsModel
                                                        .question!.options!.length;
                                                j++) {
                                                  if (surveyDetailsModel
                                                      .question!.options![j].select ==
                                                      0) {
                                                    answermodel.answers.add(Answer(
                                                        optionId: int.parse(surveyDetailsModel
                                                            .question!.options![j].optionId
                                                            .toString()),
                                                        optionNotes: "",
                                                        questionId: int.parse(
                                                            surveyDetailsModel
                                                                .question!.questionId
                                                                .toString())));
                                                  }
                                                }
                                              } else if (surveyDetailsModel
                                                  .question!.answerType ==
                                                  "checkbox") {
                                                answers.questionId =
                                                surveyDetailsModel.question!.questionId!;
                                                for (int j = 0;
                                                j <
                                                    surveyDetailsModel
                                                        .question!.options!.length;
                                                j++) {
                                                  if (surveyDetailsModel
                                                      .question!.options![j].select ==
                                                      0) {
                                                    answermodel.answers.add(Answer(
                                                        optionId: int.parse(surveyDetailsModel
                                                            .question!.options![j].optionId
                                                            .toString()),
                                                        optionNotes: "",
                                                        questionId: int.parse(
                                                            surveyDetailsModel
                                                                .question!.questionId
                                                                .toString())));
                                                  }
                                                }
                                              } else if (surveyDetailsModel
                                                  .question!.answerType ==
                                                  "choices") {
                                                for (int i = 0;
                                                i <
                                                    surveyDetailsModel
                                                        .question!.choices!.length;
                                                i++) {
                                                  for (int k = 0;
                                                  k <
                                                      surveyDetailsModel.question!
                                                          .choices![i].options!.length;
                                                  k++) {
                                                    if (surveyDetailsModel.question!
                                                        .choices![i].options![k].select ==
                                                        0) {
                                                      answermodel.answers.add(Answer(
                                                          optionId: int.parse(
                                                              surveyDetailsModel
                                                                  .question!
                                                                  .choices![i]
                                                                  .options![k]
                                                                  .optionId
                                                                  .toString()),
                                                          optionNotes: "",
                                                          questionId: int.parse(
                                                              surveyDetailsModel.question!
                                                                  .choices![i].questionId
                                                                  .toString())));
                                                    }
                                                  }
                                                }
                                              }

                                              if(isFullNameChangeBtnStateTextBox){
                                                log(answermodel.toJson().toString());
                                                http.Response? response =
                                                await resourceRepository.submitanswers(
                                                    surveyDetailsModel.question!.questionId
                                                        .toString(),
                                                    answermodel);
                                                if (response!.statusCode == 200) {
                                                  SuccessModel successmodel =
                                                  SuccessModel.fromJson(json.decode(
                                                      utf8.decode(response.bodyBytes)));

                                                  if (successmodel.nextQuestionId == 0) {
                                                    if (surveyDetailsModel
                                                        .question!.nextQuestionId ==
                                                        surveyDetailsModel
                                                            .question!.questionId) {

                                                      if(!successmodel.hasPendingQuestions!){
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                          new MaterialPageRoute(
                                                              builder: (_) => new ScreenCheck(
                                                                title: globalTaskName,
                                                                id: globalTaskID
                                                                    .toString(),
                                                                page: "1",
                                                              )),
                                                        )
                                                            .then((val) {});
                                                      }else{
                                                        backPressed();
                                                      }
                                                    } else {
                                                      Navigator.of(context).pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SurveymenuDetails(
                                                                    questionId:
                                                                    surveyDetailsModel
                                                                        .question!
                                                                        .nextQuestionId
                                                                        .toString())),
                                                            (Route<dynamic> route) => false,
                                                      );
                                                    }
                                                  } else {
                                                    Navigator.of(context).pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SurveymenuDetails(
                                                                  questionId: successmodel
                                                                      .nextQuestionId
                                                                      .toString())),
                                                          (Route<dynamic> route) => false,
                                                    );
                                                  }
                                                }

                                              } else {
                                                // Fluttertoast.showToast(
                                                //     msg:
                                                //     "Please Fill answer to submit survey");
                                              }

                                            } else {
                                              // Fluttertoast.showToast(
                                              //     msg:
                                              //     "Please Choose all answer to submit survey");
                                            }
                                          },
                                          child: Padding(
                                              padding:
                                              const EdgeInsets.only(top: 10, bottom: 10),
                                              child: Text(
                                                (surveyDetailsModel
                                                    .question!.nextQuestionId ==
                                                    surveyDetailsModel
                                                        .question!.questionId)
                                                    ? tr('submit')
                                                    : tr('next'),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                        ))),
                                flex: 1,
                              ),
                            ],
                          )),
                    )
                  ],
                )),
          ),
        ),
        isKeyboard?Container():Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                                side: BorderSide(
                                    color: AppColors.APP_LIGHT_GREY_20)),
                            color: ((isFullNameChangeBtnState))
                                ? AppColors.APP_LIGHT_BLUE
                                : AppColors.APP_LIGHT_GREY_20,
                            textColor: AppColors.APP_WHITE,
                            padding: EdgeInsets.all(8.0),
                            onPressed: () async {
                              if (isFullNameChangeBtnState) {
                                Answer answers = Answer();
                                AnswerModel answermodel =
                                AnswerModel(answers: []);
                                List<Answer> answerslist = [];

                                if (surveyDetailsModel.question!.answerType.toString() == "textbox") {
                                  for (int i = 0; i < surveyDetailsModel.question!.optionGroup!.length; i++) {
                                    for (int j = 0; j < surveyDetailsModel.question!.optionGroup![i].optionGroups!.length; j++) {
                                      if(surveyDetailsModel.question!.optionGroup![i].optionGroups![j].textEditingController!.text.trim().toString().length!=0){
                                        setState(() {
                                          isFullNameChangeBtnStateTextBox=true;
                                        });
                                      }
                                      answermodel.answers.add(Answer(
                                          optionId: int.parse(surveyDetailsModel
                                              .question!
                                              .optionGroup![i]
                                              .optionGroups![j]
                                              .optionId
                                              .toString()),
                                          optionNotes: surveyDetailsModel
                                              .question!
                                              .optionGroup![i]
                                              .optionGroups![j]
                                              .textEditingController!
                                              .text.trim()
                                              .toString(),
                                          questionId: int.parse(
                                              surveyDetailsModel
                                                  .question!.questionId
                                                  .toString())));
                                    }
                                  }
                                } else if (surveyDetailsModel
                                    .question!.answerType ==
                                    "radio") {
                                  answers.questionId =
                                  surveyDetailsModel.question!.questionId!;
                                  for (int j = 0;
                                  j <
                                      surveyDetailsModel
                                          .question!.options!.length;
                                  j++) {
                                    if (surveyDetailsModel
                                        .question!.options![j].select ==
                                        0) {
                                      answermodel.answers.add(Answer(
                                          optionId: int.parse(surveyDetailsModel
                                              .question!.options![j].optionId
                                              .toString()),
                                          optionNotes: "",
                                          questionId: int.parse(
                                              surveyDetailsModel
                                                  .question!.questionId
                                                  .toString())));
                                    }
                                  }
                                } else if (surveyDetailsModel
                                    .question!.answerType ==
                                    "checkbox") {
                                  answers.questionId =
                                  surveyDetailsModel.question!.questionId!;
                                  for (int j = 0;
                                  j <
                                      surveyDetailsModel
                                          .question!.options!.length;
                                  j++) {
                                    if (surveyDetailsModel
                                        .question!.options![j].select ==
                                        0) {
                                      answermodel.answers.add(Answer(
                                          optionId: int.parse(surveyDetailsModel
                                              .question!.options![j].optionId
                                              .toString()),
                                          optionNotes: "",
                                          questionId: int.parse(
                                              surveyDetailsModel
                                                  .question!.questionId
                                                  .toString())));
                                    }
                                  }
                                } else if (surveyDetailsModel
                                    .question!.answerType ==
                                    "choices") {
                                  for (int i = 0;
                                  i <
                                      surveyDetailsModel
                                          .question!.choices!.length;
                                  i++) {
                                    for (int k = 0;
                                    k <
                                        surveyDetailsModel.question!
                                            .choices![i].options!.length;
                                    k++) {
                                      if (surveyDetailsModel.question!
                                          .choices![i].options![k].select ==
                                          0) {
                                        answermodel.answers.add(Answer(
                                            optionId: int.parse(
                                                surveyDetailsModel
                                                    .question!
                                                    .choices![i]
                                                    .options![k]
                                                    .optionId
                                                    .toString()),
                                            optionNotes: "",
                                            questionId: int.parse(
                                                surveyDetailsModel.question!
                                                    .choices![i].questionId
                                                    .toString())));
                                      }
                                    }
                                  }
                                }

                                if(isFullNameChangeBtnStateTextBox){
                                  log(answermodel.toJson().toString());
                                  http.Response? response =
                                  await resourceRepository.submitanswers(
                                      surveyDetailsModel.question!.questionId
                                          .toString(),
                                      answermodel);
                                  if (response!.statusCode == 200) {
                                    SuccessModel successmodel =
                                    SuccessModel.fromJson(json.decode(
                                        utf8.decode(response.bodyBytes)));

                                    if (successmodel.nextQuestionId == 0) {
                                      if (surveyDetailsModel
                                          .question!.nextQuestionId ==
                                          surveyDetailsModel
                                              .question!.questionId) {

                                        if(!successmodel.hasPendingQuestions!){
                                          Navigator.of(context)
                                              .pushReplacement(
                                            new MaterialPageRoute(
                                                builder: (_) => new ScreenCheck(
                                                  title: globalTaskName,
                                                  id: globalTaskID
                                                      .toString(),
                                                  page: "1",
                                                )),
                                          )
                                              .then((val) {});
                                        }else{
                                          backPressed();
                                        }

                                      } else {
                                        Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SurveymenuDetails(
                                                      questionId:
                                                      surveyDetailsModel
                                                          .question!
                                                          .nextQuestionId
                                                          .toString())),
                                              (Route<dynamic> route) => false,
                                        );
                                      }
                                    } else {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SurveymenuDetails(
                                                    questionId: successmodel
                                                        .nextQuestionId
                                                        .toString())),
                                            (Route<dynamic> route) => false,
                                      );
                                    }
                                  }

                                } else {
                                  // Fluttertoast.showToast(
                                  //     msg:
                                  //     "Please Fill answer to submit survey");
                                }

                              } else {
                                // Fluttertoast.showToast(
                                //     msg:
                                //     "Please Choose all answer to submit survey");
                              }
                            },
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  (surveyDetailsModel
                                              .question!.nextQuestionId ==
                                          surveyDetailsModel
                                              .question!.questionId)
                                      ? tr('submit')
                                      : tr('next'),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                          ))),
                  flex: 1,
                ),
              ],
            )),
          ),
        )
      ],
    );
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
}
