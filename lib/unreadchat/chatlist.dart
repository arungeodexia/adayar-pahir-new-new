import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ACI/Model/GroupsModelChat.dart';
import 'package:ACI/Model/create_edit_profile_model.dart';
import 'package:ACI/data/api/repository/ChatRepo.dart';
import 'package:ACI/data/api/repository/ResourceRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'AddnewChat.dart';
import 'Controllers/firebaseController.dart';
import 'Controllers/utils.dart';
import 'chatroom.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:contacts_service/contacts_service.dart' as cs;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

//import 'package:ishare/models/SearchResultDetailsModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'dart:typed_data';

import 'chatroom_Group.dart';

class ChatList extends StatefulWidget {
  ChatList(this.myID, this.myName);

  String myID;
  String myName;

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  CreateEditProfileModel? createEditProfileModel;
  String? _groupName;
  static final ChatRepo resourceRepository = new ChatRepo();

  bool isnochat=true;

  @override
  void initState() {
    FirebaseController.instanace.getUnreadMSGCount();
    getdata();

    setState(() {
      unreads = '';
    });
    Future.delayed(const Duration(milliseconds: 500), () {

// Here you can write your code

      setState(() {
        // Here you can write your code for open new view
      });

    });
    super.initState();

  }

  void getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final resourceDetailsResponse = await json
        .decode(prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString());
    createEditProfileModel =
        CreateEditProfileModel.fromJson(resourceDetailsResponse);
    // resourceRepository.getorgid("grpid");
    FirebaseMessaging.instance.getToken().then((token) {
      print(token);
    });
    setState(() {});
  }

  void _popupDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget createButton = FlatButton(
      child: Text("Create"),
      onPressed: () async {
        DateTime now = DateTime.now();
        var grpid = _groupName!.replaceAll(" ", "");
        grpid = grpid + DateTime.now().millisecondsSinceEpoch.toString();
        if (_groupName != null) {
          FirebaseController.instanace
              .saveUserDataToFirebaseDatabase(
                  grpid,
                  _groupName,
                  createEditProfileModel!.mobile,
                  createEditProfileModel!.profilePicture)
              .then((data) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(createEditProfileModel!.mobile!)
                .collection('chatlist')
                .doc(grpid)
                .set({
              'chatID': grpid,
              'chatWith': grpid,
              'lastChat': 'New Group',
              'isGroup': '0',
              'timestamp': DateTime.now().millisecondsSinceEpoch
            });
            GroupsModelChat chatmode = new GroupsModelChat();
            chatmode.groupId = grpid;
            chatmode.id = createEditProfileModel!.id.toString();
            chatmode.message = grpid;
            resourceRepository.creategroupsinchat(
                chatmode,
                createEditProfileModel!,
                grpid,
                createEditProfileModel!.id.toString());
          });
          Navigator.of(context).pop();
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create a group"),
      content: TextField(
          onChanged: (val) {
            _groupName = val;
          },
          style: TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black)),
      actions: [
        cancelButton,
        createButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    globalcontext = context;
    return Scaffold(
        // appBar: AppBar(
        //   centerTitle: true, // this is all you need
        //   title: Text("Chat"),
        //   actions: [
        //     Container(
        //       margin: EdgeInsets.only(right: 20),
        //       child: GestureDetector(
        //         onTap: () async {
        //           Navigator.of(context)
        //               .push(new MaterialPageRoute<String>(
        //                   builder: (context) => AddnewChat()))
        //               .then((String? value) {
        //             print(value);
        //           });
        //         },
        //         child: Icon(Icons.add),
        //       ),
        //     ),
        //     // createEditProfileModel == null
        //     //     ? Container()
        //     //     : Padding(
        //     //         padding: EdgeInsets.only(right: 8, top: 6, bottom: 6),
        //     //         child: createEditProfileModel!.universityLogo! == "" ||
        //     //                 createEditProfileModel!.universityLogo! == null
        //     //             ? Container()
        //     //             : Image.network(
        //     //                 createEditProfileModel!.universityLogo!,
        //     //                 width: 55,
        //     //                 height: 40,
        //     //               ),
        //     //       ),
        //   ],
        // ),
        // floatingActionButton: FloatingActionButton.extended(
        //   isExtended: true,
        //   onPressed: () {
        //     _popupDialog(context);
        //   },
        //   icon: Icon(Icons.group_add, color: Colors.white, size: 30.0),
        //   label: Text("Create Group"),
        //   backgroundColor: Colors.grey[700],
        //   elevation: 0.0,
        // ),
        body: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.myID)
                    .collection('chatlist')
                    .snapshots(),
                builder: (context, chatListSnapshot) {
                  if(!chatListSnapshot.hasData){
                    return Container(
                      child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.forum,
                                color: Colors.grey[700],
                                size: 64,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  tr('nochat'),
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[700]),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )),
                    );

                  }else{
                    if(chatListSnapshot.data!.docs.length==0){
                      return Container(
                        child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.forum,
                                  color: Colors.grey[700],
                                  size: 64,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    tr('nochat'),
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey[700]),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )),
                      );

                    }else{
                      return Container();

                    }
                  }
                }),

            VisibilityDetector(
              key: Key("1"),
              onVisibilityChanged: ((visibility) {
                print('ChatList Visibility code is ' +
                    '${visibility.visibleFraction}');
                if (visibility.visibleFraction == 1.0) {
                  FirebaseController.instanace.getUnreadMSGCount();
                }
              }),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                        color: Colors.white.withOpacity(0.7),
                      );

                    } else if(snapshot.hasData){
                      return true
                          ? ListView(
                          children: snapshot.data!.docs.map((data) {
                            print(data['userId']);
                            if (data['userId'] == widget.myID) {
                              return Container(

                              );
                            } else {
                              return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.myID)
                                      .collection('chatlist')
                                      .where('chatWith', isEqualTo: data['userId'])
                                      .snapshots(),
                                  builder: (context, chatListSnapshot) {
                                    try {
                                      if (chatListSnapshot.hasData) {
                                        print(chatListSnapshot.data);
                                        print(chatListSnapshot.data!.docs.length);
                                        // print(chatListSnapshot.data!.docs[0]["lastChat"]);
                                      }

                                      if ((chatListSnapshot.hasData &&
                                          chatListSnapshot.data!.docs.length > 0)) {
                                        isnochat=false;
                                        return Card(
                                          elevation: 8.0,
                                          shape: RoundedRectangleBorder(
                                            // side:             (chatListSnapshot.hasData &&
                                            //     chatListSnapshot
                                            //         .data
                                            //         .documents
                                            //         .length >
                                            //         0)
                                            //     ? chatListSnapshot.data.docs[0]
                                            //     .data()
                                            //     .containsKey("isGroup")
                                            //     ?   new BorderSide(color: Colors.amber, width: 2.0):new BorderSide(color: Colors.amber, width: 0.0):new BorderSide(color: Colors.amber, width: 0.0),
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                          margin: new EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 6.0),
                                          child: Container(
                                            decoration: new BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              color: (chatListSnapshot.hasData &&
                                                  chatListSnapshot
                                                      .data!.docs.length >
                                                      0)
                                                  ? chatListSnapshot.data!.docs[0]
                                                  .data()
                                                  .toString()
                                                  .contains("isGroup")
                                                  ? Colors.blueGrey
                                                  : AppColors.APP_LIGHT_BLUE_20
                                                  : AppColors.APP_LISTVIEW_BACK,
                                              // color: AppColors.APP_LISTVIEW_BACK,
                                              // radius of 10
                                              // gradient: new LinearGradient(
                                              //     colors: [
                                              //       AppColors.APP_LISTVIEW_BACK,
                                              //       AppColors.APP_LISTVIEW_BACK,
                                              //     ],
                                              //     begin: const FractionalOffset(
                                              //         0.0, 0.0),
                                              //     end: const FractionalOffset(
                                              //         1.0, 0.0),
                                              //     stops: [0.0, 1.0],
                                              //     tileMode: TileMode.repeated),
                                            ),
                                            child: ListTile(
                                              leading: data['userImageUrl'].toString() == "null"
                                                  ? CircleAvatar(
                                                  onBackgroundImageError:
                                                      (context, url) =>
                                                      Icon(Icons.error),
                                                  radius: 20.0,
                                                  backgroundColor:
                                                  const Color(0xFF777899),
                                                  backgroundImage: (AssetImage(
                                                      "images/photo_avatar.png")))
                                                  : CircleAvatar(
                                                  onBackgroundImageError:
                                                      (context, url) =>
                                                      Icon(Icons.error),
                                                  radius: 20.0,
                                                  backgroundColor:
                                                  const Color(0xFF777899),
                                                  backgroundImage: ((data['userImageUrl'] != "" ||
                                                      data['userImageUrl'] !=
                                                          null)
                                                      ? NetworkImage(
                                                      data['userImageUrl'])
                                                      : AssetImage("images/photo_avatar.png")
                                                  as ImageProvider)),
                                              title: Text(
                                                data['name'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .apply(
                                                  color: AppColors.APP_WHITE,
                                                ),
                                                maxLines: 1,
                                              ),
                                              subtitle: (chatListSnapshot.hasData &&
                                                  chatListSnapshot
                                                      .data!.docs.length >
                                                      0)
                                                  ? chatListSnapshot.data!.docs[0]
                                                  .data()
                                                  .toString()
                                                  .contains("isGroup")
                                                  ? StreamBuilder<
                                                  DocumentSnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(data['userId'])
                                                      .snapshots(),
                                                  builder: (context, msg) {
                                                    return Text(
                                                      msg.hasData
                                                          ? msg.data!
                                                          .data()
                                                          .toString()
                                                          .contains(
                                                          "lastmsg")
                                                          ? msg.data![
                                                      "lastmsg"]
                                                          .toString()
                                                          : ""
                                                          : "",
                                                      style:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .subtitle1!
                                                          .apply(
                                                        color: AppColors
                                                            .APP_LIGHTWHITE,
                                                      ),
                                                    );
                                                  })
                                                  : Text(
                                                (chatListSnapshot
                                                    .hasData &&
                                                    chatListSnapshot
                                                        .data!
                                                        .docs
                                                        .length >
                                                        0)
                                                    ? chatListSnapshot
                                                    .data!.docs[0]
                                                    .data()
                                                    .toString()
                                                    .contains(
                                                    "isGroup")
                                                    ? ""
                                                    : chatListSnapshot
                                                    .data!
                                                    .docs[0]
                                                ["lastChat"]
                                                    : data['intro'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .apply(
                                                  color: AppColors
                                                      .APP_LIGHTWHITE,
                                                ),
                                                maxLines: 2,
                                              )
                                                  : Container(),
                                              trailing: Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 8, 4, 4),
                                                  child:
                                                  (chatListSnapshot.hasData &&
                                                      chatListSnapshot.data!
                                                          .docs.length >
                                                          0)
                                                      ? chatListSnapshot
                                                      .data!.docs[0]
                                                      .data()
                                                      .toString()
                                                      .contains(
                                                      "isGroup")
                                                      ? StreamBuilder<
                                                      DocumentSnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                          'users')
                                                          .doc(data[
                                                      'userId'])
                                                          .snapshots(),
                                                      builder: (context,
                                                          timestampmsg) {
                                                        return Container(
                                                          width: 63,
                                                          height: 50,
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.check,
                                                                    size:
                                                                    15,
                                                                    color:
                                                                    AppColors.APP_LIGHTWHITE,
                                                                  ),
                                                                  Text(
                                                                    timestampmsg.hasData
                                                                        ? timestampmsg.data!.data().toString().contains("createdAt")
                                                                        ? readTimestamp(timestampmsg.data!["createdAt"]).toString()
                                                                        : ""
                                                                        : "",
                                                                    style:
                                                                    TextStyle(color: AppColors.APP_LIGHTWHITE, fontSize: 12),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                  padding: const EdgeInsets.fromLTRB(
                                                                      0,
                                                                      5,
                                                                      0,
                                                                      0),
                                                                  child:
                                                                  (chatListSnapshot.hasData && chatListSnapshot.data!.docs.length > 0 && timestampmsg.data != null)
                                                                      ? timestampmsg.data!["createdAt"].toString() == chatListSnapshot.data!.docs[0]['timestamp'].toString()?CircleAvatar(
                                                                    radius:
                                                                    9,
                                                                    child:
                                                                    Text(
                                                                      (chatListSnapshot.hasData && chatListSnapshot.data!.docs.length > 0 && timestampmsg.data != null)
                                                                          ? timestampmsg.data!["createdAt"].toString() == chatListSnapshot.data!.docs[0]['timestamp'].toString()
                                                                          ? "n"
                                                                          : ""
                                                                          : '',
                                                                      style: TextStyle(fontSize: 10),
                                                                    ),
                                                                    backgroundColor: timestampmsg.data != null
                                                                        ? timestampmsg.data!["createdAt"] == chatListSnapshot.data!.docs[0]['timestamp'].toString()
                                                                        ? Colors.transparent
                                                                        : Colors.red
                                                                        : Colors.transparent,
                                                                    foregroundColor:
                                                                    Colors.white,
                                                                  ):Container():Container()),
                                                            ],
                                                          ),
                                                        );
                                                      })
                                                      : StreamBuilder<QuerySnapshot>(
                                                      stream: FirebaseFirestore.instance.collection('chatroom').doc(chatListSnapshot.data!.docs[0]['chatID']).collection(chatListSnapshot.data!.docs[0]['chatID']).where('idTo', isEqualTo: widget.myID).where('isread', isEqualTo: false).snapshots(),
                                                      builder: (context, notReadMSGSnapshot) {
                                                        return Container(
                                                          width: 63,
                                                          height: 50,
                                                          child: Column(
                                                            children: <
                                                                Widget>[
                                                              Row(
                                                                mainAxisSize:
                                                                MainAxisSize.min,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(Icons.check, size: 15, color: AppColors.APP_LIGHTWHITE,),
                                                                  Text(
                                                                    (chatListSnapshot.hasData && chatListSnapshot.data!.docs.length > 0)
                                                                        ? readTimestamp(chatListSnapshot.data!.docs[0]['timestamp'])
                                                                        : '',
                                                                    overflow:
                                                                    TextOverflow.fade,
                                                                    style:
                                                                    TextStyle(color: AppColors.APP_LIGHTWHITE, fontSize: 12),
                                                                  )
                                                                ],
                                                              ),
                                                              Padding(
                                                                  padding: const EdgeInsets.fromLTRB(
                                                                      0,
                                                                      5,
                                                                      0,
                                                                      0),
                                                                  child:
                                                                  CircleAvatar(
                                                                    radius:
                                                                    9,
                                                                    child:
                                                                    Text(
                                                                      (chatListSnapshot.hasData && chatListSnapshot.data!.docs.length > 0) ? ((notReadMSGSnapshot.hasData && notReadMSGSnapshot.data!.docs.length > 0) ? '${notReadMSGSnapshot.data!.docs.length}' : '') : '',
                                                                      style: TextStyle(fontSize: 10),
                                                                    ),
                                                                    backgroundColor: (notReadMSGSnapshot.hasData && notReadMSGSnapshot.data!.docs.length > 0 && notReadMSGSnapshot.hasData && notReadMSGSnapshot.data!.docs.length > 0)
                                                                        ? Colors.red[400]
                                                                        : Colors.transparent,
                                                                    foregroundColor:
                                                                    Colors.white,
                                                                  )),
                                                            ],
                                                          ),
                                                        );
                                                      })
                                                      : Text('')),
                                              onTap: () {
                                                try {
                                                  _moveTochatRoom(
                                                    data['FCMToken'],
                                                    data['userId'],
                                                    data['name'],
                                                    data['userImageUrl'],
                                                    data['intro'],
                                                    chatListSnapshot
                                                        .data!.docs[0]['isGroup']
                                                        .toString(),
                                                  );
                                                } catch (e) {
                                                  print(e.toString());
                                                  _moveTochatRoom(
                                                    data['FCMToken'],
                                                    data['userId'],
                                                    data['name'],
                                                    data['userImageUrl'],
                                                    data['intro'],
                                                    "1",
                                                  );
                                                }
                                              },
                                              onLongPress: () {
                                                CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType
                                                        .confirm,
                                                    text:
                                                    "Do you want to Delete This Chat?",
                                                    title: "Delete Chat",
                                                    onConfirmBtnTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      try {
                                                        if (chatListSnapshot
                                                            .data!
                                                            .docs[
                                                        0][
                                                        'isGroup']
                                                            .toString() ==
                                                            "0") {
                                                          if (data[
                                                          'intro'] ==
                                                              widget.myID) {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                'users')
                                                                .doc(data[
                                                            'userId'])
                                                                .delete()
                                                                .then((_) {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                  'chatroom')
                                                                  .doc(data[
                                                              'userId'])
                                                                  .delete()
                                                                  .then(
                                                                      (dtat) {
                                                                    // Navigator.of(context).pop();
                                                                    // Navigator.pop(context, "delete");
                                                                  });
                                                            });
                                                          } else {
                                                            resourceRepository.deletegroupsinchat(
                                                                createEditProfileModel!, data[
                                                            'userId'],createEditProfileModel!.id.toString());
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                'users')
                                                                .doc(widget
                                                                .myID)
                                                                .collection(
                                                                'chatlist')
                                                                .doc(data[
                                                            'userId'])
                                                                .delete()
                                                                .then((_) {
                                                              print(
                                                                  "delete");
                                                              // Navigator.pop(context);
                                                              // onBackPress();
                                                            });
                                                          }
                                                        } else {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                              'users')
                                                              .doc(data[
                                                          'userId'])
                                                              .delete()
                                                              .then((_) {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                'chatroom')
                                                                .doc(data[
                                                            'userId'])
                                                                .delete()
                                                                .then(
                                                                    (dtat) {
                                                                  // Navigator.of(context).pop();
                                                                  // Navigator.pop(context, "delete");
                                                                });
                                                          });
                                                        }
                                                      } catch (e) {
                                                        String chatID = makeChatId(widget.myID, data[
                                                        'userId']);
                                                        print(chatID);

                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                            'users')
                                                            .doc(widget.myID)
                                                            .collection('chatlist').doc(chatID)
                                                            .delete()
                                                            .then((_) {
                                                          // FirebaseFirestore
                                                          //     .instance
                                                          //     .collection(
                                                          //     'chatroom')
                                                          //     .doc(chatID)
                                                          //     .delete()
                                                          //     .then(
                                                          //         (dtat) {
                                                          //       // Navigator.of(context).pop();
                                                          //       // Navigator.pop(context, "delete");
                                                          //     });
                                                        });
                                                      }
                                                    });
                                              },
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          // child: Text('No chats'),
                                        );
                                      }
                                    } catch (e) {
                                      print(e);
                                      return Container();
                                    }
                                  });
                            }
                          }).toList())
                          :

                      Container(
                        child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.forum,
                                  color: Colors.grey[700],
                                  size: 64,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'There are no users except you.\nPlease use other devices to chat.',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey[700]),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )),
                      );

                    }else{
                     return Container(
                        child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.forum,
                                  color: Colors.grey[700],
                                  size: 64,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'There are no users except you.\nPlease use other devices to chat.',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey[700]),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )),
                      );
                    }
                  }),
            ),

          ],
        ));
  }

  Future<void> _moveTochatRoom(selectedUserToken, selectedUserID,
      selectedUserName, selectedUserThumbnail, countrycode, isGroup) async {
    try {
      String chatID = "";
      if (isGroup == "0") {
        chatID = selectedUserID;
       var data =await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatroomGroup(
                    widget.myID,
                    widget.myName,
                    selectedUserToken,
                    selectedUserID,
                    chatID,
                    selectedUserName,
                    selectedUserThumbnail,
                    countrycode)));
      } else {
        chatID = makeChatId(widget.myID, selectedUserID);
        var data =await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatRoom(
                    widget.myID,
                    widget.myName,
                    selectedUserToken,
                    selectedUserID,
                    chatID,
                    selectedUserName,
                    selectedUserThumbnail,
                    countrycode)));

        // Scaffold.of(context).showSnackBar(SnackBar(content: Text("$data"),duration: Duration(seconds: 3),));


//         Future.delayed(const Duration(milliseconds: 500), () {
//
// // Here you can write your code
//
//           setState(() {
//             // Here you can write your code for open new view
//           });
//
//         });
      }
    } catch (e) {
      print(e);
    }
  }
}
