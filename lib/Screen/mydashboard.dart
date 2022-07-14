import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ACI/Screen/Careteam.dart';
import 'package:ACI/Screen/Homepage/dash3.dart';
import 'package:ACI/Screen/otp_verify_form.dart';
import 'package:ACI/Screen/surveymenu.dart';
import 'package:ACI/data/api/repository/LoginRepo.dart';
import 'package:ACI/utils/VideoAppChewie.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ACI/Bloc/message/app_messages_view.dart';
import 'package:ACI/Model/create_edit_profile_model.dart';
import 'package:ACI/Screen/BGVideoPlayerView.dart';
import 'package:ACI/Screen/my_home_page_DMK.dart';
import 'package:ACI/Screen/myhomepage.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/main.dart';
import 'package:ACI/unreadchat/Controllers/firebaseController.dart';
import 'package:ACI/unreadchat/Controllers/utils.dart';
import 'package:ACI/unreadchat/chatlist.dart';
import 'package:ACI/unreadchat/chatroom.dart';
import 'package:ACI/unreadchat/chatroom_Group.dart';
import 'package:ACI/unreadchat/fullphoto.dart';
import 'package:ACI/utils/Drawer.dart';
import 'package:ACI/utils/PdfViewer.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ScreenCheck.dart';
import 'add_resorce.dart';
import 'dash1.dart';
import 'favourites_page.dart';

class Mydashboard extends StatefulWidget {
  Mydashboard({Key? key}) : super(key: key);

  @override
  _MydashboardState createState() => _MydashboardState();
}

class AppPropertiesBloc {
  StreamController<String> _title = StreamController<String>();
  StreamController<String> _chats = StreamController<String>();

  Stream<String> get titleStream => _title.stream;

  Stream<String> get chatStream => _chats.stream;

  updateTitle(String newTitle) {
    _title.sink.add(newTitle);
  }

  updateChat(String newTitle) {
    _chats.sink.add(newTitle);
  }

  dispose() {
    _title.close();
    _chats.close();
  }
}

class _MydashboardState extends State<Mydashboard> {

  final appBloc = AppPropertiesBloc();

  var list;
  String _message = '';

  DateTime? currentBackPressTime;
  late CreateEditProfileModel createEditProfileModel;
  String username = "";

