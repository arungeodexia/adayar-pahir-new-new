import 'dart:convert';
import 'dart:developer';

import 'package:ACI/Model/task_details.dart';
import 'package:ACI/Screen/surveymenuDetails.dart';
import 'package:ACI/data/api/repository/SurveyRepo.dart';
import 'package:ACI/utils/calls_messages_services.dart';
import 'package:ACI/utils/constants.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mydashboard.dart';

class ScreenCheck extends StatefulWidget {
  final String title;
  final String id;
  final String page;

  ScreenCheck(
      {Key? key, required this.title, required this.id, required this.page})
      : super(key: key);

  @override
  _ScreenCheckState createState() {
    return _ScreenCheckState();
  }
}

class _ScreenCheckState extends State<ScreenCheck> {
  var isFullNameChangeBtnState = true;
  String formattedDate = "";
  String date = "";
  String month = "";

  Map<String, double> dataMap = {
    "A": 65,
  };
  final gradientList = <List<Color>>[
    [
      Color.fromRGBO(223, 250, 92, 1),
      Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      Color.fromRGBO(129, 182, 205, 1),
      Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      Color.fromRGBO(175, 63, 62, 1.0),
      Color.fromRGBO(254, 154, 92, 1),
    ]
  ];
  final colorList = <Color>[
    Color(0xfffdcb6e),
    Color(0xff0984e3),
    Color(0xfffd79a8),
    Color(0xffe17055),
    Color(0xff6c5ce7),
  ];

  static final SurveyRepo resourceRepository = new SurveyRepo();
  bool isload = false;
  TaskDetails taskDetails = TaskDetails();
  String taskpercentage = "0";
  String expiry = "0";

  String? language ="";

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    DateTime now = DateTime.now();
    formattedDate = DateFormat(' MMMM d, yyyy').format(now);
    month = DateFormat('h:mm a').format(now).toUpperCase();

    // month=DateFormat('MMMM').format(now);
    // date=DateFormat('d').format(now);


    getsurvey();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getsurvey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     language = prefs.getString("locale");
    isload = true;
    setState(() {
    });
    http.Response? response =
        await resourceRepository.getTasksDetails(widget.id);
    if (response!.statusCode == 200) {
      taskDetails =
          TaskDetails.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      if (int.parse(taskDetails.completionPercentage
              .toString()
              .replaceAll("%", "")) >=
          100) {
        taskpercentage = "0.99999";
        isFullNameChangeBtnState = false;
      } else {
        taskpercentage = "0." +
            taskDetails.completionPercentage.toString().replaceAll("%", "");
      }
    }

