import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cool_alert/cool_alert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ACI/Model/ContentModel.dart';
import 'package:ACI/Model/create_edit_profile_model.dart';
import 'package:ACI/data/api/repository/ResourceRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/DropZoneWidget.dart';
import 'package:ACI/utils/DroppedFileWidget.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'CheckBoxInListView.dart';

class Uploadchannel extends StatefulWidget {
  final String orgid;

  Uploadchannel({Key? key, required this.orgid}) : super(key: key);

  @override
  _UploadchannelState createState() => _UploadchannelState();
}

class _UploadchannelState extends State<Uploadchannel> {
  var _createuploadKey = GlobalKey<FormState>();

  File _image = File("");
  File _pickedfile = File("");
  bool _isImageAvailable = false;
  String fileName = "";
  late SharedPreferences prefs;
  CreateEditProfileModel profileData = CreateEditProfileModel();
  ResourceRepo resourceRepo = ResourceRepo();
  String username = "";
  String userImage = "";

  //bool isResource = false;

  bool isFullNameChangeBtnState = false,
      isMobileNoChangeBtnState = false,
      isCityChangeBtnState = false,
      isStateChangeBtnState = false,
      isAlterMobChangeBtnState = false,
      isEmailChangeBtnState = false,
      isNotesChangeBtnState = false,
      isSkillChangeBtnState = false;
  String initFullNameVal = "",
      initMobileNoVal = "",
      initCityNameVal = "",
      initStateVal = "",
      initAlterMobileVal = "",
      initEmailVal = "",
      initNotesVal = "",
      initSkillVal = "";
  PickedFile? _imageFile;
  dynamic _pickImageError;
  bool isVideo = false;
  final ImagePicker _picker = ImagePicker();
  TextEditingController fullNameInputController = new TextEditingController();
  TextEditingController notesInputController = new TextEditingController();
  TextEditingController channelsInputController = new TextEditingController();
  var tempnotes;
  CreateEditProfileModel createEditProfileModel = CreateEditProfileModel();

  String messageType="";
  String contentType="";
  String contentfilename="";
  late PlatformFile platformfile;

  var extensions;
  List<int> channelids=[];

  bool isload=false;
  File_Data_Model? file;



