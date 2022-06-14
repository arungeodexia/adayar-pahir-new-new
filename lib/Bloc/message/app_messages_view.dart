import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ACI/utils/calls_messages_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ACI/Bloc/message/app_messages_bloc.dart';
import 'package:ACI/Screen/BGVideoPlayerView.dart';
import 'package:ACI/data/api/repository/ResourceRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/unreadchat/fullphoto.dart';
import 'package:ACI/utils/PdfViewer.dart';
import 'package:ACI/utils/VideoApp.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:lottie/lottie.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/VideoAppChewie.dart';
import 'message_model_class.dart';

class AppMessagesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppMessagesViewState();
}

class AppPropertiesBloc {
  StreamController<String> _title = StreamController<String>();

  Stream<String> get titleStream => _title.stream;

  updateTitle(String newTitle) {
    _title.sink.add(newTitle);
  }

  dispose() {
    _title.close();
  }
}

class AppMessagesViewState extends State<AppMessagesView> {
  MessagesModel messageResponse = MessagesModel();
  late SharedPreferences prefs;
  ResourceRepo resourceRepository = ResourceRepo();

  String fileName = "";
  String username = "";
  String userImage = "";
  String messageid = "";
  String reaction = "";
  String reactionid = "";

  @override
  void initState() {
    _fetchProfileData();
    getuserName();

    super.initState();
  }

  _fetchProfileData() async {
    prefs = await SharedPreferences.getInstance();
    String profiledata =
    (prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA) ?? "emp");

    final otpVerifyResponse = json.decode(profiledata);
    globalPhoneNo = otpVerifyResponse['mobile'];
    globalCountryCode = otpVerifyResponse['countryCode'];