    // DateTime date1 = DateTime.parse("2020-01-09 23:00:00.299871");
    // DateTime date2 = DateTime.parse("2020-01-10 00:00:00.299871");
    // log(daysBetween(date1, date2).toString());
    // //the birthday's date
    if (taskDetails.expiry != null) {
      try {
        var split = taskDetails.expiry!.split("-");
        final birthday = DateTime(
            int.parse(split[0]), int.parse(split[1]), int.parse(split[2]));
        final date3 = DateTime.now();
        final difference = date3.difference(birthday).inDays;
        expiry = difference.toString();
        log(difference.toString());
        log(int.parse(split[2]).toString() +
            int.parse(split[1]).toString() +
            int.parse(split[0]).toString());
      } catch (e) {}
    }
    setState(() {
      isload = false;
    });
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Hero(
      tag: widget.id,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Mydashboard()),
              (Route<dynamic> route) => false,
            ),
          ),
          centerTitle: true, // this is all you need
          title: Text(
            widget.title == "null"
                ? taskDetails.taskTitle.toString()
                : widget.title.toString(),
            style: kSubheadingextStyle.copyWith(color: AppColors.APP_WHITE),
          ),
          // leading: Icon(FontAwesomeIcons.solidArrowAltCircleLeft,color: AppColors.APP_BLUE,),
        ),
        body: isload || taskDetails.description ==null
            ? buildLoading()
            :  Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.page == "1"
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    left: 25,
                                    top: 15,
                                    right: 15,
                                    bottom: 0,
                                  ),
                                  child: Center(
                                    child: Lottie.asset('assets/success.json',
                                        repeat: false, height: 150),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                    left: 25,
                                    top: 15,
                                    right: 15,
                                    bottom: 0,
                                  ),
                                  child: Center(
                                    child: new CircularPercentIndicator(
                                      radius: 150.0,
                                      animation: true,
                                      animationDuration: 1200,
                                      lineWidth: 15.0,
                                      circularStrokeCap: CircularStrokeCap.round,

                                      percent: double.parse(taskpercentage),
                                      center: new Text(
                                        taskDetails.completionPercentage??'',
                                        style: kSubtitleTextSyule.copyWith(
                                            fontWeight: FontWeight.bold,
                                            height: 1.5,
                                            color: AppColors.APP_BLUE,
                                            fontSize: 25),
                                      ),
                                      backgroundColor: AppColors.APP_LIGHT_BLUE,
                                      progressColor: AppColors.APP_GREEN,
                                    ),
                                  ),
                                ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 0,
                                top: 25,
                                right: 0,
                                bottom: 0,
                              ),
                              child: Text(
                                formattedDate + " at " + month,
                                style: kTitleTextStyle.copyWith(
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                    color: AppColors.APP_BLUE),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                top: 7,
                                right: 15,
                                bottom: 15,
                              ),
                              child: Text(
                                taskDetails.expiryText??'',
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                style: kTitleTextStyle.copyWith(
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                    color: AppColors.APP_BLUE,
                                   ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 5,
                            thickness: 1,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 7, bottom: 0),
                            child: Container(
                                padding: const EdgeInsets.only(
                                  left: 25,
                                  top: 7,
                                  right: 15,
                                  bottom: 0,
                                ),
                                // decoration: BoxDecoration(
                                //     color: AppColors.APP_LIGHT_BLUE,
                                //     borderRadius: BorderRadius.only(
                                //         bottomRight: Radius.circular(16.0),
                                //         topRight: Radius.circular(16.0))),
                                child: Text(
                                  widget.page == "1"
                                      ? taskDetails.alternateDescription
                                          ?? taskDetails.taskTitle.toString()
                                      : "${language=='en'?"About ":" "} ${widget.title == "null" ? taskDetails.taskTitle.toString() : widget.title.toString()} ${language=='ta'?" பற்றி ":" "} ",

                                  style: kTitleTextStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      height: 1.5,
                                      color: AppColors.APP_BLUE),
                                  textAlign: TextAlign.start,
                                )),
                          ),
                          widget.page == "1"?Container():Padding(
                            padding: EdgeInsets.only(top: 7, bottom: 0),
                            child: Container(
                                padding: const EdgeInsets.only(
                                  left: 25,
                                  top: 0,
                                  right: 15,
                                  bottom: 7,
                                ),
                                child: Text(
                                  taskDetails.description??'',
                                  style: kSubtitleTextSyule1.copyWith(
                                      fontWeight: FontWeight.w600,
                                      height: 1.5,
                                      color: AppColors.APP_BLUE,
                                      fontSize: 14),
                                )),
                          ),
                          Container(
                            // color: AppColors.APP_WHITE,
                            padding:
                                const EdgeInsets.fromLTRB(4.0, 20.0, 8.0, 20.0),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Flexible(
                                  child: SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: RaisedButton(
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        8.0),
                                                side: BorderSide(
                                                    color: AppColors.APP_BLUE)),
                                            color: ((isFullNameChangeBtnState))
                                                ? AppColors.APP_BLUE
                                                : widget.page == "1"
                                                    ? AppColors.APP_BLUE
                                                    : AppColors.APP_LIGHT_GREY,
                                            textColor: AppColors.APP_WHITE,
                                            padding: EdgeInsets.all(8.0),
                                            onPressed: () async {
                                              if (widget.page == "1") {
                                                // Navigator.of(context).pop();
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Mydashboard()),
                                                  (Route<dynamic> route) =>
                                                      false,
                                                );
                                              } else {
                                                if (isFullNameChangeBtnState) {
                                                  // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                                  //     builder: (context) => SurveymenuDetails(questionId: taskDetails
                                                  //         .nextQuestionId
                                                  //         .toString())), (Route<dynamic> route) => false,);

                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                        new MaterialPageRoute(
                                                            builder: (_) =>
                                                                SurveymenuDetails(
                                                                  questionId: taskDetails
                                                                      .nextQuestionId
                                                                      .toString(),
                                                                )),
                                                      )
                                                      .then(
                                                          (val) => getsurvey());
                                                }
                                              }
                                            },
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: Text(
                                                  (widget.page == "1")
                                                      ? tr('ok')
                                                      : tr('continue'),
                                                  style: kSubtitleTextSyule1
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          height: 1.5,
                                                          color: Colors.white),
                                                )),
                                          ))),
                                  flex: 1,
                                ),
                              ],
                            )),
                          )
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
