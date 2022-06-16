import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:ACI/Model/GroupchatMembersModel.dart';
import 'package:ACI/Model/GroupsModelChat.dart';
import 'package:ACI/Model/create_edit_profile_model.dart';
import 'package:ACI/Screen/AddnewChatGroup.dart';
import 'package:ACI/Screen/ChatProfile.dart';
import 'package:ACI/data/api/repository/ChatRepo.dart';
import 'package:ACI/data/api/repository/ResourceRepo.dart';
import 'package:ACI/data/api/repository/api_intercepter.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/Uploadchat.dart';
import 'package:ACI/utils/mycircleavatar.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'Controllers/firebaseController.dart';
import 'Controllers/pickImageController.dart';
import 'Controllers/utils.dart';
import 'fullphoto.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'dart:async';
import 'package:flutter/cupertino.dart';

import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;


class ChatroomGroup extends StatefulWidget {
  ChatroomGroup(
      this.myID,
      this.myName,
      this.selectedUserToken,
      this.selectedUserID,
      this.chatID,
      this.selectedUserName,
      this.selectedUserThumbnail,
      this.countrycode);

  String myID;
  String myName;
  String selectedUserToken;
  String selectedUserID;
  String chatID;
  String selectedUserName;
  String selectedUserThumbnail;
  String countrycode;

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatroomGroup> with WidgetsBindingObserver {
  final TextEditingController _msgTextController = new TextEditingController();
  final ScrollController _chatListController = ScrollController();
  String messageType = 'text';
  bool _isLoading = false;
  int chatListLength = 20;
  double _scrollPosition = 560;
  File? _image;
  bool _isImageAvailable = false;
  String fileName = "";
  File? imageFile;
  bool? isLoading;
  bool isShowSticker=false;
  String imageUrl="";
  final FocusNode focusNode = FocusNode();
  var date = "01 sep";
  var show = "";
  List<DataModel> datemodel = <DataModel>[];
   CreateEditProfileModel createEditProfileModel=CreateEditProfileModel();
  static final ChatRepo resourceRepository = new ChatRepo();
  var timestamp;
  GroupchatMembersModel? addedGroupsModelnew;
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        print('resumed');
        break;
      case AppLifecycleState.inactive:
        print('inactive');
        break;
      case AppLifecycleState.paused:
        print('paused');
        break;
      case AppLifecycleState.detached:
        print('detached');

        break;
    }
  }

  _scrollListener() {
    setState(() {
      if (_scrollPosition < _chatListController.position.pixels) {
        _scrollPosition = _scrollPosition + 560;
        chatListLength = chatListLength + 20;
      }
//      _scrollPosition = _chatListController.position.pixels;
      print('list view position is ' + _chatListController.position.toString());
    });
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future getImage() async {
    // var image = await ImagePicker().getImage(source: ImageSource.gallery);

    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: AppColors.APP_BLUE,
              title: Text("Select the image to Upload",
                  style: TextStyle(color: Colors.white)),
              actions: <Widget>[
                MaterialButton(
                  child: Text(
                    "Camera",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text(
                    "Gallery",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));
    if (imageSource != null) {
      var file;
      file = await ImagePicker.platform.pickImage(source: imageSource);

      if (imageSource == ImageSource.camera) {
        //  file = await FlutterExifRotation.rotateAndSaveImage(path: file.path);

      }

      if (file != null) {
        File? croppedFile = await ImageCropper.cropImage(
            sourcePath: file.path,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: 'ClariTea Chat',
                toolbarColor: AppColors.APP_BLUE,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            iosUiSettings: IOSUiSettings(
              minimumAspectRatio: 1.0,
            ));
        var tempFileName = (new DateTime.now()).millisecondsSinceEpoch;
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path + "/" + tempFileName.toString() + ".jpg";
        File fileNew = File(tempPath);
        File? result = await FlutterImageCompress.compressAndGetFile(
            croppedFile!.absolute.path, tempPath,
            quality: 50);
        // File result = croppedFile;

        fileName = tempPath;
        //print("filePath from ImagePicker :==>" + fileName);
        if (croppedFile != null) {
          setState(() {
            _image = fileNew;
            _isImageAvailable = true;

            //Clear Edit Resource bytes
            // editResourceProfImage = "";
            // widget.editResourceDetail.profilePicture = "";
          });
        }
      }
    }

    if (_image != null) {
      imageFile = File(_image!.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        String los = await fileuploadchat(filePath: _image!.path);
        if (los != '') {
          _handleSubmitted(los);
        } else {}
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  @override
  void initState() {
    initializeDateFormatting();
    WidgetsBinding.instance.addObserver(this);
    getdata();
    focusNode.addListener(onFocusChange);
    isShowSticker = false;
    imageUrl=widget.selectedUserThumbnail;

    setCurrentChatRoomID(widget.chatID);
    FirebaseController.instanace.getUnreadMSGCount();
    _chatListController.addListener(_scrollListener);
    super.initState();
  }

  void getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final resourceDetailsResponse = await json
        .decode(prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString());
    createEditProfileModel =
        CreateEditProfileModel.fromJson(resourceDetailsResponse);
     try{
       addedGroupsModelnew = await resourceRepository
           .getchatpersonsgrpsfordisplay(widget.selectedUserID);
     }catch(_){

     }
    print("ids" + widget.selectedUserID);
    print("ids" + widget.countrycode);

    setState(() {});
  }

  @override
  void dispose() {
    setCurrentChatRoomID('none');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globalcontext = context;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Theme.of(context)
          .primaryColorDark, //or set color with: Color(0xFF0000FF)
    ));
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(

              actions: [
                widget.countrycode==widget.myID?Container(
                  width: 35,
                  height: 35,
                  margin: EdgeInsets.only(right: 10),
                  child: RawMaterialButton(
                    fillColor: Colors.white,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(5),
                    onPressed: () async {
                      CoolAlert.show(
                          context: context,
                          type: CoolAlertType.confirm,
                          text: "Do you want to Delete group?",
                          title: "Delete Group",
                          onConfirmBtnTap: (){
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.selectedUserID)
                                .delete().then((_)  {
                              FirebaseFirestore.instance
                                  .collection('chatroom')
                                  .doc(widget.selectedUserID)
                                  .delete().then((dtat) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                // Navigator.pop(context, "delete");
                              });

                            });

                          }
                      );

                    },
                    child: Icon(Icons.exit_to_app,color: Colors.red,),
                  ),
                ):Container(),
                widget.countrycode==widget.myID?Container(
                  width: 35,
                  height: 35,
                  margin: EdgeInsets.only(right: 0),
                  child: RawMaterialButton(
                    fillColor: Colors.white,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(5),
                    onPressed: () async {
                      Navigator.of(context)
                          .push(new MaterialPageRoute<String>(
                          builder: (context) => AddnewChatGroup(
                            groupname: widget.selectedUserName,
                            groupid: widget.selectedUserID,
                            img: widget.selectedUserThumbnail,
                          )))
                          .then((String? value) async {
                        print(value);
                        try{
                          addedGroupsModelnew = await resourceRepository
                              .getchatpersonsgrpsfordisplay(widget.selectedUserID);
                          setState(() {

                          });
                        }catch(_){

                        }
                      });

                    },
                    child: Icon(Icons.group_add,color: Colors.red,),
                  ),
                ):
                Container(
                  width: 35,
                  height: 35,
                  child: RawMaterialButton(
                      fillColor: Colors.white,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.exit_to_app,color: Colors.red,), onPressed: () {
                    CoolAlert.show(
                        context: context,
                        type: CoolAlertType.confirm,
                        text: "Do you want to exit group?",
                        title: "Exit Group",
                        loopAnimation: true,

                        onConfirmBtnTap: (){
                          resourceRepository.deletegroupsinchat(
                              createEditProfileModel, widget.selectedUserID,
                              widget.myID
                                  .toString());
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.myID)
                              .collection('chatlist')
                              .doc(widget.selectedUserID)
                              .delete().then((_) {

                            print("delete");
                            Navigator.pop(context);
                            Navigator.pop(context);
                            // onBackPress();
                          });
                        }
                    );




                  }),
                ),
                createEditProfileModel == null
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(right: 8, top: 6, bottom: 6),
                        child: createEditProfileModel.universityLogo == "" ||
                                createEditProfileModel.universityLogo == null
                            ? Container()
                            : Image.network(
                                createEditProfileModel.universityLogo!,
                                width: 55,
                                height: 40,
                              ),
                      ),
              ],
              backgroundColor: AppColors.APP_LIGHT_BLUE_20,
              iconTheme: IconThemeData(color: Colors.white),
              title: GestureDetector(
                onTap: () {},
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context)
                        .push(new MaterialPageRoute<String>(
                        builder: (context) => ProfileView(
                          widget.selectedUserName,
                          imageUrl,
                          widget.selectedUserID,
                          addedGroupsModelnew==null?GroupchatMembersModel():addedGroupsModelnew,
                          widget.countrycode==widget.myID?true:false,
                        )))
                        .then((String? value) {
                      print(value);
                      if(value!=null){
                        if (value=="delete") {
                          Navigator.pop(context, true);
                        }
                        imageUrl=value;
                      }
                      setState(() {
                      });
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      widget.selectedUserThumbnail.toString() == 'null' ||
                              widget.selectedUserThumbnail ==
                                  'https://d1rtv5ttcyt7b.cloudfront.net/null'
                          ? CircleAvatar(
                              child: Icon(Icons.person),
                            )
                          : MyCircleAvatar(
                              imgUrl: imageUrl,
                            ),
                      SizedBox(width: 15),
                      Container(
                        width: MediaQuery.of(context).size.width-238,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.selectedUserName,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.white, fontSize: 20),
                              overflow: TextOverflow.clip,
                            ),
                            Text(
                              addedGroupsModelnew!=null&&addedGroupsModelnew!.numberOfUsers==1?addedGroupsModelnew!.groupChatUsers![0].firstName!:addedGroupsModelnew!=null&&addedGroupsModelnew!.numberOfUsers!>=2?addedGroupsModelnew!.groupChatUsers![0].firstName!+","+addedGroupsModelnew!.groupChatUsers![1].firstName!:"Tap Here To View Group",
                              style: Theme.of(context).textTheme.subtitle1!.apply(
                                    color: Colors.white,
                                  ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // actions: <Widget>[
              //   IconButton(
              //     icon: Icon(Icons.phone,color: Colors.white,),
              //     onPressed: () {
              //       Fluttertoast.showToast(msg: 'Coming Soon!');
              //     },
              //   ),
              //   IconButton(
              //     icon: Icon(Icons.videocam,color: Colors.white,),
              //     onPressed: () {
              //       Fluttertoast.showToast(msg: 'Coming Soon!');
              //     },
              //   ),
              //   IconButton(
              //     icon: Icon(Icons.more_vert,color: Colors.white,),
              //     onPressed: () {
              //       Fluttertoast.showToast(msg: 'Coming Soon!');
              //     },
              //   ),
              // ],
            ),
            body: VisibilityDetector(
              key: Key("1"),
              onVisibilityChanged: ((visibility) {
                print('ChatRoom Visibility code is ' +
                    '${visibility.visibleFraction}');
                if (visibility.visibleFraction == 1.0) {
                  FirebaseController.instanace.getUnreadMSGCount();
                }
              }),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chatroom')
                      .doc(widget.chatID)
                      .collection(widget.chatID)
                      .orderBy('timestamp', descending: true)
                      .limit(chatListLength)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();
                    if (snapshot.hasData) {
                      // try {
                      //   timestamp =
                      //       snapshot.data!.docs[0].data()['timestamp'];
                      //   print("widgetbuild" + timestamp);
                      // } catch (e) {
                      //   print("widgetbuild" + timestamp.toString());
                      // }

                      for (var data in snapshot.data!.docs) {
                        if (data['idTo'] == widget.myID &&
                            data['isread'] == false) {
                          if (data.reference != null) {
                            FirebaseFirestore.instance.runTransaction(
                                (Transaction myTransaction) async {
                              await myTransaction
                                  .update(data.reference, {'isread': true});
                            });
                          }
                        }
                      }
                    }
                    return Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.all(10.0),
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    snapshot.data!.docs[index]['idFrom'] !=
                                            createEditProfileModel.mobile
                                        ? _listItemOther(
                                            context,
                                            snapshot.data!.docs[index]['msgname']
                                                .toString(),
                                            snapshot
                                                .data!.docs[index]['msgimage']
                                                .toString(),
                                            snapshot.data!.docs[index]
                                                ['content'],
                                            returnTimeStamp(snapshot
                                                .data!.docs[index]['timestamp']),
                                            snapshot.data!.docs[index]['type'])
                                        : _listItemMine(
                                            context,
                                            snapshot.data!.docs[index]
                                                ['content'],
                                            returnTimeStamp(snapshot
                                                .data!.docs[index]['timestamp']),
                                            snapshot.data!.docs[index]['isread'],
                                            snapshot.data!.docs[index]['type'])
                                  ],
                                ),
                                itemCount: snapshot.data!.docs.length,
                                reverse: true,
                                shrinkWrap: true,
                                controller: _chatListController,
                              ),

                              // ListView(
                              //     reverse: true,
                              //     shrinkWrap: true,
                              //     padding:
                              //         const EdgeInsets.fromLTRB(4.0, 10, 4, 10),
                              //     controller: _chatListController,
                              //     children: snapshot.data.documents.map((data) {
                              //
                              //
                              //       //snapshot.data.documents.reversed.map((data) {
                              //       return Column(
                              //         children: [
                              //           show =="1"? Container(
                              //                   child: Text('' +
                              //                       returnTimeStampmon(
                              //                               data['timestamp'])
                              //                           .toString()),
                              //                 )
                              //               : Container(),
                              //           data['idFrom'] == widget.selectedUserID
                              //               ? _listItemOther(
                              //                   context,
                              //                   widget.selectedUserName,
                              //                   widget.selectedUserThumbnail,
                              //                   data['content'],
                              //                   returnTimeStamp(
                              //                       data['timestamp']),
                              //                   data['type'])
                              //               : _listItemMine(
                              //                   context,
                              //                   data['content'],
                              //                   returnTimeStamp(
                              //                       data['timestamp']),
                              //                   data['isread'],
                              //                   data['type'])
                              //         ],
                              //       );
                              //     }).toList()),
                            ),
                            buildInputnew(),
                            (isShowSticker ? buildSticker() : Container()),
                          ],
                        ),