    print(globalCountryCode.toString() + " " + globalPhoneNo.toString());
    BlocProvider.of<AppMessagesBloc>(context).add(FetchMessages(
        countryCode: globalCountryCode, mobileNumber: globalPhoneNo));
  }

  final appBloc = AppPropertiesBloc();

  var _appMessageKey = GlobalKey<FormState>();

  getuserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final resourceDetailsResponse =
    json.decode(prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString());

    setState(() {
      username = resourceDetailsResponse['firstName'];
      // userImage = prefs!.prefsget(USER_PROFILE_IMAGE_64) ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    globalcontext = context;
    return Scaffold(
//         appBar: AppBar(
//             title: StreamBuilder<Object>(
//                 stream: appBloc.titleStream,
//                 initialData: AppStrings.APP_MESSAGES_TITLE,
//                 builder: (context, snapshot) {
//                   return Text(snapshot.data.toString());
//                 }),
//             centerTitle: true,
//             automaticallyImplyLeading: true,
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back),
//               onPressed: () {
// //              Navigator.pushReplacementNamed(
// //                  context, AppRoutes.APP_ROUTE_MY_DASHBOARD);
//                 Navigator.pop(context);
//               },
//             )),
        backgroundColor: AppColors.APP_WHITE,
        body: BlocListener<AppMessagesBloc, AppMessagesState>(
          listener: (context, state) {},
          child: BlocBuilder<AppMessagesBloc, AppMessagesState>(
            builder: (context, state) {
              if (state is MessagesFetchSuccess) {
                appBloc.updateTitle(AppStrings.APP_MESSAGES_TITLE);
                messageResponse = state.messageResponse;
                return showForm();
              } else if (state is MessagesFetching) {
                return buildLoading();
              } else {
                appBloc.updateTitle(AppStrings.APP_MESSAGES_TITLE);
                return buildLoading();
              }
            },
          ),
        ));
  }

  Widget buildloading() {
    return Container(
      height:
      MediaQuery.of(context).size.height - (AppBar().preferredSize.height),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget showForm() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
      child: messageResponse != null && messageResponse.messages!.length > 0
          ? ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(0.0),
          itemCount: messageResponse.messages!.length,
          itemBuilder: (_, index) {
            return _buildMessageCard(index, messageResponse);
          })
          : Center(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset('assets/nodata.json'),
            SizedBox(height: 50,),
            Text(
              tr("nomsg"),
              textAlign: TextAlign.center,
              style: ktextstyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard(int index, MessagesModel messageList) {
    String date = '';
    try {
      date = messageList.messages![index].sentDate.toString();

      var arr = date.split('T');

      date = arr[0];
    } catch (e) {}

    return Slidable(
      startActionPane:  ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: ScrollMotion(),

        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (doNothing) async{
              int? status = await resourceRepository.deletecontent(
                  messageList.messages![index].contentId.toString());
              if (status != null && status == 200) {
                BlocProvider.of<AppMessagesBloc>(context).add(FetchMessages(
                    countryCode: globalCountryCode, mobileNumber: globalPhoneNo));
              } else {
                Fluttertoast.showToast(msg: "Unable to Delete");
              }
            },
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),

      child: GestureDetector(
        onTap: () {
          redirectContentType(index, messageList);
        },
        child: Card(
          elevation: 2,
          margin: EdgeInsets.only(top: 16.0),
          child: Container(
            padding: EdgeInsets.only(
                left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                    flex: 75,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                ((messageResponse.messages![index].messageBody!
                                    .contentType! ==
                                    "plain")
                                    ? messageResponse.messages![index]
                                    .messageBody!.messageTitle ??
                                    ""
                                    : messageResponse.messages![index]
                                    .messageBody!.messageTitle ??
                                    ""),
                                //(messageList.messages[index].messageBody.messageTitle != null) ?messageList.messages[index].messageBody.messageTitle : "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.APP_BLUE,
                                    fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            messageList.messages![index].messageBody!
                                .contentType ==
                                "pdf"
                                ? Image.asset(
                              'images/pdficon.png',
                              width: 25,
                              height: 25,
                            )
                                : messageList.messages![index].messageBody!
                                .contentType ==
                                "video"
                                ? Icon(
                              Icons.videocam,
                              color: AppColors.APP_BLUE,
                              size: 20,
                            )
                                : messageList.messages![index].messageBody!
                                .contentType ==
                                "url"
                                ? Image.asset(
                              'images/webicon.png',
                              width: 25,
                              height: 25,
                            )
                                : messageList.messages![index]
                                .messageBody!.contentType ==
                                "txt"
                                ? Icon(
                              Icons.event_note,
                              color: AppColors.APP_BLUE,
                              size: 20,
                            )
                                : Container()
                          ],
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              tr('received') + date,
                              // '${(messageList.messages[index].messageBody.messageSent != null) ? messageList.messages[index].messageBody.messageSent : ""} From: ${(messageList.messages[index].messageBody.orgName != null) ? messageList.messages[index].messageBody.orgName.toUpperCase() : ""}',
                              style:
                              TextStyle(color: AppColors.APP_BLUE, fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          messageList.messages![index].orgChannelName!,
                          // '${(messageList.messages[index].messageBody.messageSent != null) ? messageList.messages[index].messageBody.messageSent : ""} From: ${(messageList.messages[index].messageBody.orgName != null) ? messageList.messages[index].messageBody.orgName.toUpperCase() : ""}',
                          style: TextStyle(color: AppColors.APP_BLUE, fontSize: 12),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          height: 30,
                          decoration: new BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(10.0),
                                topRight: const Radius.circular(10.0),
                                bottomLeft: const Radius.circular(10.0),
                                bottomRight: const Radius.circular(10.0),
                              )),
                          child: Row(
                            children: [
                              messageList.messages![index].messageReaction!
                                  .selectedReactionId! ==
                                  0
                                  ? GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    messageList
                                        .messages![index]
                                        .messageReaction!
                                        .selectedReactionId = 1;
                                    messageList
                                        .messages![index]
                                        .messageReaction!
                                        .numberOfReactions![0]
                                        .messageReactionCount =
                                        messageList
                                            .messages![index]
                                            .messageReaction!
                                            .numberOfReactions![0]
                                            .messageReactionCount! +
                                            1;
                                  });
                                  String response =
                                  await resourceRepository.getlike(
                                      messageList.messages![index]
                                          .orgMemberId
                                          .toString(),
                                      messageList
                                          .messages![index].messageId
                                          .toString(),
                                      "reaction",
                                      messageList
                                          .messages![index]
                                          .messageReaction!
                                          .numberOfReactions![0]
                                          .messageReactionId
                                          .toString());
                                  print(response);
                                },
                                child: Row(
                                  children: [
                                    Image(
                                      width: 25,
                                      height: 25,
                                      image: AssetImage(
                                          "images/thumboutline.png"),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      messageList
                                          .messages![index]
                                          .messageReaction!
                                          .numberOfReactions!
                                          .length ==
                                          0
                                          ? "0"
                                          : messageList
                                          .messages![index]
                                          .messageReaction!
                                          .numberOfReactions![0]
                                          .messageReactionCount
                                          .toString(),
                                      style:
                                      TextStyle(color: AppColors.APP_BLUE),
                                    )
                                  ],
                                ),
                              )
                                  : GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    messageList
                                        .messages![index]
                                        .messageReaction!
                                        .selectedReactionId = 0;
                                    messageList
                                        .messages![index]
                                        .messageReaction!
                                        .numberOfReactions![0]
                                        .messageReactionCount =
                                        messageList
                                            .messages![index]
                                            .messageReaction!
                                            .numberOfReactions![0]
                                            .messageReactionCount! -
                                            1;
                                  });
                                  String response =
                                  await resourceRepository.getlike(
                                      messageList.messages![index]
                                          .orgMemberId
                                          .toString(),
                                      messageList
                                          .messages![index].messageId
                                          .toString(),
                                      "unreaction",
                                      messageList
                                          .messages![index]
                                          .messageReaction!
                                          .numberOfReactions![0]
                                          .messageReactionId
                                          .toString());
                                  print(response);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.thumb_up,
                                      color: AppColors.APP_BLUE,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      messageList
                                          .messages![index]
                                          .messageReaction!
                                          .numberOfReactions!
                                          .length ==
                                          0
                                          ? "0"
                                          : messageList
                                          .messages![index]
                                          .messageReaction!
                                          .numberOfReactions![0]
                                          .messageReactionCount
                                          .toString(),
                                      style:
                                      TextStyle(color: AppColors.APP_BLUE),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if(messageList.messages![index].messageBody!.contentType ==
                                      "plain"){
                                    String share = ''' 
${messageList.messages![index].messageTitle}

''';

                                    Share.share(share);
                                  }else{
                                    String share = ''' 
${messageList.messages![index].messageTitle}

${messageList.messages![index].messageBody!.contentUri!.toString()}
''';

                                    Share.share(share);
                                  }

                                  String response =
                                  await resourceRepository.shareApi(
                                      messageList
                                          .messages![index].orgMemberId
                                          .toString(),
                                      messageList.messages![index].messageId
                                          .toString(),
                                      "share",
                                      "1");
                                  print(response);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.share,
                                      color: AppColors.APP_BLUE,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      'Share',
                                      style: TextStyle(
                                          color: AppColors.APP_BLUE, fontSize: 15),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                    flex: 25,
                    child: (messageList.messages![index].orgChannelLogo !=
                        null &&
                        messageList.messages![index].orgChannelLogo != "")
                        ? Image.network(
                      messageList.messages![index].orgChannelLogo!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.fill,
                    )
                        : Image.asset(
                      "images/ishare_logo.png",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
//
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }

  void redirectContentType(int index, MessagesModel messageList) async {
    if (messageList.messages![index].messageBody!.contentType! == "video") {
      if (!kIsWeb) {
        print(messageList.messages![index].messageBody!.contentUri!.toString());
        print(
            messageList.messages![index].messageBody!.contentTitle!.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VideoAppChewie( videoUrl: messageList.messages![index].messageBody!.contentUri!.toString(),
                  title: messageList.messages![index].messageBody!.contentTitle!.toString(),)));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => BGVideoPlayerView(
        //               local: "",
        //               videoUrl:
        //                   messageList.messages![index].messageBody!.contentUri!,
        //               title: messageList
        //                   .messages![index].messageBody!.contentTitle!,
        //             )));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VideoApp( videoUrl: messageList.messages![index].messageBody!.contentUri!.toString(),
                  title: messageList.messages![index].messageBody!.contentTitle!.toString(),)));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => BGVideoPlayerView(
        //               local: "",
        //               videoUrl:
        //                   messageList.messages![index].messageBody!.contentUri!,
        //               title: messageList
        //                   .messages![index].messageBody!.contentTitle!,
        //             )));
      }
    } else if (messageList.messages![index].messageBody!.contentType == "pdf") {
      if (kIsWeb) {
        var url = messageList.messages![index].messageBody!.contentUri!;
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PdfViewerNew(
                  pdfUrl:
                  messageList.messages![index].messageBody!.contentUri!,
                  title: messageList
                      .messages![index].messageBody!.contentTitle!,
                )));
      }
    } else if (messageList.messages![index].messageBody!.contentType == "url") {
      String url = messageList.messages![index].messageBody!.contentUri!;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else if (messageList.messages![index].messageBody!.contentType ==
        "image") {
      String url =
      messageList.messages![index].messageBody!.contentUri!.toString();

      globalISPNPageOpened = true;

      // Navigator.push(context, MaterialPageRoute(builder: (context)=>WebViewExample(),settings: RouteSettings(name:'Webpage')));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FullPhoto(
                url: url,
                title: messageList
                    .messages![index].messageBody!.contentTitle
                    .toString(),
              )));
    } else {
      print("datasss");
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => DialogOverlay(
          title: messageList.messages![index].messageBody!.messageTitle!
              .toString(),
          message: messageList.messages![index].messageBody!.message.toString(),
          image: messageList.messages![index].orgLogo.toString(),
          date: messageList.messages![index].messageBody!.messageSent.toString(),
          orgName: messageList.messages![index].orgName.toString(),
        ),
      );
    }
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

