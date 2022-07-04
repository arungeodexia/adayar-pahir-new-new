import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ACI/Screen/PictureView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:open_file/open_file.dart';
import 'package:ACI/Model/create_edit_profile_model.dart';
import 'package:ACI/data/api/repository/api_intercepter.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/PDFLocal.dart';
import 'package:ACI/utils/Uploadchat.dart';
import 'package:ACI/utils/mycircleavatar.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
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
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;


class ChatRoom extends StatefulWidget {
  ChatRoom(
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

class _ChatRoomState extends State<ChatRoom> {
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
  bool isLoading=false;
  bool isDelete=false;
  bool isShowSticker=false;
  String? imageUrl;
  final FocusNode focusNode = FocusNode();
  var date = "01 sep";
  var show = "";
  List<DataModel> datemodel = <DataModel>[];
  CreateEditProfileModel? createEditProfileModel;

  String msgtxt = "";

  FileType? fileType;

  List<String>? extensions;

  bool? _allowWriteFile=false;
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);


  String progress="";
  Dio? dio;
  int total = 0, received = 0;
  late http.StreamedResponse _response;
  final List<int> _bytes = [];

  var loadertext="Loading";
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
//   Future<String> fileUploadMultipart(
//       {File? file}) async {
//     assert(file != null);
//
//
//     final httpClient = getHttpClient();
//
//     // var request = Uri.parse('${AppStrings.BASE_URL}api/v1/chat/user/${globalCountryCode}/${globalPhoneNo}/file');
//     final request = await httpClient.putUrl(Uri.parse('${AppStrings.BASE_URL}api/v1/chat/user/${globalCountryCode}/${globalPhoneNo}/file'));
//
//     int byteCount = 0;
//
//
//     var multipart = await http.MultipartFile.fromPath('picture', file!.path);
//     // var multipartFile = new http.MultipartFile('picture', stream, length,
//     //     filename: basename(imageFile.path));
//     // final fileStreamFile = file.openRead();
//
//     // var multipart = MultipartFile("file", fileStreamFile, file.lengthSync(),
//     //     filename: fileUtil.basename(file.path));
//
//     var requestMultipart = http.MultipartRequest("PUT", Uri.parse("uri"));
//
//     requestMultipart.files.add(multipart);
//
//     var msStream = requestMultipart.finalize();
//
//     var totalByteLength = requestMultipart.contentLength;
//
//     request.contentLength = totalByteLength;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var at =  prefs.getString( "accessToken");
//     var uph =  prefs.getString( "userFingerprintHash");
//     request.headers.add("Authorization",  "Bearer " + at!);
//     request.headers.add("userFingerprintHash",  uph!);
//     request.headers.add("appcode",  "100000");
//     request.headers.add("licensekey",  "33783ui7-hepf-3698-tbk9-so69eq185173");
//     // var at =  prefs.getString( "accessToken");
//     // var uph =  prefs.getString( "userFingerprintHash");
//     // if (at != null) {
//     //   request.headers["Authorization"] = "Bearer " + at;
//     //   request.headers["userFingerprintHash"] = uph!;
//     //   request.headers["appcode"] = "100000";
//     //   request.headers["licensekey"] = "33783ui7-hepf-3698-tbk9-so69eq185173";
//     // }
//     total = totalByteLength;
//
//     Stream<List<int>> streamUpload = msStream.transform(
//       new StreamTransformer.fromHandlers(
//         handleData: (data, sink) {
//           sink.add(data);
//           byteCount += data.length;
//           print(byteCount);
//           print("${received ~/ 1024}/${total ~/ 1024} KB");
//           print(received/total *100);
//           received += data.length;
//           loadertext="${received ~/ 1024}/${total ~/ 1024} KB";
//         },
//         handleError: (error, stack, sink) {
//           throw error;
//         },
//         handleDone: (sink) {
//
//           sink.close();
//           // UPLOAD DONE;
//         },
//       ),
//     );
//
//
//     await request.addStream(streamUpload);
//
//     final httpResponse = await request.close();
// //
//     var statusCode = httpResponse.statusCode;
//
//     if (statusCode ~/ 100 != 2) {
//       throw Exception('Error uploading file, Status code: ${httpResponse.statusCode}');
//     } else {
//       return await readResponseAsString(httpResponse);
//     }
//   }

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
        var result = await  Navigator.push(context, MaterialPageRoute(builder: (context){
          return PictureView( file:File(file.path),);
        }));
        if(result != null){
          _image=result;
          setState(() {
            // Here you can write your code for open new view
          });

          if (_image != null) {

            imageFile = File(_image!.path);
            if (imageFile != null) {
              setState(() {
                loadertext="Uploading";
                isLoading = true;
              });
              // String los = await fileuploadchat(filePath: _image.path);
              String los = await fileimageupload(filePath: _image!.path);
              // String los1 = await fileUploadMultipart(file: _image!);
              if (los != '') {
                _handleSubmitted(los);
              } else {}
              setState(() {
                loadertext="Loading";
                isLoading = false;
              });
            }
          }

        }
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

    getdata();
    focusNode.addListener(onFocusChange);
    isShowSticker = false;
    dio=Dio();

    setCurrentChatRoomID(widget.chatID);
    FirebaseController.instanace.getUnreadMSGCount();
    _chatListController.addListener(_scrollListener);
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
    setState(() {});
  }
  Future<bool> requestPhotosPermission() async {
    return _requestPermission(Permission.photos);
  }
  Future<bool> _requestPermission(Permission permission) async {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  requestWritePermission() async {
    if (Platform.isAndroid) {
      if (await requestPhotosPermission() == true) {
        setState(() {
          _allowWriteFile = true;
        });
      }
    } else {
      setState(() {
        _allowWriteFile = true;
      });
    }






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

                isDelete?Container(
                  width: 35,
                  height: 35,
                  margin: EdgeInsets.only(right: 10),
                  child: RawMaterialButton(
                    // fillColor: Colors.white,
                    // shape: CircleBorder(),
                    padding: EdgeInsets.all(5),
                    onPressed: () async {
                      CoolAlert.show(
                          context: context,
                          type: CoolAlertType.confirm,
                          text: "Do you want to Delete This Chat?",
                          title: "Delete Chat",
                          onConfirmBtnTap: () async{

                            print(widget.chatID);
                            setState(() {
                              isLoading = true;
                            });
                            FirebaseFirestore.instance.collection('users').doc(globalPhoneNo).collection('chatlist').doc(widget.chatID).delete();
                            FirebaseFirestore.instance.collection('chatroom').doc(widget.chatID).collection(widget.chatID).get().then((snapshot) {
                              for (DocumentSnapshot ds in snapshot.docs) {
                                ds.reference.delete();
                              }
                            });
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            // FirebaseFirestore.instance
                            //     .collection('chatroom')
                            //     .doc(widget.chatID)
                            //     .delete().then((dtat) {
                            //   Navigator.of(context).pop();
                            //   Navigator.of(context).pop();
                            //   // Navigator.pop(context, "delete");
                            // });

                          }
                      );

                    },
                    child: Icon(Icons.delete,color: Colors.white,),
                  ),
                ):Container()
                // createEditProfileModel == null
                //     ? Container()
                //     : Padding(
                //         padding: EdgeInsets.only(right: 8, top: 6, bottom: 6),
                //         child: createEditProfileModel!.universityLogo! == "" ||
                //                 createEditProfileModel!.universityLogo! == null
                //             ? Container()
                //             : Image.network(
                //                 createEditProfileModel!.universityLogo!,
                //                 width: 55,
                //                 height: 40,
                //               ),
                //       ),
              ],
              backgroundColor: AppColors.APP_LIGHT_BLUE_20,

              iconTheme: IconThemeData(color: Colors.white),
              title: GestureDetector(
                onTap: () {},
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
                            imgUrl: widget.selectedUserThumbnail,
                          ),
                    SizedBox(width: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width-210,

                          child: Text(
                            widget.selectedUserName,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Colors.white, fontSize: 20),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        // Text(
                        //   "Online",
                        //   style: Theme.of(context).textTheme.subtitle1.apply(
                        //         color: Colors.green,
                        //       ),
                        // )
                      ],
                    )
                  ],
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
            body: isLoading?Center(child:  Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                new Text("    ${loadertext}"),
              ],
            ),):VisibilityDetector(
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
                      for (var data in snapshot.data!.docs) {
                        isDelete=true;
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
                                    snapshot.data!.docs[index]['idFrom'] ==
                                            widget.selectedUserID
                                        ? _listItemOther(
                                            context,
                                            widget.selectedUserName,
                                            widget.selectedUserThumbnail,
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
                              //     children: snapshot.data!.documents.map((data) {
                              //
                              //
                              //       //snapshot.data!.documents.reversed.map((data) {
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

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: () {},
                color: Colors.blueGrey,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.face),
                onPressed: () {
                  setState(() {
                    isShowSticker = !isShowSticker;
                  });
                },
                color: Colors.blueGrey,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                onTap: (){
                  setState(() {
                    isShowSticker = !isShowSticker;
                  });
                  },
                style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.blueGrey),
                ),
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () {},
                color: Colors.blueGrey,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(
              top: new BorderSide(color: Colors.blueGrey, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildSticker() {
   return Expanded(
     child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          _msgTextController
            ..text += emoji.emoji
            ..selection = TextSelection.fromPosition(
                TextPosition(offset: _msgTextController.text.length));
          setState(() {
          });// Do something when emoji is tapped
        },
        onBackspacePressed: () {
          _msgTextController
            ..text = _msgTextController.text.characters.skipLast(1).toString()
            ..selection = TextSelection.fromPosition(
                TextPosition(offset: _msgTextController.text.length));
          setState(() {
          });
          // Backspace-Button tapped logic
          // Remove this line to also remove the button in the UI
        },
        config: Config(
          columns: 7,
          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
          verticalSpacing: 0,
          horizontalSpacing: 0,
          gridPadding: EdgeInsets.zero,
          initCategory: Category.RECENT,
          bgColor: Color(0xFFF2F2F2),
          indicatorColor: Colors.blue,
          iconColor: Colors.grey,
          iconColorSelected: Colors.blue,
          progressIndicatorColor: Colors.blue,
          backspaceColor: Colors.blue,
          skinToneDialogBgColor: Colors.white,
          skinToneIndicatorColor: Colors.grey,
          enableSkinTones: true,
          showRecentsTab: true,
          recentsLimit: 28,
          noRecents: const Text(
            'No Recents',
            style: TextStyle(fontSize: 20, color: Colors.black26),
            textAlign: TextAlign.center,
          ),
          tabIndicatorAnimDuration: kTabScrollDuration,
          categoryIcons: const CategoryIcons(),
          buttonMode: ButtonMode.MATERIAL,
        ),
      ),
   );
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
                      child: CachedNetworkImage(
                        imageUrl: thumbnail,
                        placeholder: (context, url) => Container(
                          transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                          child: Container(
                              width: 60,
                              height: 60,
                              child: Center(
                                  child: new CircularProgressIndicator())),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        width: 50,
                        height: 50,
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
                                      :  type == 'Sticker'
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
                                      :type == 'pdf'
                                      ? Container(
                                    width: 90,
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              getDirectoryPath().then((path) {
                                                String extension=message.substring(message.lastIndexOf("/"));
                                                File f=File(path+"$extension");
                                                if(f.existsSync())
                                                {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                                    return PDFScreen(f.path);
                                                  }));
                                                  return;
                                                }
                                                downloadFile(message,"$path/$extension",extension);
                                              });
                                            },
                                            child: Image.asset(
                                              'images/pdficon.png',
                                              width: 40.0,
                                              height: 40.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        // IconButton(
                                        //   icon: Icon(Icons.remove_red_eye),
                                        //   onPressed: () {
                                        //
                                        //     getDirectoryPath().then((path) {
                                        //       String extension=message.substring(message.lastIndexOf("/"));
                                        //
                                        //       File f=File(path+"$extension");
                                        //       if(f.existsSync())
                                        //       {
                                        //         Navigator.push(context, MaterialPageRoute(builder: (context){
                                        //           return PDFScreen(f.path);
                                        //         }));
                                        //         return;
                                        //       }
                                        //       downloadFile(message,"$path/$extension",extension);
                                        //     });
                                        //
                                        //   },
                                        // ),
                                      ],
                                    ),
                                  )
                                      : type == 'mp4'
                                      ? Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                    ),
                                    child: GestureDetector(
                                      onTap: () async{
                                        getDirectoryPath().then((path) async {
                                          String extension=message.substring(message.lastIndexOf("/"));

                                          File f=File(path+"$extension");
                                          if(f.existsSync())
                                          {
                                            var _openResult = 'Unknown';
                                            final result = await OpenFile.open(f.path);
                                            setState(() {
                                              _openResult = "type=${result}  message=${result}";
                                            });
                                            return;
                                          }
                                          downloadFile(message,"$path/$extension",extension);
                                        });


                                      },
                                      child: Image.asset(
                                        'images/playpng.png',
                                        width: 100.0,
                                        height: 100.0,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ):
                                  type=="image"?_imageMessage(message):
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius
                                          .circular(10.0),
                                    ),
                                    child: GestureDetector(
                                      onTap: () async{
                                        getDirectoryPath().then((path) async {
                                          print(message.toString());
                                          String extension=message.substring(message.lastIndexOf("/"));

                                          File f=File(path+"$extension");
                                          if(f.existsSync())
                                          {
                                            var _openResult = 'Unknown';

                                            final result = await OpenFile.open(f.path);


                                            setState(() {
                                              _openResult = "type=${result}  message=${result}";
                                            });
                                            print(_openResult);
                                            Fluttertoast.showToast(msg: result.message);
                                            return;
                                          }
                                          downloadFile(message,"$path/$extension",extension);
                                        });


                                      },
                                      child: Image.asset(
                                        'images/file.png',
                                        width: 60.0,
                                        height: 60.0,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )),
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
                                : type == 'pdf'
                                    ? Container(
                                        width: 90,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  getDirectoryPath().then((path) {
                                                    String extension=message.substring(message.lastIndexOf("/"));
                                                    File f=File(path+"$extension");
                                                    if(f.existsSync())
                                                    {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context){
                                                        return PDFScreen(f.path);
                                                      }));
                                                      return;
                                                    }
                                                    downloadFile(message,"$path/$extension",extension);
                                                  });
                                                },
                                                child: Image.asset(
                                                  'images/pdficon.png',
                                                  width: 40.0,
                                                  height: 40.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            // IconButton(
                                            //   icon: Icon(Icons.remove_red_eye),
                                            //   onPressed: () {
                                            //
                                            //     getDirectoryPath().then((path) {
                                            //       String extension=message.substring(message.lastIndexOf("/"));
                                            //
                                            //       File f=File(path+"$extension");
                                            //       if(f.existsSync())
                                            //       {
                                            //         Navigator.push(context, MaterialPageRoute(builder: (context){
                                            //           return PDFScreen(f.path);
                                            //         }));
                                            //         return;
                                            //       }
                                            //       downloadFile(message,"$path/$extension",extension);
                                            //     });
                                            //
                                            //   },
                                            // ),
                                          ],
                                        ),
                                      )
                                    : type == 'mp4'
                                        ? Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: GestureDetector(
                                              onTap: () async{
                                                getDirectoryPath().then((path) async {
                                                  String extension=message.substring(message.lastIndexOf("/"));

                                                  File f=File(path+"$extension");
                                                  if(f.existsSync())
                                                  {
                                                    var _openResult = 'Unknown';
                                                    final result = await OpenFile.open(f.path);
                                                    setState(() {
                                                      _openResult = "type=${result}  message=${result}";
                                                    });
                                                    return;
                                                  }
                                                  downloadFile(message,"$path/$extension",extension);
                                                });


                                              },
                                              child: Image.asset(
                                                'images/playpng.png',
                                                width: 100.0,
                                                height: 100.0,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ):
                        type=="image"?_imageMessage(message):
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius
                                .circular(10.0),
                          ),
                          child: GestureDetector(
                            onTap: () async{
                              getDirectoryPath().then((path) async {
                                String extension=message.substring(message.lastIndexOf("/"));

                                File f=File(path+"$extension");
                                if(f.existsSync())
                                {
                                  var _openResult = 'Unknown';

                                  final result = await OpenFile.open(f.path);


                                  setState(() {
                                    _openResult = "type=${result}  message=${result}";
                                  });
                                  print(_openResult);
                                  Fluttertoast.showToast(msg: result.message);
                                  return;
                                }
                                downloadFile(message,"$path/$extension",extension);
                              });


                            },
                            child: Image.asset(
                              'images/file.png',
                              width: 60.0,
                              height: 60.0,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Future downloadFile(String url,path,ext) async {
    if(!_allowWriteFile!)
    {

      requestWritePermission();
    }
    try{
      ProgressDialog progressDialog=ProgressDialog(context,type: ProgressDialogType.Normal);
      progressDialog.style(message: "Downloading File");
      progressDialog.show();
      await dio!.download(url, path,onReceiveProgress: (rec,total){
        setState(() {
          isLoading=true;
          progress=((rec/total)*100).toStringAsFixed(0)+"%";
          progressDialog.update(message: "Dowloading $progress");
        });


      });
      File f=File(path);

      final result = await OpenFile.open(f.path);

      progressDialog.hide();
      setState(() {
        isLoading=false;
      });


    }catch( e)
    {

      print(e.toString());
    }
  }
  Future<String> getDirectoryPath() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    Directory directory =
        await new Directory(appDocDirectory.path + '/' + 'dir')
            .create(recursive: true);

    return directory.path;
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

      Navigator.pop(context, true);
    }

    return Future.value(false);
  }

  Widget buildInputnew() {
    return Container(
      padding: EdgeInsets.all(8),
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
                        FocusManager.instance.primaryFocus?.unfocus();
                        getSticker();
                      }),
                  SizedBox(width: 20,),
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 0.0),
                  //     child: TextField(
                  //       controller: _msgTextController,
                  //       toolbarOptions: ToolbarOptions(copy: true, cut: true, paste: true),
                  //       keyboardType: TextInputType.text,
                  //       textInputAction: TextInputAction.newline,
                  //       autofocus: false,
                  //       onTap: (){
                  //         setState(() {
                  //           if(isShowSticker){
                  //             isShowSticker=false;
                  //           }
                  //         });
                  //       },
                  //       onChanged: (value) {
                  //         setState(() {
                  //           msgtxt = value;
                  //         });
                  //       },
                  //       decoration: InputDecoration(
                  //           hintText: "Type Something...",
                  //           border: InputBorder.none),
                  //     ),
                  //   ),
                  // ),
                  Flexible(
                    child: new ConstrainedBox(
                      constraints: new BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                        maxWidth: MediaQuery.of(context).size.width,
                        minHeight: 25.0,
                        maxHeight: 135.0,
                      ),
                      child: new Scrollbar(
                        child: new TextField(
                          cursorColor: AppColors.APP_BLUE,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          onTap: (){
                            setState(() {
                              if(isShowSticker){
                                isShowSticker=false;
                              }
                            });
                          },
                          controller: _msgTextController,
                          // _handleSubmitted : null,
                          onChanged: (value) {
                            setState(() {
                              msgtxt = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                top: 2.0,
                                left: 0.0,
                                right: 0.0,
                                bottom: 2.0),
                            hintText: "Type your message",
                            hintStyle: TextStyle(
                              color:Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.photo_camera),
                    onPressed: () {
                      setState(() {
                        _image=null;
                        messageType = 'image';
                        _isLoading = true;
                      });
                      getImage();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: () async {
                      try {
                        setState(() {
                          isLoading = true;
                          loadertext="Loading media";
                        });
                        FilePickerResult? path = await FilePicker.platform.pickFiles(
                            type: FileType.any,
                            allowedExtensions: extensions);

                        PlatformFile file = path!.files.first;
                        setState(() {
                          isLoading = false;
                          loadertext="Loading";
                        });
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text('Send ${file.name} to ${widget.selectedUserName} ?'),
                                actions: [
                                  FlatButton(
                                    child: Text("CANCEL",style: TextStyle(color: AppColors.APP_BLUE)),
                                    onPressed:  () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("SEND",style: TextStyle(color: AppColors.APP_BLUE),),
                                    onPressed:  () async{
                                      Navigator.of(context).pop();
                                      setState(() {
                                        messageType = file.extension!;
                                        loadertext="Uploading";
                                        isLoading = true;
                                      });
                                      String los = await fileimageupload(filePath:file.path! );
                                      // String los1 = await fileUploadMultipart(file: File(file.path!));

                                      if (los != '') {
                                        _handleSubmitted(los);
                                      } else {}
                                      setState(() {
                                        loadertext="Loading";
                                        isLoading = false;
                                      });

                                    },
                                  )
                                ],
                              );
                            });
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        print(e.toString());
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                color: _msgTextController.text.trim().length != 0 ? Colors.green : Colors.grey,
                shape: BoxShape.circle),
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
  static HttpClient getHttpClient() {
    HttpClient httpClient = new HttpClient()
      ..connectionTimeout = const Duration(seconds: 10)
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    return httpClient;
  }


  _makePostRequest(String msg, String id) async {
    String userImage = createEditProfileModel!.profilePicture.toString();
    String peerId = widget.selectedUserID;
    String username = createEditProfileModel!.firstName!;
    String countrycode = widget.countrycode;
    username = username.replaceAll(RegExp(' +'), ' ');

    // set up POST request arguments

    String url =
        '${AppStrings.BASE_URL}api/v1/chat/notification/$globalCountryCode/$globalPhoneNo/resource/$countrycode/$peerId';
    Map<String, String> headers = {"Content-type": "application/json"};
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    String json =
        '{"message":"$msg","id":"$id","peerurl":"$userImage","timezone":"$time","peerid":"$globalPhoneNo","peername":"$username","peercode":"$countrycode"}';
    // make POST request
    var response = await client.post(Uri.parse(url), headers: headers, body: json);
    print(response.body.toString());
    print(response.statusCode.toString());
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

  Future<void> _handleSubmitted(String text) async {
    text=text.trim();
    _msgTextController.clear();
    msgtxt = "";
    try {
      setState(() {
        _isLoading = true;
      });
      var stamp = DateTime.now().millisecondsSinceEpoch;

      await FirebaseController.instanace.sendMessageToChatRoom(
          widget.chatID,
          widget.myID,
          widget.selectedUserID,
          text,
          messageType,
          createEditProfileModel,stamp);
      String cot = '';
      if (messageType == "text") {
        cot = text;
      } else if (messageType == "image") {
        cot = "picture";
      }else if (messageType == "mp4") {
        cot = "Video";
      }else {
        cot = 'Document';
      }
      _makePostRequest(cot, widget.chatID);

      await FirebaseController.instanace.updateChatRequestField(
          widget.selectedUserID,
          cot,
          widget.chatID,
          widget.myID,
          widget.selectedUserID);
      await FirebaseController.instanace.updateChatRequestField(
          widget.myID,
          cot,
          widget.chatID,
          widget.myID,
          widget.selectedUserID);
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
    _msgTextController.text = '';
    setState(() {
      _isLoading = false;
    });
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

  // Widget buildSticker() {
  //   return Container(
  //     child: Column(
  //       children: <Widget>[
  //         Row(
  //           children: <Widget>[
  //             FlatButton(
  //               onPressed: () {
  //                 onSendMessage('funny4', 2);
  //               },
  //               child: Image.asset(
  //                 'assets/images/sticker/funny4.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('funny5', 2),
  //               child: Image.asset(
  //                 'assets/images/sticker/funny5.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('funny6', 2),
  //               child: Image.asset(
  //                 'assets/images/sticker/funny6.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //           ],
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         ),
  //         Row(
  //           children: <Widget>[
  //             FlatButton(
  //               onPressed: () => onSendMessage('kitty', 2),
  //               child: Image.asset(
  //                 'assets/images/sticker/kitty.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('funny', 2),
  //               child: Image.asset(
  //                 'assets/images/sticker/funny.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('funny1', 2),
  //               child: Image.asset(
  //                 'assets/images/sticker/funny1.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //           ],
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         ),
  //         Row(
  //           children: <Widget>[
  //             FlatButton(
  //               onPressed: () => onSendMessage('tenor', 2),
  //               child: Image.asset(
  //                 'assets/images/sticker/tenor.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('funny2', 2),
  //               child: Image.asset(
  //                 'assets/images/sticker/funny2.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('funny3', 2),
  //               child: Image.asset(
  //                 'assets/images/sticker/funny3.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             )
  //           ],
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         ),
  //         Row(
  //           children: <Widget>[
  //             FlatButton(
  //               onPressed: () => onSendMessage('funny7', 2),
  //               child: Image.asset(
  //                 'assets/images/sticker/funny7.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('funny8', 2),
  //               child: Image.asset(
  //                 'assets/images/sticker/funny8.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('tenor1', 2),
  //               child: Image.asset(
  //                 'assets/images/sticker/tenor1.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             )
  //           ],
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         )
  //       ],
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     ),
  //     decoration: BoxDecoration(
  //         border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
  //         color: Colors.white),
  //     padding: EdgeInsets.all(3.0),
  //     height: 280.0,
  //   );
  // }

  void onSendMessage(String s, int i) {
    setState(() {
      messageType = 'Sticker';
    });
    _handleSubmitted(s);
  }

  static readResponseAsString(HttpClientResponse httpResponse) {
    print(httpResponse.statusCode);
    print(httpResponse.transform(utf8.decoder).listen((value) {
      print(value);

    }));
    print("FROMUpload");
  }
}

class DataModel {
  String date;
  bool view;

  DataModel(this.date, this.view);
}
