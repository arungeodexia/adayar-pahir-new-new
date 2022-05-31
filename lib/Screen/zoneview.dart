import 'dart:convert';
import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ACI/Bloc/Resorceview/resource_details_view.dart';
import 'package:ACI/Bloc/message/app_messages_view.dart';
import 'package:ACI/Bloc/message/message_model_class.dart';
import 'package:ACI/Model/MembersModel.dart';
import 'package:ACI/Screen/search_page.dart';
import 'package:ACI/Screen/uploadchannel.dart';
import 'package:ACI/data/api/repository/common_repository.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/unreadchat/fullphoto.dart';
import 'package:ACI/utils/PdfViewer.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import 'BGVideoPlayerView.dart';

class zoneview extends StatefulWidget {
  final String text;
  final String orgid;

  zoneview({Key? key, required this.text, required this.orgid})
      : super(key: key);

  @override
  _zoneviewState createState() => _zoneviewState();
}

class _zoneviewState extends State<zoneview> {
  ResourceRepository resourceRepository = new ResourceRepository();
  TextEditingController searchEditingController = new TextEditingController();
  String username = "";
  String userImage = "";

  bool isViewVisible = true;
  bool isMyResVisible = false;

  List<String> suggestions = [];

  String currentText = "";

   MessagesModel messageResponse=MessagesModel();

  MembersModel organizationModel=MembersModel();