class DialogOverlay extends StatefulWidget {
  String? message;
  String? image;
  String? date;
  String? title;
  String? orgName;

  DialogOverlay(
      {Key? key, this.title, this.message, this.image, this.date, this.orgName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => DialogOverlayState();
}

class DialogOverlayState extends State<DialogOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    print("data");
    print(widget.image);
    print(widget.orgName);
    print(widget.date);
    print(widget.title);

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            margin: const EdgeInsets.fromLTRB(30.0, 10, 30, 10),
            padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 10),
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: CircleAvatar(
                                    backgroundImage: ((widget.image != "null" &&
                                        widget.image != "")
                                        ? NetworkImage(widget.image!)
                                        : AssetImage("images/photo_avatar.png")
                                    as ImageProvider),
                                    radius: 25,
                                    backgroundColor: AppColors.APP_BLUE,
                                    foregroundColor: AppColors.APP_WHITE,
                                  )),
                              Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 100),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0.0, 15.0, 0.0, 0.0),
                                          child: Text(
                                            (widget.orgName != null &&
                                                widget.orgName != "")
                                                ? widget.orgName!
                                                : "",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 35.0,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          "",
                                          style: TextStyle(
                                              color:
                                              AppColors.APP_LIGHT_BLUE_20,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                        Wrap(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(
                                (widget.message! != null)
                                    ? widget.message!
                                    : "",
                                style: TextStyle(
                                    color: AppColors.APP_BLACK,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                          width: 20,
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                (widget.date != "null" && widget.date != "")
                                    ? widget.date!
                                    : "",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ]),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              child: GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                    color: Colors.grey,
                                  ),
                                  height: 40,
                                  width: 100,
                                  child: Center(
                                    child: Text(
                                      "Close",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 1,
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
