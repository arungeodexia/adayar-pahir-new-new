/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
  */
import 'dart:convert';

import 'package:ACI/Model/TrailInfoModel.dart';
import 'package:ACI/Model/appointment_details.dart';
import 'package:ACI/Model/taksmodel.dart';
import 'package:ACI/Screen/ScreenCheck.dart';
import 'package:ACI/data/api/repository/SurveyRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/calls_messages_services.dart';
import 'package:ACI/utils/constants.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:chewie/chewie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class DashboardThreePage extends StatefulWidget {
  static final String path = "lib/src/pages/dashboard/dash3.dart";

  @override
  State<DashboardThreePage> createState() => _DashboardThreePageState();
}

class _DashboardThreePageState extends State<DashboardThreePage> {
  final String avatar =
      "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F1.jpg?alt=media";

  final TextStyle whiteText = TextStyle(color: Colors.white);
  String username = "";

  String userImage = "";
  String isFirstTime = "";
  bool isload = false;
  static final SurveyRepo resourceRepository = new SurveyRepo();
  Taksmodel taskmodel = Taksmodel();
  TrailInfoModel trailInfoModel = TrailInfoModel();
  AppointmentDetails appointmentDetails = AppointmentDetails();
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  late Duration videoLength;
  late Duration videoPosition;
  double volume = 0.5;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserName();
    getsurvey(true);
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController.dispose();
  }

  void gettrailvideo() async {
    http.Response? response = await resourceRepository.getTrailInfo();
    if (response!.statusCode == 200) {
      trailInfoModel =
          TrailInfoModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));

      if (trailInfoModel.infoMediaUrLs!.length != 0) {

           // videoPlayerController = VideoPlayerController.network(
           //    "https://firebasestorage.googleapis.com/v0/b/aci-geodexia.appspot.com/o/WhatsApp%20Video%202022-05-05%20at%209.31.36%20AM.mp4?alt=media&token=a065df6f-f2cf-4fd2-84d2-c976f9d26896")
           //    // trailInfoModel.infoMediaUrLs![0].toString())
           //  ..addListener(() => setState(() {
           //        videoPosition = videoPlayerController.value.position;
           //        print("listernervideo");
           //      }))
           //  ..initialize().then((_) => setState(() {
           //    print("initializevideo");
           //    videoPlayerController.play();
           //    videoPlayerController.setLooping(false);
           //    videoLength = videoPlayerController.value.duration;
           //      }));




           _controller = VideoPlayerController.network(
             trailInfoModel.infoMediaUrLs![0].toString(),
           );

           // Initialize the controller and store the Future for later use.
           _initializeVideoPlayerFuture = _controller.initialize();

           // Use the controller to loop the video.
           _controller.setLooping(true);
           _controller.play();
           chewieController = ChewieController(
             videoPlayerController: _controller,
             autoInitialize: true,
             allowMuting: true,
             showControlsOnInitialize: true,
             looping: false,
             autoPlay: true,
           );

          // Get.dialog(
          //
          //
          //
          //
          //
          //
          //   FutureBuilder(
          //   future: _initializeVideoPlayerFuture,
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       // If the VideoPlayerController has finished initialization, use
          //       // the data it provides to limit the aspect ratio of the video.
          //       return SizedBox.expand(
          //         child:  AspectRatio(
          //           aspectRatio: 16 / 9,
          //           child: Chewie(
          //             controller: chewieController,
          //           ),
          //         )
          //       );
          //       return AspectRatio(
          //         aspectRatio: _controller.value.aspectRatio,
          //         // Use the VideoPlayer widget to display the video.
          //         child: VideoPlayer(_controller),
          //       );
          //     } else {
          //       // If the VideoPlayerController is still initializing, show a
          //       // loading spinner.
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //   },
          // ),
          // );
          showGeneralDialog(
            context: context,
            barrierColor: Colors.black12.withOpacity(0.6), // Background color
            barrierDismissible: false,
            barrierLabel: 'Trail Videos',
            transitionDuration: Duration(milliseconds: 400),
            pageBuilder: (_, __, ___) {
              return WillPopScope(
                onWillPop: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString(IS_FIRST_TIME, "1st");
                  Navigator.pop(context);
                  videoPlayerController.pause();
                  return false;
                },
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: SizedBox.expand(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  AppColors.APP_BLUE),
                            ),
                            onPressed: () {},
                            child: Center(child: Text('Trail')),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 12,
                        child:
                        FutureBuilder(
                          future: _initializeVideoPlayerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              // If the VideoPlayerController has finished initialization, use
                              // the data it provides to limit the aspect ratio of the video.
                              return SizedBox.expand(
                                  child:  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Chewie(
                                      controller: chewieController,
                                    ),
                                  )
                              );
                              return AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                // Use the VideoPlayer widget to display the video.
                                child: VideoPlayer(_controller),
                              );
                            } else {
                              // If the VideoPlayerController is still initializing, show a
                              // loading spinner.
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),

                      ),

                      // Expanded(
                      //   flex: 12,
                      //   child: SizedBox.expand(child:  videoPlayerController.value.isInitialized
                      //       ? AspectRatio(
                      //     aspectRatio: 16 / 9,
                      //     child: VideoPlayer(
                      //       videoPlayerController,
                      //     ),
                      //   )
                      //       : Center(
                      //     child: CircularProgressIndicator(),
                      //   ),),
                      // ),
                      Expanded(
                        flex: 1,
                        child: SizedBox.expand(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  AppColors.APP_BLUE),
                            ),
                            onPressed: () async {
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              prefs.setString(IS_FIRST_TIME, "1st");
                              Navigator.pop(context);
                              videoPlayerController.pause();
                            },
                            child: Text('Dismiss'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        // EasyLoading.showSuccess('Successful');

    }
  }

  void getsurvey(bool load) async {
    if (load) {
      isload = load;
      setState(() {});
    }

    // await EasyLoading.show(status: 'Loading...',maskType: EasyLoadingMaskType.black);
    http.Response? response = await resourceRepository.getTasks();
    if (response!.statusCode == 200) {
      taskmodel =
          Taksmodel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      // EasyLoading.showSuccess('Successful');
    } else {
      // EasyLoading.showError('API Exception');
    }

    http.Response? response1 = await resourceRepository.getAppointments();
    if (response1!.statusCode == 200) {
      appointmentDetails = AppointmentDetails.fromJson(
          json.decode(utf8.decode(response1.bodyBytes)));
    }

    setState(() {
      isload = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.APP_WHITE,
      body: isload ? buildLoading() : _buildBody(context),
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

  getuserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String res = prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString();
    isFirstTime = prefs.getString(IS_FIRST_TIME).toString();
    print(isFirstTime);
    if (isFirstTime.length == 4) {
      gettrailvideo();
    }

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

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          appointmentDetails.name.toString() != "null"
              ? _buildHeaderNewUi()
              : _buildHeaderNoAppointment(),
          // const SizedBox(height: 20.0),

          // Row(
          //   children: [
          //     GestureDetector(
          //       child: Container(
          //         padding: EdgeInsets.only(top: 7, bottom: 7,left: 25,right: 20),
          //         margin: EdgeInsets.all(8),
          //         child: CircleAvatar(
          //             radius: 38.0,
          //             backgroundColor: AppColors.APP_LIGHT_BLUE,
          //             backgroundImage:  appointmentDetails.picture.toString()!="null"&&appointmentDetails.picture != ""
          //                 ? NetworkImage(appointmentDetails.picture.toString())
          //                 : AssetImage("images/photo_avatar.png") as ImageProvider),
          //       ),
          //
          //       onTap: () {
          //
          //       },
          //     ),
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.all(3),
          //           child: Text(
          //             appointmentDetails.name.toString()+"  "+appointmentDetails.designation.toString(),
          //             overflow: TextOverflow.ellipsis,
          //             softWrap: false,
          //             maxLines: 3,
          //             style: kSubtitleTextSyule1.copyWith(
          //                 fontWeight: FontWeight.w600,
          //                 height: 1,
          //                 color: AppColors.APP_BLUE
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.all(3),
          //           child: Text(
          //             appointmentDetails.institute.toString(),
          //             overflow: TextOverflow.ellipsis,
          //             softWrap: false,
          //             maxLines: 3,
          //             style:kSubtitleTextSyule1.copyWith(
          //                 fontWeight: FontWeight.w600,
          //                 height: 1,
          //                 color: AppColors.APP_BLUE
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.all(3),
          //           child: Text(
          //             appointmentDetails.address.toString(),
          //             overflow: TextOverflow.ellipsis,
          //             softWrap: false,
          //             maxLines: 3,
          //             style: kSubtitleTextSyule1.copyWith(
          //                 fontWeight: FontWeight.w600,
          //                 height: 1,
          //                 color: AppColors.APP_BLUE
          //             ),
          //           ),
          //         ),
          //         GestureDetector(
          //           onTap: (){
          //             CallsAndMessagesService.call(appointmentDetails.phone1.toString().replaceAll(' ', ''));
          //           },
          //           child: Row(
          //             children: [
          //               CircleAvatar(backgroundColor: AppColors.APP_WHITE,radius: 15,child: Icon(FontAwesomeIcons.phoneAlt,color: AppColors.APP_BLUE,size: 18,)),
          //               Padding(
          //                 padding: const EdgeInsets.only(top: 5,bottom: 5,left: 5),
          //                 child: Text(
          //                   appointmentDetails.phone1.toString(),
          //                   overflow: TextOverflow.ellipsis,
          //                   softWrap: false,
          //                   maxLines: 3,
          //                   style: kSubtitleTextSyule1.copyWith(
          //                       fontWeight: FontWeight.w600,
          //                       height: 1,
          //                       color: AppColors.APP_BLUE
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          appointmentDetails.name.toString() == "null"
              ? Container()
              : Padding(
                  padding:
                      EdgeInsets.only(top: 7, bottom: 7, left: 40, right: 40),
                  child: Divider(
                    height: 5,
                    thickness: 1,
                  ),
                ),
          Padding(
            padding: EdgeInsets.only(top: 7, bottom: 7),
            child: Container(
                padding: const EdgeInsets.only(
                  left: 40,
                  top: 7,
                  right: 15,
                  bottom: 7,
                ),
                // decoration: BoxDecoration(
                //     color: AppColors.APP_LIGHT_BLUE,
                //     borderRadius: BorderRadius.only(
                //         bottomRight: Radius.circular(16.0),
                //         topRight: Radius.circular(16.0))),
                child: Text(
                  tr("programs"),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.APP_BLUE1),
                )),
          ),
          taskmodel.tasks != null || taskmodel.tasks.toString() != "null"
              ? ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  itemCount: taskmodel.tasks!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Hero(
                      tag: taskmodel.tasks![index].taskId.toString(),
                      child: Card(
                        color: AppColors.APP_BLUE1,
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                                  new MaterialPageRoute(
                                      builder: (_) => new ScreenCheck(
                                            title: taskmodel
                                                .tasks![index].taskTitle
                                                .toString(),
                                            id: taskmodel.tasks![index].taskId
                                                .toString(),
                                            page: "0",
                                          )),
                                )
                                .then((val) => getsurvey(false));
                            globalTaskID = taskmodel.tasks![index].taskId!;
                          },
                          title: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              taskmodel.tasks![index].taskTitle.toString(),
                              style: kSubtitleTextSyule1.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                  color: Colors.white),
                            ),
                          ),
                          trailing: Text(
                            taskmodel.tasks![index].completionPercentage
                                .toString(),
                            style: kSubtitleTextSyule1.copyWith(
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  })
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child:
                              Lottie.asset('assets/nodata.json', height: 250)),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          tr("nopprograms"),
                          style: kSubtitleTextSyule1.copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              color: AppColors.APP_GREY),
                        ),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }

  Container _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 32.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        color: AppColors.APP_BLUE1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Center(
                    child: Text(
                      appointmentDetails.appointmentType.toString(),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                          color: Colors.white,
                          fontSize: 22),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Center(
                    child: Text(
                      appointmentDetails.appointmentDateFormatted.toString(),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Center(
                    child: Text(
                      appointmentDetails.appointmentTime.toString(),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Center(
                    child: Text(
                      appointmentDetails.appointmentDuration.toString(),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            // trailing: CircleAvatar(
            //   radius: 25.0,
            //   backgroundImage: NetworkImage(avatar),
            // ),
          ),
        ],
      ),
    );
  }

  Container _buildHeaderNewUi() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10.0, 10, 10.0),
      margin: const EdgeInsets.all(
        10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.APP_BLUE1,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: GestureDetector(
              child: Container(
                child: CircleAvatar(
                    radius: 30.0,
                    backgroundColor: AppColors.APP_LIGHT_BLUE,
                    backgroundImage: appointmentDetails.picture.toString() !=
                                "null" &&
                            appointmentDetails.picture != ""
                        ? NetworkImage(appointmentDetails.picture.toString())
                        : AssetImage("images/photo_avatar.png")
                            as ImageProvider),
              ),
              onTap: () {},
            ),
            title: Text(
              appointmentDetails.name.toString(),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              maxLines: 3,
              style: kSubtitleTextSyule1.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                  color: Colors.white,
                  fontSize: 22),
            ),
            subtitle: Row(
              children: [
                Text(
                  appointmentDetails.address.toString(),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 3,
                  style: kSubtitleTextSyule1.copyWith(
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: Colors.white,
                      fontSize: 16),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      CallsAndMessagesService.call(appointmentDetails.phone1
                          .toString()
                          .replaceAll(' ', ''));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: IconButton(
                          onPressed: () {
                            CallsAndMessagesService.call(appointmentDetails
                                .phone1
                                .toString()
                                .replaceAll(' ', ''));
                          },
                          icon: Row(
                            children: [
                              CircleAvatar(
                                  backgroundColor: AppColors.APP_WHITE,
                                  radius: 10,
                                  child: Icon(
                                    FontAwesomeIcons.phoneAlt,
                                    color: AppColors.APP_BLUE,
                                    size: 12,
                                  )),
                              Text(
                                '  Call',
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: kSubtitleTextSyule1.copyWith(
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                    color: Colors.white,
                                    fontSize: 14),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ],
            ),
            // trailing: CircleAvatar(
            //   radius: 25.0,
            //   backgroundImage: NetworkImage(avatar),
            // ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.APP_WHITE.withOpacity(0.2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.timer_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      appointmentDetails.appointmentTime.toString(),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                          color: Colors.white,
                          fontSize: 15),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.date_range, color: Colors.white),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      appointmentDetails.appointmentDateFormatted.toString(),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                          color: Colors.white,
                          fontSize: 15),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                )
              ],
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(left: 15),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //
          //       Padding(
          //         padding: const EdgeInsets.all(5),
          //         child: Text(
          //           appointmentDetails.institute.toString(),
          //           overflow: TextOverflow.ellipsis,
          //           softWrap: false,
          //           maxLines: 3,
          //           style:kSubtitleTextSyule1.copyWith(
          //               fontWeight: FontWeight.w600,
          //               height: 1,
          //               color: AppColors.APP_WHITE
          //           ),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(5),
          //         child: Text(
          //           appointmentDetails.address.toString(),
          //           overflow: TextOverflow.ellipsis,
          //           softWrap: false,
          //           maxLines: 3,
          //           style: kSubtitleTextSyule1.copyWith(
          //               fontWeight: FontWeight.w600,
          //               height: 1,
          //               color: AppColors.APP_WHITE
          //           ),
          //         ),
          //       ),
          //       SizedBox(height: 5,),
          //       GestureDetector(
          //         onTap: (){
          //           CallsAndMessagesService.call(appointmentDetails.phone1.toString().replaceAll(' ', ''));
          //         },
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             CircleAvatar(backgroundColor: AppColors.APP_WHITE,radius: 15,child: Icon(FontAwesomeIcons.phoneAlt,color: AppColors.APP_BLUE,size: 18,)),
          //             Padding(
          //               padding: const EdgeInsets.only(top: 5,bottom: 5,left: 5),
          //               child: Text(
          //                 appointmentDetails.phone1.toString(),
          //                 overflow: TextOverflow.ellipsis,
          //                 softWrap: false,
          //                 maxLines: 3,
          //                 style: kSubtitleTextSyule1.copyWith(
          //                     fontWeight: FontWeight.w600,
          //                     height: 1,
          //                     color: AppColors.APP_WHITE
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Container _buildHeaderNoAppointment() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10.0, 10, 10.0),
      margin: const EdgeInsets.all(
        10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.APP_BLUE1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Center(
                    child: Text(
                      tr("noappo"),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            // trailing: CircleAvatar(
            //   radius: 25.0,
            //   backgroundImage: NetworkImage(avatar),
            // ),
          ),
        ],
      ),
    );
  }
}