  Future<bool> backPressed() async {
    // onWillPop();
    channelsname.clear();
    Navigator.of(context).pop();
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  void getdata() async {
     prefs = await SharedPreferences.getInstance();
    final resourceDetailsResponse = await json
        .decode(prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString());
    createEditProfileModel =
        CreateEditProfileModel.fromJson(resourceDetailsResponse);
    setState(() {
      username = resourceDetailsResponse['firstName'];
      globalCurrentUserMobileNo = resourceDetailsResponse['mobile'];
      globalCurrentUserId = resourceDetailsResponse['id'];
      userImage = resourceDetailsResponse['profilePicture'];

    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: backPressed,
      child: Scaffold(
          appBar: AppBar(
            title:
                Text("Upload", style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                backPressed();
              },
            ),
          ),
          backgroundColor: AppColors.APP_LIGHT_GREY_10,
          body: isload?Center(child: CircularProgressIndicator()):Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                      child: Form(
                        key: _createuploadKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //Image Picker and QR code image
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //     left: 25,
                            //     top: 20,
                            //     right: 20,
                            //     bottom: 0,
                            //   ),
                            //   child: Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceBetween,
                            //       children: <Widget>[
                            //         new CircleAvatar(
                            //             radius: 25.0,
                            //             backgroundColor: const Color(0xFF778899),
                            //             backgroundImage: userImage !=
                            //                         "null" &&
                            //                 userImage !=
                            //                         ""
                            //                 ? NetworkImage(userImage)
                            //                 : AssetImage(
                            //                         "images/photo_avatar.png")
                            //                     as ImageProvider),
                            //         SizedBox(width: 10),
                            //         new Expanded(
                            //             child: Text(
                            //                 username ==
                            //                         null
                            //                     ? ""
                            //                     : username
                            //                         .toString(),
                            //                 style: TextStyle(
                            //                     fontWeight: FontWeight.bold,
                            //                     fontSize: 20)))
                            //       ]),
                            // ),

                            //FullName
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      AppStrings.TITLE,
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.length == 0) {
                                          return ('Please enter title');
                                        }
                                        return null;
                                      },
                                      textCapitalization:
                                          TextCapitalization.words,
                                      controller: fullNameInputController,
                                      decoration: InputDecoration(
                                          hintText: "Enter Title ",
                                          hintStyle: TextStyle(
                                              color: AppColors.APP_LIGHT_GREY_40),
                                          border: OutlineInputBorder(),
                                          fillColor: AppColors.APP_WHITE,
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors
                                                      .APP_LIGHT_BLUE_10)),
                                          enabled: true),
                                    )
                                  ],
                                )),

                            GestureDetector(
                              onTap: () async {
                                var result = await Navigator.push(context, new MaterialPageRoute(
                                  builder: (BuildContext context) => CheckBoxInListView(orgid: widget.orgid,channelsids: channelids,),
                                  fullscreenDialog: true,)
                                );
                                channelids=result;
                                var text=channelsname.toString().replaceAll("[", "");
                                 text=text.replaceAll("]", "");
                                channelsInputController.text=text;
                                print(result);
                                print(channelsname);
                              },
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        //  AppStrings.CREATE_PROFILE_NOTES_LABEL,
                                        AppStrings.CHANNEL,
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller: channelsInputController,
                                        maxLines: 1,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                            // hintText: AppStrings.CREATE_PROFILE_NOTES_HINT,
                                            hintText: "Select Channel",
                                            hintStyle: TextStyle(
                                                color: AppColors.APP_LIGHT_GREY_40),
                                            border: OutlineInputBorder(),
                                            fillColor: AppColors.APP_WHITE,
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: AppColors
                                                        .APP_LIGHT_BLUE_10)),
                                            enabled: false),
                                      )
                                    ],
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      //  AppStrings.CREATE_PROFILE_NOTES_LABEL,
                                      AppStrings.DESC,
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.length == 0) {
                                          return ('Please enter Description');
                                        }
                                        return null;
                                      },
                                      controller: notesInputController,
                                      maxLines: 10,
                                      minLines: 8,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                          // hintText: AppStrings.CREATE_PROFILE_NOTES_HINT,
                                          hintText: "Enter Description ",
                                          hintStyle: TextStyle(
                                              color: AppColors.APP_LIGHT_GREY_40),
                                          border: OutlineInputBorder(),
                                          fillColor: AppColors.APP_WHITE,
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors
                                                      .APP_LIGHT_BLUE_10)),
                                          enabled: true),
                                    )
                                  ],
                                )),
                            GestureDetector(
                              onTap: () async {

                                  FilePickerResult? path = await FilePicker.platform.pickFiles(
                                      type: FileType.any,
                                      withReadStream: true,
                                      allowedExtensions: extensions);
                                  PlatformFile file = path!.files.first;
                                  print(file.size);
                                  if(kIsWeb){
                                    platformfile =file;
                                    // _image=await createFileFromBytes(file.bytes!);
                                    // _pickedfile=createFileFromBytes(file.bytes!);
                                  }else{
                                    _image=File(file.path!);
                                    _pickedfile=File(file.path!);
                                  }

                                  _isImageAvailable = true;
                                  contentType=file.extension.toString();
                                  contentfilename=file.name.toString();
                                  if (file.extension=="jpg"||file.extension=="jpeg"||file.extension=="png") {
                                    messageType="image";
                                  }else if (file.extension=="mov"||file.extension=="mp4") {
                                    messageType="video";
                                  } else if (file.extension=="pdf") {
                                    messageType="pdf";
                                  }
                                  setState(() {

                                  });


                              },
                              child: Container(
                                height: 120.0,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    topRight: const Radius.circular(10.0),
                                    bottomLeft: const Radius.circular(10.0),
                                    bottomRight: const Radius.circular(10.0),
                                  ),
                                  color: AppColors.APP_WHITE,
                                  shape: BoxShape.rectangle,
                                ),
                                child: Container(
                                  child: messageType==""?Icon(Icons.cloud_upload_outlined,size: 50,):messageType=="image"?Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: kIsWeb?Icon(Icons.image,size: 50,):Container(child: Image.file(_image,fit: BoxFit.cover,),),
                                  ):messageType=="video"?Container(child: Icon(Icons.video_collection_rounded,size: 50,),):Container(child: Image.asset('images/file.png'),),
                                ),
                              ),
                            ),
                    //   Container(
                    //       alignment: Alignment.center,
                    //       padding: EdgeInsets.all(15),
                    //       child: Column(
                    //         children: [
                    //
                    //           Container(
                    //             height: 300,
                    //             child: DropZoneWidget(
                    //               onDroppedFile: (file) => setState(()=> this.file = file) ,
                    //             ),
                    //           ),
                    //           SizedBox(height: 20,),
                    //           DroppedFileWidget(file:file ),
                    //
                    //         ],
                    //       )
                    // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  color: AppColors.APP_WHITE,
                  padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                        child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: RaisedButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(8.0),
                                      side: BorderSide(
                                          color: AppColors.APP_GREEN)),
                                  color: ((_isImageAvailable ||
                                          isFullNameChangeBtnState ||
                                          isNotesChangeBtnState))
                                      ? AppColors.APP_GREEN
                                      : AppColors.APP_LIGHT_GREY_20,
                                  textColor: AppColors.APP_WHITE,
                                  padding: EdgeInsets.all(8.0),
                                  splashColor: Colors.grey,
                                  onPressed: () async {
                                    if (_createuploadKey.currentState!
                                        .validate()) {
                                      if (_isImageAvailable ||
                                          isFullNameChangeBtnState ||
                                          isNotesChangeBtnState) {
                                        if (channelids.length==0) {
                                          Fluttertoast.showToast(msg: "Please Select Channels");
                                        } else {
                                          ContentModel contentmodel =
                                          ContentModel();
                                          contentmodel.contentStatus = "ACTIVE";
                                          contentmodel.contentTitle =
                                              fullNameInputController.text
                                                  .toString();
                                          contentmodel.contentFileType =
                                              contentType;
                                          contentmodel.contentCategory =
                                              messageType;
                                          contentmodel.contentDescription =
                                              notesInputController.text
                                                  .toString();
                                          contentmodel.userName =
                                              username;
                                          contentmodel.contentTitle=contentfilename;
                                          contentmodel.userId =
                                              globalCurrentUserId;
                                          contentmodel.contentVersion = "1.0";
                                          contentmodel.contentUploadDate =
                                              DateTime.now().toIso8601String();
                                          contentmodel.contentUri = "";
                                          contentmodel.contentTag = "";
                                          contentmodel.contentAuthor = "";
                                          contentmodel.contentRank = "3";
                                          contentmodel.orgChannelIds =
                                              channelids;
                                          isload=true;
                                          setState(() {

                                          });

                                          ContentModel? status =
                                          await resourceRepo.uploadchannel(
                                              widget.orgid, contentmodel);
                                          if (status!.contentId != null) {
                                            if (kIsWeb) {

                                              try{
                                                print(platformfile.readStream);
                                                print(platformfile.size);
                                              }catch(e){
                                                print("hjfgdjfgj"+e.toString());
                                              }
                                              int statuscode = await resourceRepo
                                                  .uploadweb(
                                                  platformfile, widget.orgid,
                                                  status.contentId.toString());
                                              if (statuscode == 200) {
                                                isload = false;
                                                setState(() {

                                                });
                                                CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.success,
                                                    text: "Your Content was uploaded successfully!",
                                                    title: "Success",
                                                    loopAnimation: true,
                                                    onConfirmBtnTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                );
                                              } else {
                                                isload = false;
                                                setState(() {

                                                });
                                                CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.error,
                                                    text: "Your Content was not uploaded successfully!",
                                                    title: "Failure",
                                                    loopAnimation: true,
                                                    onConfirmBtnTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                );
                                              }
                                            }else {
                                              int statuscode = await resourceRepo
                                                  .upload(
                                                  _pickedfile, widget.orgid,
                                                  status.contentId.toString());
                                              if (statuscode == 200) {
                                                isload = false;
                                                setState(() {

                                                });
                                                CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.success,
                                                    text: "Your Content was uploaded successfully!",
                                                    title: "Success",
                                                    loopAnimation: true,
                                                    onConfirmBtnTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                );
                                              } else {
                                                isload = false;
                                                setState(() {

                                                });
                                                CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.error,
                                                    text: "Your Content was not uploaded successfully!",
                                                    title: "Failure",
                                                    loopAnimation: true,
                                                    onConfirmBtnTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                );
                                              }
                                            }
                                          }else{
                                            isload=false;
                                            setState(() {

                                            });
                                            CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.error,
                                                text: "Your Content was not uploaded successfully!",
                                                title: "Failure",
                                                loopAnimation: true,
                                                onConfirmBtnTap: (){
                                                  Navigator.of(context).pop();
                                                }
                                            );

                                          }
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Please Select Image");
                                      }
                                    } else {
                                      print('validation error');
                                    }
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      child: Text(
                                        ((_isImageAvailable ||
                                                isFullNameChangeBtnState ||
                                                isMobileNoChangeBtnState ||
                                                isCityChangeBtnState ||
                                                isStateChangeBtnState ||
                                                isAlterMobChangeBtnState ||
                                                isEmailChangeBtnState ||
                                                isNotesChangeBtnState ||
                                                isSkillChangeBtnState))
                                            ? AppStrings
                                                .UPDATE_MOBILE_SUBMIT_BT_LBL
                                            : AppStrings
                                                .UPDATE_MOBILE_SUBMIT_BT_LBL,
                                        //  AppStrings.UPDATE_MOBILE_CONTINUE_BT_LBL,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ))),
                        flex: 1,
                      ),
                    ],
                  )),
                ),
              ),
            ],
          )),
    );
  }
  File createFileFromBytes(Uint8List bytes) => File.fromRawPath(bytes);

  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath + '/file_01.tmp'; // file_01.tmp is dump file, can be anything
    return new File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
  Future<int> uploadSelectedFile(PlatformFile objFile, String contentid) async {
    //---Create http package multipart request object
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("${AppStrings.BASE_URL}api/v1/user/content/$contentid/file"),
    );
    //-----add selected file with request
try{
  request.files.add(new http.MultipartFile(
      "file", objFile.readStream!, objFile.size,
      filename: objFile.name));
}catch(e){

}
    var at = prefs.getString("accessToken");
    var uph = prefs.getString("userFingerprintHash");
    if (at != null) {
      request.headers["Authorization"] = "Bearer " + at;
      request.headers["userFingerprintHash"] = uph!;
      request.headers["appcode"] = "100000";
      request.headers["licensekey"] = "33783ui7-hepf-3698-tbk9-so69eq185173";
    }
    //-------Send request
    var resp = await request.send();

    //------Read response
    String result = await resp.stream.bytesToString();

    //-------Your response
    print(result);
    return resp.statusCode;
  }

}