  bool isload=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserName();

  }

  getuserName() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String res = prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString();
    var encoded = utf8.encode(res);
    final resourceDetailsResponse = json.decode(utf8.decode(encoded));
    //debugPrint("resourceDetailsResponse:==>" + resourceDetailsResponse.toString());
    isload=true;
    setState(() {
      username = resourceDetailsResponse['firstName'];
      globalCurrentUserMobileNo = resourceDetailsResponse['mobile'];
      globalCurrentUserId = resourceDetailsResponse['id'];
      userImage = resourceDetailsResponse['profilePicture'];

    });
    print(userImage);

    messageResponse = await resourceRepository.fetchMessages(
        countryCode: globalCountryCode, mobileNumber: globalPhoneNo);
    organizationModel =
        await resourceRepository.getSubOrganisationData(widget.orgid);
    isload=false;
    setState(() {});
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.text),
      ),
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Uploadchannel(orgid: widget.orgid)));
        },
        icon: Icon(Icons.upload_file, color: Colors.white, size: 30.0),
        label: Text("Upload"),
        backgroundColor: AppColors.APP_BLUE,
        elevation: 0.0,
      ),
      body: isload?Center(child: CircularProgressIndicator()):Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    top: 20,
                    right: 20,
                    bottom: 0,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new CircleAvatar(
                            radius: 25.0,
                            backgroundColor: const Color(0xFF778899),
                      backgroundImage: userImage.toString()!="null"&&userImage != ""
                          ? NetworkImage(userImage.toString())
                          : AssetImage("images/photo_avatar.png") as ImageProvider),
                        SizedBox(width: 10),
                        new Expanded(
                            child: Text(username == null ? "" : username.trim(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)))
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    top: 10,
                    right: 20,
                    bottom: 10,
                  ),
                  child: SimpleAutoCompleteTextField(
                    decoration: new InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                          globalSearchData =
                              searchEditingController.text.toString().trim();
                          FocusScope.of(context).requestFocus(new FocusNode());

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage()));
                        },
                      ),
                      hintText: "Search ",
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 32.0),
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    controller: TextEditingController(text: ""),
                    suggestions: suggestions,
                    textChanged: (text) => currentText = text,
                    clearOnSubmit: false,
                    textSubmitted: (text) async {
                      globalSearchData = text.trim();
                      FocusScope.of(context).requestFocus(new FocusNode());

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchPage()));
                    },
                  ),
                ),
                if (organizationModel.orgMembers != null)
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: organizationModel.orgMembersCount,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Container(
                          // color: Colors.grey,
                          child: Card(
                              color: Colors.white,
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              borderOnForeground: true,
                              elevation: 10,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: ListTile(
                                onTap: () {
                                  globalResourceId = organizationModel
                                      .orgMembers![index].orgChannelMemberId
                                      .toString();
                                  globalResourceType = "";
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) => ResourceDetailsView(isRedirectFrom: "true",resoruceid: organizationModel
                                        .orgMembers![index].orgChannelMemberId
                                        .toString(),resorucetype: "internal-channel",)),(Route<dynamic> route) => false,);

                                },
                                contentPadding: EdgeInsets.only(
                                    left: 25.0,
                                    right: 20.0,
                                    top: 2.0,
                                    bottom: 5.0),
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: organizationModel
                                                  .orgMembers![index]
                                                  .profilePictureLink
                                                  .toString() ==
                                              "null" ||
                                          organizationModel.orgMembers![index]
                                                  .profilePictureLink
                                                  .toString() ==
                                              'null'
                                      ? AssetImage("images/photo_avatar.png") as ImageProvider
                                      : NetworkImage(organizationModel
                                          .orgMembers![index].profilePictureLink
                                          .toString()),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black45,
                                  size: 20,
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      organizationModel
                                          .orgMembers![index].firstName
                                          .toString(),
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal),
                                      maxLines: 1, // style:
                                      //     TextStyle(backgroundColor: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      organizationModel
                                          .orgMembers![index].skillName
                                          .toString(),
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.APP_BLUE,
                                          fontSize: 12),
                                      maxLines: 1,
                                      // style:
                                      //     TextStyle(backgroundColor: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      organizationModel.orgMembers![index].city
                                          .toString(),
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal),
                                      maxLines: 1, // style:
                                      //     TextStyle(backgroundColor: Colors.white),
                                    ),
                                  ],
                                ),
                              )),
                        );
                      })
                else
                  Container(),
                Card(
                  color: AppColors.APP_BLUE,
                  child: ListTile(
                    title: Text(
                      'Messages',
                      style: TextStyle(color: Colors.white),
                    ),
                    // leading: CircleAvatar(
                    //   backgroundColor: Colors.greenAccent,
                    //   backgroundImage:
                    //       AssetImage("images/photo_avatar.png"),
                    // ),
                  ),
                ),


                  ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(0.0),
                      itemCount: messageResponse.messages!.length,
                      itemBuilder: (_, index) {
                        if (messageResponse != null ||
                            messageResponse.messages!.length > 0) {
                          return _buildMessageCard(index, messageResponse);
                        } else {
                          return Text(
                            'There are no pending messages to read.',
                            textAlign: TextAlign.center,
                          );
                        }
                      })

                // FutureBuilder<MessagesModel>(
                //   future: resourceRepository.fetchMessages(
                //       countryCode: globalCountryCode,
                //       mobileNumber: globalPhoneNo),
                //   // async work
                //   builder: (BuildContext context,
                //       AsyncSnapshot<MessagesModel> snapshot) {
                //     switch (snapshot.connectionState) {
                //       case ConnectionState.waiting:
                //         return Container();
                //       default:
                //         if (snapshot.hasError)
                //           return Text('Something went wrong');
                //         else
                //           messageResponse = snapshot.data;
                //         print(snapshot.data);
                //         try {
                //           if (messageResponse != null ||
                //               messageResponse.messages.length > 0) {
                //             return ListView.builder(
                //                 shrinkWrap: true,
                //                 physics: BouncingScrollPhysics(),
                //                 padding: EdgeInsets.all(0.0),
                //                 itemCount: messageResponse.messages.length,
                //                 itemBuilder: (_, index) {
                //                   if (messageResponse != null ||
                //                       messageResponse.messages.length > 0) {
                //                     return _buildMessageCard(
                //                         index, messageResponse);
                //                   } else {
                //                     return Text(
                //                       'There are no pending messages to read.',
                //                       textAlign: TextAlign.center,
                //                     );
                //                   }
                //                 });
                //           } else {
                //             return Text(
                //               'There are no pending messages to read.',
                //               textAlign: TextAlign.center,
                //             );
                //           }
                //         } catch (e) {
                //           return Container();
                //         }
                //     }
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void redirectContentType(int index, MessagesModel messageList) async {
    if (messageList.messages![index].messageBody!.contentType == "video") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BGVideoPlayerView(
                    videoUrl:
                        messageList.messages![index].messageBody!.contentUri!,
                    title: messageList.messages![index].messageBody!.contentTitle!, local: '',
                  )));
    } else if (messageList.messages![index].messageBody!.contentType == "pdf") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PdfViewerNew(
                    pdfUrl: messageList.messages![index].messageBody!.contentUri!,
                    title: messageList.messages![index].messageBody!.contentTitle!,
                  )));
    } else if (messageList.messages![index].messageBody!.contentType == "url") {
      String url = messageList.messages![index].messageBody!.contentUri!;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else if (messageList.messages![index].messageBody!.contentType == "image") {
      String url = messageList.messages![index].messageBody!.contentUri!;

      globalISPNPageOpened = true;

      // Navigator.push(context, MaterialPageRoute(builder: (context)=>WebViewExample(),settings: RouteSettings(name:'Webpage')));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FullPhoto(
                    url: url,
                    title: messageList.messages![index].messageBody!.contentTitle!,
                  )));
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => DialogOverlay(
          title: messageList.messages![index].messageBody!.messageTitle!,
          message: messageList.messages![index].messageBody!.message!,
          image: messageList.messages![index].messageBody!.orgLogo!,
          date: messageList.messages![index].messageBody!.messageSent!,
          orgName: messageList.messages![index].messageBody!.orgName!,
        ),
      );
    }
  }

  Widget _buildMessageCard(int index, MessagesModel messageList) {
    String date = '';
    try {
      date = messageList.messages![index].sentDate.toString();

      var arr = date.split('T');

      date = arr[0];
    } catch (e) {}
    // return Text('1');

    return GestureDetector(
      onTap: () {
        redirectContentType(index, messageList);
      },
      child: Card(
        elevation: 2,
        margin: EdgeInsets.only(top: 5.0),
        child: Container(
          padding:
              EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0, bottom: 8.0),
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
                          Text(
                            ((messageResponse.messages![index].messageBody!
                                        .contentType! ==
                                    "plain")
                                ? messageResponse.messages![index].messageBody!
                                        .messageTitle ??
                                    ""
                                : messageResponse.messages![index].messageBody!
                                        .contentTitle ??
                                    ""),
                            //(messageList.messages[index].messageBody.messageTitle != null) ?messageList.messages[index].messageBody.messageTitle : "",
                            maxLines: 2,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.APP_LISTVIEW_BACK_dark,
                                fontSize: 15),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          messageList.messages![index].messageBody!.contentType! ==
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
                                      color: AppColors.APP_LISTVIEW_BACK_dark,
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
                                      : messageList.messages![index].messageBody!
                                                  .contentType ==
                                              "txt"
                                          ? Icon(
                                              Icons.event_note,
                                              color:
                                                  AppColors.APP_LIGHT_BLUE_40,
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
                            "Received : " + date,
                            // '${(messageList.messages![index].messageBody.messageSent != null) ? messageList.messages![index].messageBody.messageSent : ""} From: ${(messageList.messages![index].messageBody.orgName != null) ? messageList.messages![index].messageBody.orgName.toUpperCase() : ""}',
                            style: TextStyle(
                                color: AppColors.APP_LISTVIEW_BACK_dark,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        messageList.messages![index].orgChannelName!,
                        // '${(messageList.messages![index].messageBody.messageSent != null) ? messageList.messages![index].messageBody.messageSent : ""} From: ${(messageList.messages![index].messageBody.orgName != null) ? messageList.messages![index].messageBody.orgName.toUpperCase() : ""}',
                        style: TextStyle(
                            color: AppColors.APP_LISTVIEW_BACK_dark, fontSize: 12),
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
                                        .selectedReactionId ==
                                    0
                                ? GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        messageList
                                            .messages![index]
                                            .messageReaction!
                                            .selectedReactionId = 1;
                                        if(messageList
                                            .messages![index]
                                            .messageReaction!
                                            .numberOfReactions!.length==0){
                                          NumberOfReaction reac=NumberOfReaction();
                                          reac.messageReactionCount=1;
                                          reac.messageReactionId=1;
                                          reac.messageReactionName="1";
                                          messageList
                                              .messages![index]
                                              .messageReaction!
                                              .numberOfReactions!.add(reac);

                                        }else{
                                          messageList
                                              .messages![index]
                                              .messageReaction!
                                              .numberOfReactions![0]
                                              .messageReactionCount = messageList
                                              .messages![index]
                                              .messageReaction!
                                              .numberOfReactions![0]
                                              .messageReactionCount! +
                                              1;
                                        }

                                      });
                                      String response =
                                          await resourceRepository.getlike(
                                              messageList
                                                  .messages![index].orgMemberId
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
                                              .numberOfReactions!.length==0?"0":messageList
                                              .messages![index]
                                              .messageReaction!
                                              .numberOfReactions![0]
                                              .messageReactionCount
                                              .toString(),
                                          style: TextStyle(color: Colors.green),
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
                                            .messageReactionCount = messageList
                                                .messages![index]
                                                .messageReaction!
                                                .numberOfReactions![0]
                                                .messageReactionCount! -
                                            1;
                                      });
                                      String response =
                                          await resourceRepository.getlike(
                                              messageList
                                                  .messages![index].orgMemberId
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
                                          color: Colors.green,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          messageList
                                              .messages![index]
                                              .messageReaction!
                                              .numberOfReactions!.length==0?"0":messageList
                                              .messages![index]
                                              .messageReaction!
                                              .numberOfReactions![0]
                                              .messageReactionCount
                                              .toString(),
                                          style: TextStyle(color: Colors.green),
                                        )
                                      ],
                                    ),
                                  ),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
    String title=messageList.messages![index].messageBody!.messageTitle.toString()=="null"?messageList.messages![index].messageBody!.contentTitle.toString():messageList.messages![index].messageBody!.messageTitle.toString();

                                String share = ''' 
${title}

${messageList.messages![index].messageBody!.contentUri.toString()}
''';

                                Share.share(share);
                                String response =
                                    await resourceRepository.shareApi(
                                        messageList.messages![index].orgMemberId
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
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    'பகிர்',
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 15),
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
                  child: (messageList.messages![index].orgChannelLogo != null &&
                          messageList.messages![index].orgChannelLogo != "")
                      ? Image.network(
                          messageList.messages![index].orgChannelLogo.toString(),
                          width: 80,
                          height: 80,
                          fit: BoxFit.fill,
                        )
                      : Image.asset(
                          "images/square_bg.png",
                          width: 80,
                          height: 80,
                          fit: BoxFit.fill,
                        )
//
                  )
            ],
          ),
        ),
      ),
    );
  }
}