  String userImage = "";

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
      if (unreads == "1") {
        unreads = "";
      }
    });
    if (currentIndex == 0)
      appBloc.updateTitle(tr("home"));
    else if (currentIndex == 1)
      appBloc.updateTitle(tr("careteam"));
    else if (currentIndex == 2)
      appBloc.updateTitle(tr("messages"));
    else if (currentIndex == 3)
      appBloc.updateTitle(tr("reports"));
    else if (currentIndex == 4)
      appBloc.updateTitle('Favourites');

  }
  String getTitle(int currentIndex) {
   
    if (currentIndex == 0){
      return tr("home");
    } else if (currentIndex == 1){
      return tr("careteam");
    } else if (currentIndex == 2){
      return tr("messages");
    } else if (currentIndex == 3){
      return tr("chat");
    } else {
      return tr("home");
    }
    
  }

  Future<bool> onWillPop() async {
    //print("_currentIndex :==>"+_currentIndex.toString());
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.closeDrawer();
    } else {
      if (currentIndex != 0) {
        setState(() {
          currentIndex = 0;
        });
      } else {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(msg: "Press Again to exit");
          return Future.value(false);
        }
        return Future.value(true);
        // SystemNavigator.pop();
      }

    }
    return false;
  }

  _takeUserInformationFromFBDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var resourceDetailsResponse = await json
        .decode(prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString());
    createEditProfileModel =
        CreateEditProfileModel.fromJson(resourceDetailsResponse);
    setState(() {
      username = resourceDetailsResponse['firstName'];
      globalCurrentUserMobileNo = resourceDetailsResponse['mobile'];
      globalCurrentUserId = resourceDetailsResponse['id'];
      userImage = resourceDetailsResponse['profilePicture'];
      print(userImage);
    });

    FirebaseController.instanace
        .saveUserDataToFirebaseDatabase(
            randomIdWithName(globalPhoneNo),
            createEditProfileModel.firstName,
            createEditProfileModel.countryCode,
            createEditProfileModel.profilePicture)
        .then((data) {});
    FirebaseController.instanace
        .takeUserInformationFromFBDB()
        .then((documents) {
      if (documents.length > 0) {}
    });
  }

  Future<void> _moveTochatRoom(selectedUserToken, selectedUserID,
      selectedUserName, selectedUserThumbnail, countrycode) async {
    try {
      String username = "", userImage = "";

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final resourceDetailsResponse = await json
          .decode(prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString());

      setState(() {
        username = resourceDetailsResponse['firstName'];
        print(resourceDetailsResponse['profilePicture']);
        userImage = resourceDetailsResponse['profilePicture'];
      });
      selectedUserName=selectedUserName.toString().replaceAll("+", " ");

      FirebaseController.instanace
          .saveUserDataToFirebaseDatabase(randomIdWithName(selectedUserID),
              selectedUserName, countrycode, selectedUserThumbnail)
          .then((data) {});

      String chatID = makeChatId(globalPhoneNo, selectedUserID);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatRoom(
                  globalPhoneNo,
                  username.toString(),
                  selectedUserToken,
                  selectedUserID,
                  chatID,
                  selectedUserName,
                  selectedUserThumbnail,
                  countrycode)));
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _takeUserInformationFromFBDB();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) async{
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String versionLocal = prefs.getString(APP_VERSION)??'';

      if(version==versionLocal){
        LoginRepo loginRepo=LoginRepo();
        loginRepo.sendDeviceInfoVersion(version);
      }
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      print("msg init" + message.toString());

      if (message != null) {
        if (message.data['title'].toString().contains('You got a message')) {
          final dynamic msgBodyData = Uri.decodeFull(message.data['body']);
          Map<String, dynamic> msgObject = json.decode(msgBodyData);
          print("msgBodyData froom :==>" + msgBodyData + listKey);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String name = prefs.getString('name2') ?? '';

          if (name != msgObject['timezone'].toString()) {
            Map<String, dynamic> row = {};

            if (msgObject['peercode'].toString() == "grp") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatroomGroup(
                            globalPhoneNo,
                            createEditProfileModel.firstName.toString(),
                            'selectedUserToken',
                            msgObject['id'].toString(),
                            msgObject['id'].toString(),
                            msgObject['peername']
                                .toString()
                                .replaceAll("+", " "),
                            msgObject['peerurl'].toString(),
                            msgObject['peercode'].toString(),
                          )));
            } else {
              _moveTochatRoom(
                '',
                msgObject['peerid'].toString(),
                msgObject['peername'].toString(),
                msgObject['peerurl'].toString(),
                msgObject['peercode'].toString(),
              );
            }
          } else {}
        } else if (message.data['title'].toString().contains('Adyar Cancer Institute')) {
          final dynamic msgBodyData = Uri.decodeFull(message.data['body']);
          Map<String, dynamic> msgObject = json.decode(msgBodyData);
          print("msgBodyData froom :==>" + msgBodyData + listKey);
          print(msgObject['taskId'].toString());
          CoolAlert.show(
              context: context,
              type: CoolAlertType.confirm,
              barrierDismissible: false,
              title: msgObject['title'].toString().replaceAll("+", " "),
              text: message.data['title'],
              confirmBtnText: "Proceed",
              cancelBtnText: " Do it Later!!",
              loopAnimation: false,
              onCancelBtnTap: ()async{
                Navigator.of(context).pop();
              },
              onConfirmBtnTap: () async {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>new ScreenCheck(
                  title: msgObject['title'].toString().replaceAll("+", " "),
                  id: msgObject['taskId'].toString(),
                  page: "0",
                )),)
                    .then((val)=>getVersionNumber());
                globalTaskID=int.parse(msgObject['taskId'].toString());

              });
    } else {
          if (Platform.isIOS) {
            // _navigateToItemDetailIOS(context, message, false);
            // messageHdlrForIOS(message);
            messageHdlrForAndroid(message.data, false);

          } else {
            messageHdlrForAndroid(message.data, false);
            // if (!globalAndroidIsOnMsgExecuted) {
            //   //showAndroidNotificationAlert(context, message).show();
            //
            //   globalAndroidIsOnMsgExecuted = true;
            // }
          }
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("msg listen" + message.data.toString());

      if (message != null) {
        if (message.data['title'].toString().contains('You got a message')) {
          final dynamic msgBodyData = Uri.decodeFull(message.data['body']);
          Map<String, dynamic> msgObject = json.decode(msgBodyData);
          print("msgBodyData froom :==>" + msgBodyData + listKey);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String name = prefs.getString('name2') ?? '';

          if (name != msgObject['timezone'].toString()) {
            setState(() {
              unreads = '1';
            });
            Map<String, dynamic> row = {};
          } else {}
        }  else if (message.data['title'].toString().contains('Adyar Cancer Institute')) {
          final dynamic msgBodyData = Uri.decodeFull(message.data['body']);
          Map<String, dynamic> msgObject = json.decode(msgBodyData);
          print("msgBodyData froom :==>" + msgBodyData + listKey);
          print(msgObject['taskId'].toString());
          CoolAlert.show(
              context: context,
              type: CoolAlertType.confirm,
              barrierDismissible: false,
              text: msgObject['title'].toString().replaceAll("+", " "),
              title: message.data['title'].toString(),
              confirmBtnText: "Proceed",
              cancelBtnText: " Do it Later!!",
              loopAnimation: false,
              onCancelBtnTap: ()async{
                Navigator.of(context).pop();
              },
              onConfirmBtnTap: () async {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>new ScreenCheck(
                  title: msgObject['title'].toString().replaceAll("+", " "),
                  id: msgObject['taskId'].toString(),
                  page: "0",
                )),)
                    .then((val)=>getVersionNumber());
                globalTaskID=int.parse(msgObject['taskId'].toString());

              });
        } else {
          if (Platform.isIOS) {
            // _navigateToItemDetailIOS(context, message, false);
            // messageHdlrForIOS(message);
            messageHdlrForAndroid(message.data, false);

          } else {
            messageHdlrForAndroid(message.data, false);
            // if (!globalAndroidIsOnMsgExecuted) {
            //   //showAndroidNotificationAlert(context, message).show();
            //
            //   globalAndroidIsOnMsgExecuted = true;
            // }
          }
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("msg open" + message.data.toString());

      if (message != null) {
        if (message.data['title'].toString().contains('You got a message')) {
          final dynamic msgBodyData = Uri.decodeFull(message.data['body']);
          Map<String, dynamic> msgObject = json.decode(msgBodyData);
          print("msgBodyData froom :==>" + msgBodyData + listKey);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String name = prefs.getString('name2') ?? '';

          if (name != msgObject['timezone'].toString()) {
            Map<String, dynamic> row = {};

            if (msgObject['peercode'].toString() == "grp") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatroomGroup(
                            globalPhoneNo,
                            createEditProfileModel.firstName.toString(),
                            'selectedUserToken',
                            msgObject['id'].toString(),
                            msgObject['id'].toString(),
                            msgObject['peername']
                                .toString()
                                .replaceAll("+", " "),
                            msgObject['peerurl'].toString(),
                            msgObject['peercode'].toString(),
                          )));
            } else {
              _moveTochatRoom(
                '',
                msgObject['peerid'].toString(),
                msgObject['peername'].toString(),
                msgObject['peerurl'].toString(),
                msgObject['peercode'].toString(),
              );
            }
          } else {}
        }  else if (message.data['title'].toString().contains('Adyar Cancer Institute')) {
          final dynamic msgBodyData = Uri.decodeFull(message.data['body']);
          Map<String, dynamic> msgObject = json.decode(msgBodyData);
          print("msgBodyData froom :==>" + msgBodyData + listKey);
          print(msgObject['taskId'].toString());
          String notifyId=message.messageId!;
          if(notifyread!=notifyId){
            notifyread=notifyId;
            CoolAlert.show(
                context: context,
                type: CoolAlertType.confirm,
                barrierDismissible: false,
                text: msgObject['title'].toString().replaceAll("+", " "),
                title: message.data['title'].toString(),
                confirmBtnText: "Proceed",
                cancelBtnText: " Do it Later!!",
                loopAnimation: false,
                onCancelBtnTap: ()async{
                  Navigator.of(context).pop();
                },
                onConfirmBtnTap: () async {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>new ScreenCheck(
                    title: msgObject['title'].toString().replaceAll("+", " "),
                    id: msgObject['taskId'].toString(),
                    page: "0",
                  )),)
                      .then((val)=>getVersionNumber());
                  globalTaskID=int.parse(msgObject['taskId'].toString());

                });
          }

        } else {
          if (Platform.isIOS) {
            // _navigateToItemDetailIOS(context, message, false);
            // messageHdlrForIOS(message);
            messageHdlrForAndroid(message.data, false);

          } else {
            messageHdlrForAndroid(message.data, false);
            // if (!globalAndroidIsOnMsgExecuted) {
            //   //showAndroidNotificationAlert(context, message).show();
            //
            //   globalAndroidIsOnMsgExecuted = true;
            // }
          }
        }
      }

      print('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(context, '/message',
      //     arguments: MessageArguments(message, true));
    });
  }

  @override
  Widget build(BuildContext context) {
    globalcontext = context;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppColors.APP_BLUE1,
          // title: StreamBuilder<Object>(
          //     stream: appBloc.titleStream,
          //     initialData: tr("home"),
          //     builder: (context, snapshot) {
          //       return Text(snapshot.data.toString());
          //     }),
          title: Text(getTitle(currentIndex)),
          centerTitle: true,
          elevation: 5,
          actions: <Widget>[
            // GestureDetector(
            //   child: Padding(
            //       padding: EdgeInsets.only(right: 18),
            //       child: CircleAvatar(
            //         child: Icon(Icons.notifications),
            //         radius: 12,
            //         backgroundColor: AppColors.APP_LIGHT_BLUE_30,
            //         foregroundColor: AppColors.APP_BLUE,
            //       )),
            //   onTap: () {
            //     Navigator.of(context).push(
            //         MaterialPageRoute(builder: (context) => AppMessagesView()));
            //   },
            // ),
        //    GestureDetector(
        //       child: Container(
        //         margin: EdgeInsets.all(8),
        //         child: CircleAvatar(
        //             radius: 25.0,
        //             backgroundColor: AppColors.APP_LIGHT_BLUE,
        //             backgroundImage:  userImage.toString()!="null"&&userImage != ""
        //                 ? NetworkImage(userImage.toString())
        //                 : AssetImage("images/photo_avatar.png") as ImageProvider),
        //       ),
        //
        // onTap: () {
        //         // Navigator.of(context).pushAndRemoveUntil(
        //         //   MaterialPageRoute(builder: (context) => AddResorce()),
        //         //   (Route<dynamic> route) => false,
        //         // );
        //       },
        //     )
          ],
        ),
        drawer: IShareAppDrawer(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedLabelStyle: TextStyle(color: AppColors.APP_BLUE),
          fixedColor: AppColors.APP_BLUE,
          onTap: onTabTapped,
          currentIndex: currentIndex,
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.home_outlined,
                color: AppColors.APP_LIGHT_GREY,
              ),
              activeIcon: new Icon(
                Icons.home,
                color: AppColors.APP_BLUE,
              ),
              label:  tr("home"),
              // title: new Text(
              //   tr("home"),
              //   style: TextStyle(color: AppColors.APP_BLUE),
              // ),
            ),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.group,
                color: AppColors.APP_LIGHT_GREY,
              ),
              activeIcon: new Icon(
                Icons.group,
                color: AppColors.APP_BLUE,
              ),
              label: tr("careteam"),
              // title: new Text(
              //   tr("careteam"),
              //   style: TextStyle(color: AppColors.APP_BLUE),
              // ),
            ),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.mail,
                color: AppColors.APP_LIGHT_GREY,
              ),
              activeIcon: new Icon(
                Icons.mail,
                color: AppColors.APP_BLUE,
              ),
              label: tr("messages"),
              // title: new Text(
              //   tr("careteam"),
              //   style: TextStyle(color: AppColors.APP_BLUE),
              // ),
            ),
            BottomNavigationBarItem(
              icon: unreads == '1'
                  ? new Stack(children: <Widget>[
                      new Icon(Icons.chat),
                      new Positioned(
                        // draw a red marble
                        top: 0.0,
                        right: 0.0,
                        child: new Icon(Icons.brightness_1,
                            size: 12.0, color: Colors.redAccent),
                      )
                    ])
                  : new Icon(
                      Icons.message,
                      color: AppColors.APP_LIGHT_GREY,
                    ),
              activeIcon: unreads == '1'
                  ? new Stack(children: <Widget>[
                      new Icon(Icons.message),
                      new Positioned(
                        // draw a red marble
                        top: 0.0,
                        right: 0.0,
                        child: new Icon(Icons.brightness_1,
                            size: 12.0, color: Colors.redAccent),
                      )
                    ])
                  : new Icon(
                      Icons.message,
                      color: AppColors.APP_BLUE,
                    ),
                label:tr('chat')
              // title: new Text(tr('messages'), style: TextStyle(color: AppColors.APP_BLUE)),
            ),
            // BottomNavigationBarItem(
            //   icon: new Icon(
            //     Icons.list_alt_rounded,
            //     color: AppColors.APP_LIGHT_GREY,
            //   ),
            //   activeIcon: new Icon(
            //     Icons.list_alt_rounded,
            //     color: AppColors.APP_BLUE,
            //   ),
            //   label: tr("reports")
            //   // title: new Text(tr("reports"),
            //   //     style: TextStyle(color: AppColors.APP_BLUE)),
            // ),
            // BottomNavigationBarItem(
            //   icon: new Icon(
            //     Icons.chat_bubble_outline,
            //     color: unreads==""?Colors.red:AppColors.APP_LIGHT_GREY,
            //   ),
            //   activeIcon: new Icon(
            //     Icons.chat_bubble,
            //     color: AppColors.APP_BLUE,
            //   ),
            //   title: new Text('Messages', style: TextStyle(color: AppColors.APP_BLUE)),
            //   label:  "test",
            // )
          ],
        ),
        body: SafeArea(child: _children[currentIndex]),
      ),
    );
  }

  final List<Widget> _children = [
    DashboardThreePage(),
    Careteam(),
    AppMessagesView(),
    ChatList(globalPhoneNo,"name"),
    // FavouritesPage(),
  ];

  void messageHdlrForAndroid(Map<String, dynamic> message, bool bool) async {
    final dynamic msgBodyData = Uri.decodeFull(message['body'].toString());
    print("msgBodyDataaaa :==>" + msgBodyData);
    Map<String, dynamic> msgObject = json.decode(msgBodyData);
    print("msgObject :==>" + msgObject.toString());

    if (msgObject.containsKey('contentType')) {
      String contentType = msgObject['contentType'];
      //print("contentType :==>"+contentType);

      String messageTitle = msgObject['contentTitle'];
      String msgData = msgObject['message'];
      String orgName = msgObject['orgName'];
      String orgChannelName = msgObject['channelName'];
      String orgLogo = msgObject['orgLogo'];
      String messageSent = msgObject['messageSent'];
      try {
        orgName = orgName.replaceAll('+', " ");
        messageTitle = messageTitle.replaceAll('+', " ");
        orgChannelName = orgChannelName.replaceAll('+', " ");
      } catch (e) {}

      //{orgName: The+RISE+USA, orgLogo: https://d1rtv5ttcyt7b.cloudfront.net/app/1596688715903_rise.png,
      //print("msgData :==>"+msgData);

      // print("contentURI :==>"+msgData);
      // print("contentURI :==>"+contentType);
      // print("contentURI :==>"+messageTitle);
      // print("globalISPNPageOpened :==>" + globalISPNPageOpened.toString());
      // if (globalISPNPageOpened) Navigator.of(context).pop();

      if (contentType == "pdf") {
        msgData = orgChannelName + " has sent a PDF. Do you want to open?  ";
      } else if (contentType == "video") {
        msgData = orgChannelName + " has sent a video. Do you want to open?  ";
      } else if (contentType == "url") {
        msgData = orgChannelName + " has sent a url. Do you want to open?  ";
      } else if (contentType == "image") {
        msgData = orgChannelName + " has sent a image. Do you want to open?  ";
      } else {}

      CoolAlert.show(
          context: context,
          type: contentType == "plain"?CoolAlertType.info:CoolAlertType.confirm,
          text: contentType == "plain"?msgData.replaceAll("+", " "):msgData,
          title: messageTitle,
          confirmBtnText: contentType == "plain"?"OK":"Proceed",
          loopAnimation: false,
          onConfirmBtnTap: () async {
            Navigator.of(context).pop();
            if (contentType == "pdf") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PdfViewerNew(
                      title: messageTitle, pdfUrl: msgObject['contentURI'])));
            } else if (contentType == "video") {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => BGVideoPlayerView(
              //               videoUrl: msgObject["contentURI"],
              //               title: messageTitle,
              //               local: 'false',
              //             )));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VideoAppChewie( videoUrl: msgObject["contentURI"],
                        title: messageTitle,)));
            } else if (contentType == "url") {
              if (await canLaunch(msgObject['contentURI'])) {
                await launch(msgObject['contentURI']);
              } else {
                String url = msgObject['contentURI'];
                throw 'Could not launch $url';
              }
            } else if (contentType == "image") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullPhoto(
                            url: msgObject['contentURI'],
                            title: messageTitle,
                          )));
            } else {}
          });
    } else {
      print("no contentType :==>");
    }
  }
}