//                Positioned(
//                  // Loading view in the center.
//                  child: _isLoading
//                      ? Container(
//                    child: Center(
//                      child: CircularProgressIndicator(),
//                    ),
//                    color: Colors.white.withOpacity(0.7),
//                  )
//                      : Container(),
//                ),
                      ],
                    );
                  }),
            )),
        onWillPop: onBackPress);
  }

  Widget _listItemOther(BuildContext context, String name, String thumbnail,
      String message, String time, String type) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24.0),
                      child: thumbnail == "null"
                          ? CircleAvatar(
                              child: Icon(Icons.person),
                            )
                          : CachedNetworkImage(
                              imageUrl: thumbnail,
                              placeholder: (context, url) => Container(
                                transform:
                                    Matrix4.translationValues(0.0, 0.0, 0.0),
                                child: Container(
                                    width: 60,
                                    height: 60,
                                    child: Center(
                                        child:
                                            new CircularProgressIndicator())),
                              ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * .6),
                            padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(type == 'text' ? 4.0 : 0),
                              child: Container(
                                  child: type == 'text'
                                      ? Text(
                                          message,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        )
                                      : type == 'Sticker'
                                          ? Container(
                                              child: Image.asset(
                                                'assets/images/sticker/${message}.gif',
                                                width: 100.0,
                                                height: 100.0,
                                                fit: BoxFit.cover,
                                              ),
                                              margin: EdgeInsets.only(
                                                  bottom: 20.0, right: 10.0),
                                            )
                                          : _imageMessage(message)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14.0, left: 8),
                          child: Text(
                            time,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .apply(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _listItemMine(BuildContext context, String message, String time,
      bool isRead, String type) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 14.0, right: 2, left: 4),
          //   child: Text(
          //     isRead ? '' : '1',
          //     style: TextStyle(fontSize: 12, color: Colors.yellow[900]),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(bottom: 14.0, right: 4, left: 8),
            child: Text(time,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .apply(color: Colors.grey)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 4, 8),
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .6),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: type == 'text'
                        ? isRead ? Colors.green : Colors.yellow[900]
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      topLeft: Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(type == 'text' ? 4.0 : 0),
                    child: Container(
                        child: type == 'text'
                            ? Text(
                                message,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )
                            : type == 'Sticker'
                                ? Container(
                                    child: Image.asset(
                                      'assets/images/sticker/${message}.gif',
                                      width: 100.0,
                                      height: 100.0,
                                      fit: BoxFit.cover,
                                    ),
                                    margin: EdgeInsets.only(
                                        bottom: 20.0, right: 10.0),
                                  )
                                : _imageMessage(message)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageMessage(imageUrlFromFB) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FullPhoto(url: imageUrlFromFB)));
        },
        child: CachedNetworkImage(
          imageUrl: imageUrlFromFB.toString(),
          placeholder: (context, url) => Container(
            transform: Matrix4.translationValues(0, 0, 0),
            child: Container(
                width: 60,
                height: 80,
                child: Center(child: new CircularProgressIndicator())),
          ),
          errorWidget: (context, url, error) => new Icon(Icons.error),
          width: 60,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<bool> onBackPress() async {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      // await Firestore.instance
      //      .collection('users')
      //      .document(groupChatId)
      //      .updateData({
      //    'lastmsg': '',
      //  });

      updatetimestamp(timestamp);
      Navigator.pop(context, true);
    }

    return Future.value(false);
  }

  Widget buildInputnew() {
    return Container(
      margin: EdgeInsets.all(15.0),
      height: 60,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35.0),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
                ],
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.face),
                      onPressed: () {
                        getSticker();
                      }),
                  Expanded(
                    child: TextField(
                      controller: _msgTextController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                          hintText: "Type Something...",
                          border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.photo_camera),
                    onPressed: () {
                      setState(() {
                        messageType = 'image';
                        _isLoading = true;
                      });
                      getImage();
                    },
                  ),
                  /*IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: () {

                    },
                  )*/
                ],
              ),
            ),
          ),
          SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.all(15.0),
            decoration:
                BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            child: InkWell(
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
              onTap: () {
                setState(() {
                  messageType = 'text';
                });
                if (_msgTextController.text.trim().length != 0) {
                  _handleSubmitted(_msgTextController.text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }



  _makePostRequest(String msg, String id) async {

    String userImage = createEditProfileModel.profilePicture!;
    String peerId = widget.selectedUserID;
    String username = createEditProfileModel.firstName!;
    String countrycode = widget.countrycode;
    username = username.replaceAll(RegExp(' +'), ' ');

    // set up POST request arguments

    String url =
        '${AppStrings.BASE_URL}api/v1/chat/group/notification/org/1/group/$peerId/user/${createEditProfileModel.id}';
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    String json =
        '{"message":"$msg","id":"$id","peerurl":"${imageUrl}","timezone":"$time","peerid":"$globalPhoneNo","peername":"${widget.selectedUserName}","peercode":"grp"}';
    // make POST request
    var response = await client.post(Uri.parse(url),   body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    String body = response.body;
    print(body.toString());
    // {
    //   "title": "Hello",
    //   "body": "body text",
    //   "userId": 1,
    //   "id": 101
    // }
  }

  _makePostRequestnew(String msg, String id) async {
    GroupsModelChat chatmode = new GroupsModelChat();
    chatmode.groupId = widget.selectedUserID;
    chatmode.id = createEditProfileModel.id.toString();
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    String json =
        '{"message":"$msg","id":"$id","peerurl":"${widget.selectedUserThumbnail}","timezone":"$time","peerid":"$globalPhoneNo","peername":"${widget.selectedUserName}","peercode":"grp"}';
    chatmode.message = json;
    resourceRepository.sentgroupsnotificationinchat(
        chatmode,
        createEditProfileModel,
        widget.selectedUserID,
        createEditProfileModel.id.toString());
  }

  void updatetimestamp(timestamp) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.myID)
        .collection('chatlist')
        .doc(widget.selectedUserID)
        .get()
        .then((value) {
      print(value.exists);
      if (value.exists) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.myID)
            .collection('chatlist')
            .doc(widget.selectedUserID)
            .set({
          'chatID': widget.selectedUserID,
          'chatWith': widget.selectedUserID,
          'lastChat': 'New Group',
          'isGroup': '0',
          'timestamp': timestamp
        });
      }
    });
  }

  Future<void> _handleSubmitted(String text) async {
    _msgTextController.clear();
    try {
      setState(() {
        _isLoading = true;
      });

      var stamp = DateTime.now().millisecondsSinceEpoch;

      await FirebaseController.instanace.sendMessageToChatRoom(
          widget.selectedUserID,
          widget.myID,
          widget.selectedUserID,
          text,
          messageType,
          createEditProfileModel,
          stamp);
      String cot = '';
      if (messageType == "text") {
        cot = text;
      } else {
        cot = 'picture';
      }
      _makePostRequest(cot, widget.chatID);

      timestamp = stamp;
      setState(() {});
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.selectedUserID)
          .update({
        'msgname': createEditProfileModel.firstName,
        'lastmsg': cot,
        'createdAt': stamp
      });

      // await FirebaseController.instanace.updateChatRequestFieldgrp(
      //     widget.myID,
      //     messageType == 'text' ? text : '(Photo)',
      //     widget.chatID,
      //     widget.myID,
      //     widget.selectedUserID);
      _getUnreadMSGCountThenSendMessage();
    } catch (e) {
      _showDialog('Error user information to database');
      _resetTextFieldAndLoading();
    }
  }

  Future<void> _getUnreadMSGCountThenSendMessage() async {
    try {
      int? unReadMSGCount = await FirebaseController.instanace
          .getUnreadMSGCount(widget.selectedUserID);
      // await NotificationController.instance.sendNotificationMessageToPeerUser(
      //     unReadMSGCount,
      //     messageType,
      //     _msgTextController.text,
      //     widget.myName,
      //     widget.chatID,
      //     widget.selectedUserToken);
    } catch (e) {
      print(e);
    }
    _resetTextFieldAndLoading();
  }

  _resetTextFieldAndLoading() {
    // FocusScope.of(context).requestFocus(FocusNode());
    // _msgTextController.text = '';
    // setState(() {
    //   _isLoading = false;
    // });
  }

  _showDialog(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(msg),
          );
        });
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  onSendMessage('funny4', 2);
                },
                child: Image.asset(
                  'assets/images/sticker/funny4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('funny5', 2),
                child: Image.asset(
                  'assets/images/sticker/funny5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('funny6', 2),
                child: Image.asset(
                  'assets/images/sticker/funny6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('kitty', 2),
                child: Image.asset(
                  'assets/images/sticker/kitty.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('funny', 2),
                child: Image.asset(
                  'assets/images/sticker/funny.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('funny1', 2),
                child: Image.asset(
                  'assets/images/sticker/funny1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('tenor', 2),
                child: Image.asset(
                  'assets/images/sticker/tenor.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('funny2', 2),
                child: Image.asset(
                  'assets/images/sticker/funny2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('funny3', 2),
                child: Image.asset(
                  'assets/images/sticker/funny3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('funny7', 2),
                child: Image.asset(
                  'assets/images/sticker/funny7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('funny8', 2),
                child: Image.asset(
                  'assets/images/sticker/funny8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('tenor1', 2),
                child: Image.asset(
                  'assets/images/sticker/tenor1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(3.0),
      height: 280.0,
    );
  }

  void onSendMessage(String s, int i) {
    setState(() {
      messageType = 'Sticker';
    });
    _handleSubmitted(s);
  }
}

class DataModel {
  String date;
  bool view;

  DataModel(this.date, this.view);
}
