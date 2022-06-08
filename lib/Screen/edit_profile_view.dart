import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ACI/Bloc/Profilepage/profile_bloc.dart';
import 'package:ACI/Model/create_edit_profile_model.dart';
import 'package:ACI/Model/skill_item.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mydashboard.dart';
// import 'package:image_cropper/image_cropper.dart';

class EditProfileView extends StatefulWidget {
final String? edit;

  const EditProfileView({Key? key, this.edit}) : super(key: key);
  @override
  State<StatefulWidget> createState() => EditProfileState();
}

class AppPropertiesBloc {
  StreamController<String> _title = StreamController<String>();

  Stream<String> get titleStream => _title.stream;
  bool _currentBtnState = false;

  updateTitle(String newTitle) {
    _title.sink.add(newTitle);
  }

  dispose() {
    _title.close();
  }
}

class EditProfileState extends State<EditProfileView> {
//Switch new
  bool isChecked = false;

  bool isSkillTypeVisible = false;
  bool isSwitched = false;
  bool isSwitchVisible = false;
  File _image = File("");
  bool _isImageAvailable = false;
  String fileName = "";
  late SharedPreferences prefs;
  String fcm_key = "";
  SkillItemModel skillItemModel = SkillItemModel();
  CreateEditProfileModel profileData = CreateEditProfileModel();

  //bool isResource = false;

  final appBloc = AppPropertiesBloc();
  bool isFullNameChangeBtnState = false,
      isMobileNoChangeBtnState = false,
      isCityChangeBtnState = false,
      isStateChangeBtnState = false,
      isAlterMobChangeBtnState = false,
      isEmailChangeBtnState = false;

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



  var _createProfileKey = GlobalKey<FormState>();

  TextEditingController fullNameInputController = new TextEditingController();
  TextEditingController cityInputController = new TextEditingController();
  TextEditingController stateInputController = new TextEditingController();
  var tempfullName;
  TextEditingController skillInputController = new TextEditingController();
  var tempskill;
  TextEditingController mobileInputController = new TextEditingController();
  var tempmobile;
  TextEditingController alternateMobileInputController =
      new TextEditingController();
  var tempalternateMobile;
  TextEditingController emailInputController = new TextEditingController();

  var tempemail;
  TextEditingController notesInputController = new TextEditingController();
  var tempnotes;
  var emailFocusNode = new FocusNode();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;



  Future<String> getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return "version:${packageInfo.version}";
  }

  _sumbitDataToServer() async {
    String deviceimei = "";
    String appId = "";

    // try {
    //   var imei = await ImeiPlugin.getImei();
    //   var uuid = await ImeiPlugin.getId();

    //   deviceimei = imei.toString();
    //   appId = uuid.toString();
    // } on Exception catch (e) {}

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    CreateEditProfileModel createEditProfileModel =
        new CreateEditProfileModel();
    createEditProfileModel.id = globalUserId;
    createEditProfileModel.firstName =
        fullNameInputController.text.toString().trim();
    createEditProfileModel.lastName = "";
    createEditProfileModel.mobile = '$globalPhoneNo';
    createEditProfileModel.countryCode = '$globalCountryCode';
    createEditProfileModel.alternativeMobile =
        alternateMobileInputController.text.toString().trim();
    createEditProfileModel.email = emailInputController.text.toString().trim();
    createEditProfileModel.notes = notesInputController.text.toString().trim();
    createEditProfileModel.skillTags =
        notesInputController.text.toString().trim();

    createEditProfileModel.profilePicture = profileData.profilePicture;
    createEditProfileModel.city = cityInputController.text.toString().trim();
    createEditProfileModel.state = stateInputController.text.toString().trim();
    createEditProfileModel.accessToken = "";
    createEditProfileModel.appId = appId;
    createEditProfileModel.appName = packageInfo.appName.toString();
    createEditProfileModel.appVersion = packageInfo.version.toString();
    createEditProfileModel.buildNumber = packageInfo.buildNumber.toString();
    createEditProfileModel.osName = kIsWeb?"Web":Platform.operatingSystem.toString().trim();
    createEditProfileModel.osVersion =
    kIsWeb?"Web":Platform.operatingSystemVersion.toString().trim();
    createEditProfileModel.deviceToken = fcm_key; //Fcm key should be added
    createEditProfileModel.imeiNumber = deviceimei;
    createEditProfileModel.userFingerprintHash = "";
    createEditProfileModel.userStatus = "active";

    if (isSkillTypeVisible) {
      if (skillInputController.text != null &&
          skillInputController.text.isNotEmpty)
        createEditProfileModel.skill =
            skillInputController.text.trim().toString();
    } else {
      createEditProfileModel.skill = "";
    }
    BlocProvider.of<ProfileBloc>(context)
        .add(ProfileUpdate(createEditProfileModel,_image.path));
  }
  Future getImage() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Select the image source"),
          actions: <Widget>[
            MaterialButton(
              child: Text("Camera"),
              onPressed: () => Navigator.pop(context, ImageSource.camera),
            ),
            MaterialButton(
              child: Text("Gallery"),
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
            )
          ],
        ));
    try {
      final pickedFile = await _picker.getImage(
        source: imageSource!,
        imageQuality: 100,
      );

      // File? croppedFile = await ImageCropper.cropImage(
      //     sourcePath: pickedFile!.path,
      //     aspectRatioPresets: [
      //       CropAspectRatioPreset.square,
      //       CropAspectRatioPreset.ratio3x2,
      //       CropAspectRatioPreset.original,
      //       CropAspectRatioPreset.ratio4x3,
      //       CropAspectRatioPreset.ratio16x9
      //     ],
      //     androidUiSettings: AndroidUiSettings(
      //         toolbarTitle: 'Cropper',
      //         toolbarColor: Colors.deepOrange,
      //         toolbarWidgetColor: Colors.white,
      //         initAspectRatio: CropAspectRatioPreset.original,
      //         lockAspectRatio: false),
      //     iosUiSettings: IOSUiSettings(
      //       minimumAspectRatio: 1.0,
      //     ));

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _isImageAvailable = true;
        });
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  _fetchProfileData() async {
    prefs = await SharedPreferences.getInstance();
    String profiledata =
    (prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA) ?? "emp");

    final otpVerifyResponse = json.decode(profiledata);

    globalPhoneNo = otpVerifyResponse['mobile'];
    globalCountryCode = otpVerifyResponse['countryCode'];
    globalUserId = otpVerifyResponse['id'];
    mobileInputController.text = "$globalCountryCode $globalPhoneNo";

    initCityNameVal = cityInputController.text;
    initStateVal = stateInputController.text;
    isCityChangeBtnState = false;
    isStateChangeBtnState = false;
    profileData = CreateEditProfileModel();
    skillItemModel = SkillItemModel();
    if (widget.edit=="edit") {
      profileData=CreateEditProfileModel.fromJson(json.decode(profiledata));
      fullNameInputController.text=profileData.firstName.toString();
      emailInputController.text=profileData.email.toString();
      alternateMobileInputController.text=profileData.alternativeMobile.toString();
      notesInputController.text=profileData.notes.toString();
      cityInputController.text=profileData.city.toString();
      stateInputController.text=profileData.state.toString();
      initFullNameVal = fullNameInputController.text;
      initMobileNoVal = mobileInputController.text;
      initAlterMobileVal = alternateMobileInputController.text;
      initEmailVal = emailInputController.text;
      initNotesVal = notesInputController.text;
      initStateVal=stateInputController.text;
      initCityNameVal=stateInputController.text;
    }
  }
  @override
  void initState() {
    _fetchProfileData();
    if (widget.edit=="edit") {
      BlocProvider.of<ProfileBloc>(context)
          .add(Profiledata());
    }
    _firebaseMessaging.getToken().then((token){
      print(token);
      fcm_key=token!;

    });
    WidgetsBinding.instance.addPostFrameCallback((_){

      // Add Your Code here.
      fullNameInputController.addListener(() {
        //print("fullNameInputController value: ${fullNameInputController.text}");
        setState(() {
          if (initFullNameVal != fullNameInputController.text.toString()) {
            isFullNameChangeBtnState = true;
          } else {
            isFullNameChangeBtnState = false;
          }
        });
      });

      cityInputController.addListener(() {
        print("cityInputController value: ${cityInputController.text}");
        setState(() {
          if (initCityNameVal != cityInputController.text.toString()) {
            isCityChangeBtnState = true;
          } else {
            isCityChangeBtnState = false;
          }
        });
      });
      stateInputController.addListener(() {
        // print("stateInputController value: ${stateInputController.text}");
        setState(() {
          if (initStateVal != stateInputController.text.toString()) {
            isStateChangeBtnState = true;
          } else {
            isStateChangeBtnState = false;
          }
        });
      });

      alternateMobileInputController.addListener(() {
        //print("alternateMobileInputController value: ${alternateMobileInputController.text}");
        setState(() {
          if (initAlterMobileVal !=
              alternateMobileInputController.text.toString()) {
            isAlterMobChangeBtnState = true;
          } else {
            isAlterMobChangeBtnState = false;
          }
        });
      });
      emailInputController.addListener(() {
        //print("emailInputController value: ${emailInputController.text}");
        setState(() {
          //  var email = emailInputController.text.trim().toString();
          // bool isValidEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
          //if(isValidEmail){
          if (initEmailVal != emailInputController.text.toString()) {
            isEmailChangeBtnState = true;
          } else {
            isEmailChangeBtnState = false;
          }
        });
      });




    });

  }

  final PageRouteBuilder _dashBoardRoute = new PageRouteBuilder(
    pageBuilder: (BuildContext context, _, __) {
      return Mydashboard();
    },
  );

  void _goDashboard() {
    Navigator.pushAndRemoveUntil(
        context, _dashBoardRoute, (Route<dynamic> r) => false);
  }

  Future<bool> onWillPop() async {
    if (_isImageAvailable ||
        isFullNameChangeBtnState ||
        isMobileNoChangeBtnState ||
        isCityChangeBtnState ||
        isStateChangeBtnState ||
        isAlterMobChangeBtnState ||
        isEmailChangeBtnState ) {
    } else {
      _goDashboard();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    globalcontext = context;
    return new WillPopScope(
        onWillPop: backPressed,
        child: Scaffold(
          appBar: AppBar(
            // title: Text(AppStrings.EDIT_PROFILE_TITLE),

            title: StreamBuilder<Object>(
                stream: appBloc.titleStream,
                initialData: tr("profilesettings"),
                builder: (context, snapshot) {
                  return Text(snapshot.data.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold));
                }),
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
          body: BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is Profileupdatesuccess) {
                CoolAlert.show(
                  context: context,
                  type: CoolAlertType.success,
                  text: tr("prsuccess"),
                  title: tr("success"),
                  confirmBtnText: tr("ok"),
                  loopAnimation: true,
                  onConfirmBtnTap: (){
                    Navigator.of(context).pop();
                    print("tabl");
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Mydashboard()),
                          (Route<dynamic> route) => false,
                    );
                  }
                );
              }else if (state is Profileupdatefailure) {
                CoolAlert.show(
                    context: context,
                    type: CoolAlertType.error,
                    text: tr("prfailure"),
                    title: tr("failure"),
                    confirmBtnText: tr("ok"),
                    loopAnimation: true,
                    onConfirmBtnTap: (){
                      Navigator.of(context).pop();
                    }
                );

              } else if (state is Profiledatasuccess) {
                profileData=state.createEditProfileModel;
                fullNameInputController.text=profileData.firstName.toString();
                emailInputController.text=profileData.email.toString();
                notesInputController.text=profileData.notes.toString();
                cityInputController.text=profileData.city.toString();
                stateInputController.text=profileData.state.toString();
                alternateMobileInputController.text=profileData.alternativeMobile.toString();
                initFullNameVal = fullNameInputController.text.toString();
                initMobileNoVal = mobileInputController.text;
                initAlterMobileVal = alternateMobileInputController.text;
                initEmailVal = emailInputController.text;
                initCityNameVal = cityInputController.text;
                initStateVal = stateInputController.text;
                if (initEmailVal != emailInputController.text.toString()) {
                  isEmailChangeBtnState = true;
                } else {
                  isEmailChangeBtnState = false;
                }
                if (initAlterMobileVal !=
                    alternateMobileInputController.text.toString()) {
                  isAlterMobChangeBtnState = true;
                } else {
                  isAlterMobChangeBtnState = false;
                }
                if (initStateVal != stateInputController.text.toString()) {
                  isStateChangeBtnState = true;
                } else {
                  isStateChangeBtnState = false;
                }
                if (initCityNameVal != cityInputController.text.toString()) {
                  isCityChangeBtnState = true;
                } else {
                  isCityChangeBtnState = false;
                }
                if (initFullNameVal != fullNameInputController.text.toString()) {
                  isFullNameChangeBtnState = true;
                } else {
                  isFullNameChangeBtnState = false;
                }


              }
            },
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return buildLoading();
                } else if (state is ProfileInitial) {
                  return showForm(profileData);
                } else if (state is Profileupdatesuccess) {
                  return showForm(profileData);
                } else if (state is Profileupdatefailure) {
                  return showForm(profileData);
                } else if (state is Profiledatasuccess) {
                  return showForm(profileData);
                }  else {
                  return buildLoading();
                }
              },
            ),
          ),
        ));
  }

  Future<bool> backPressed() async {
    // onWillPop();
    Navigator.of(context).pop();
    return true;
  }

  SingleChildScrollView showForm(CreateEditProfileModel profileData) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Form(
              key: _createProfileKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Image Picker and QR code image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        child: Stack(children: <Widget>[
                          _isImageAvailable
                              ? Padding(
                                  padding:
                                      EdgeInsets.only(right: 20, bottom: 3),
                                  child: CircleAvatar(
                                    backgroundImage: kIsWeb?NetworkImage(_image.path):FileImage(_image) as ImageProvider,
                                    radius: 40.0,
                                    foregroundColor: AppColors.APP_WHITE,
                                    backgroundColor: AppColors.APP_BLACK_10,
                                  ))
                              : Padding(
                                  padding:
                                      EdgeInsets.only(right: 20, bottom: 3),
                                  child: CircleAvatar(
                                    backgroundImage: profileData
                                                .profilePicture ==
                                            null
                                        ? AssetImage("images/photo_avatar.png")
                                            as ImageProvider
                                        : NetworkImage(profileData.profilePicture!),
                                    radius: 40.0,
                                    foregroundColor: AppColors.APP_WHITE,
                                    backgroundColor: AppColors.APP_BLACK_10,
                                  )),
                          Positioned.fill(
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: AppColors.APP_LIGHT_GREY,
                                )),
                          )
                        ]),
                        onTap: getImage,
                      ),

                      // Image.network(
                      //   "${AppStrings.BASE_URL}api/v1/user/${globalCountryCode}/${globalPhoneNo}/qr?size=250",
                      //   width: 100,
                      //   height: 100,
                      // )
                    ],
                  ),

                  //FullName
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            tr("fullname"),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.length == 0) {
                                return ('Please enter name');
                              }
                              return null;
                            },
                            textCapitalization: TextCapitalization.words,
                            controller: fullNameInputController,
                            decoration: InputDecoration(
                                hintText:
                                    AppStrings.CREATE_PROFILE_FULLNAME_HINT,
                                hintStyle: TextStyle(
                                    color: AppColors.APP_LIGHT_GREY_40),
                                border: OutlineInputBorder(),
                                fillColor: AppColors.APP_WHITE,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.APP_LIGHT_BLUE_10)),
                                enabled: true),
                          )
                        ],
                      )),

                  //Skill Switch
                  // Padding(
                  //     padding: EdgeInsets.symmetric(vertical: 2.0),
                  //     child: GestureDetector(
                  //         child: Visibility(
                  //             visible: isSwitchVisible,
                  //             child: Center(
                  //                 child: Row(
                  //               crossAxisAlignment: CrossAxisAlignment.center,
                  //               mainAxisAlignment: MainAxisAlignment.start,
                  //               children: <Widget>[
                  //                 Text(
                  //                   AppStrings
                  //                       .CREATE_PROFILE_PROVIDE_SERVICE_LABEL,
                  //                   textAlign: TextAlign.center,
                  //                 ),
                  //
                  //                 SizedBox(
                  //                   width: 5,
                  //                 ),
                  //                 //Switch New
                  //                 Padding(
                  //                     padding:
                  //                         EdgeInsets.symmetric(vertical: 5.0),
                  //                     child: Visibility(
                  //                         visible: true,
                  //                         child: GestureDetector(
                  //                           onTap: () {
                  //                             setState(() {
                  //                               isSwitched = !isSwitched;
                  //                               //print(isSwitched);
                  //                               isSkillTypeVisible = isSwitched;
                  //
                  //                               if (!isSwitched &&
                  //                                   skillInputController
                  //                                       .text.isNotEmpty) {
                  //                                 //After select skill and off switch logic button color change
                  //                                 isSkillChangeBtnState = false;
                  //                               } else if (isSwitched &&
                  //                                   skillInputController
                  //                                       .text.isNotEmpty) {
                  //                                 isSkillChangeBtnState = true;
                  //                               }
                  //                             });
                  //                           },
                  //                           child: Center(
                  //                             child: CustomSwitchButton(
                  //                               backgroundColor: isSwitched
                  //                                   ? AppColors.APP_BLUE
                  //                                   : AppColors.APP_LIGHT_GREY,
                  //                               unCheckedColor: Colors.white,
                  //                               animationDuration:
                  //                                   Duration(milliseconds: 400),
                  //                               checkedColor: Colors.white,
                  //                               checked: isSwitched,
                  //                             ),
                  //                           ),
                  //                         ))),
                  //
                  //                 //Old type switch so It's Hide or removed
                  //                 GestureDetector(
                  //                   child: Visibility(
                  //                     visible: false,
                  //                     child: Switch(
                  //                       value: isSwitched,
                  //                       onChanged: (value) {
                  //                         setState(() {
                  //                           isSwitched = value;
                  //                          // print(isSwitched);
                  //                           isSkillTypeVisible = isSwitched;
                  //
                  //                           if (!isSwitched &&
                  //                               skillInputController
                  //                                   .text.isNotEmpty) {
                  //                             //After select skill and off switch logic button color change
                  //                             isSkillChangeBtnState = false;
                  //                           } else if (isSwitched &&
                  //                               skillInputController
                  //                                   .text.isNotEmpty) {
                  //                             isSkillChangeBtnState = true;
                  //                           }
                  //                         });
                  //                       },
                  //                       activeTrackColor: Colors.lightBlue,
                  //                       activeColor: Colors.blue,
                  //                       inactiveTrackColor: Colors.lightBlue,
                  //                       inactiveThumbColor: Colors.blue,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ))))),

                  //Skill type
                  //Mobile Number
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            tr("mobile"),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: mobileInputController,
                            keyboardType: TextInputType.phone,
                            enabled: false,
                            decoration: InputDecoration(
                                hintText: (globalPhoneNo.trim().length > 0)
                                    ? '$globalCountryCode $globalPhoneNo'
                                    : AppStrings
                                        .CREATE_PROFILE_MOBILENUMBER_HINT,
                                hintStyle: TextStyle(
                                    color: AppColors.APP_LIGHT_GREY_40),
                                border: OutlineInputBorder(),
                                fillColor: AppColors.APP_WHITE,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.APP_LIGHT_BLUE_10)),
                                enabled: true),
                          )
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            tr("city"),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: cityInputController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: AppStrings.CREATE_PROFILE_CITY_HINT,
                                hintStyle: TextStyle(
                                    color: AppColors.APP_LIGHT_GREY_10),
                                border: OutlineInputBorder(),
                                fillColor: AppColors.APP_WHITE,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.APP_LIGHT_BLUE_10)),
                                enabled: true),
                          )
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            tr("state"),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: stateInputController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: AppStrings.CREATE_PROFILE_STATE_HINT,
                                hintStyle: TextStyle(
                                    color: AppColors.APP_LIGHT_GREY_10),
                                border: OutlineInputBorder(),
                                fillColor: AppColors.APP_WHITE,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.APP_LIGHT_BLUE_10)),
                                enabled: true),
                          )
                        ],
                      )),
                  //Alternate Number
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            tr("alternatenumber"),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: alternateMobileInputController,
                              keyboardType: const TextInputType.numberWithOptions(
                                  signed: true,
                                  decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                                hintText: AppStrings
                                    .CREATE_PROFILE_ALTERNATE_NUMBER_HINT,
                                hintStyle: TextStyle(
                                    color: AppColors.APP_LIGHT_GREY_40),
                                border: OutlineInputBorder(),
                                fillColor: AppColors.APP_WHITE,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.APP_LIGHT_BLUE_10)),
                                enabled: true),
                          )
                        ],
                      )),
                  //Email
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            tr("email"),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 5,
                          ),

                          TextFormField(
                            validator: (value) {
                              var email = value;
                              bool isValidEmail = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(email!);

                              if (email.isNotEmpty && !isValidEmail) {
                                emailFocusNode.requestFocus();
                                return ('Please enter valid email');
                              }
                              emailFocusNode.unfocus();
                              return null;
                            },
                            controller: emailInputController,
                            focusNode: emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                hintText: AppStrings.CREATE_PROFILE_EMAIL_HINT,
                                hintStyle: TextStyle(
                                    color: AppColors.APP_LIGHT_GREY_40),
                                border: OutlineInputBorder(),
                                fillColor: AppColors.APP_WHITE,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.APP_LIGHT_BLUE_10)),
                                enabled: true),
                          ),
                          // TextField(

                          //   controller: emailInputController,
                          //   keyboardType: TextInputType.emailAddress,
                          //   decoration: InputDecoration(
                          //       hintText: AppStrings.CREATE_PROFILE_EMAIL_HINT,
                          //       hintStyle:
                          //           TextStyle(color: AppColors.APP_LIGHT_GREY_40),
                          //       border: OutlineInputBorder(),
                          //       fillColor: AppColors.APP_WHITE,
                          //       filled: true,
                          //       enabledBorder: OutlineInputBorder(
                          //           borderSide: BorderSide(
                          //               color: AppColors.APP_LIGHT_BLUE_10)),
                          //       enabled: true),
                          // )
                        ],
                      )),
                  //Notes or More Skills
                  // Padding(
                  //     padding: EdgeInsets.symmetric(vertical: 10.0),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: <Widget>[
                  //         Text(
                  //           //  AppStrings.CREATE_PROFILE_NOTES_LABEL,
                  //           AppStrings.MORE_SKILL_LABEL,
                  //           textAlign: TextAlign.left,
                  //         ),
                  //         SizedBox(
                  //           height: 5,
                  //         ),
                  //         TextField(
                  //           controller: notesInputController,
                  //           maxLines: 10,
                  //           minLines: 8,
                  //           textCapitalization: TextCapitalization.sentences,
                  //           decoration: InputDecoration(
                  //               // hintText: AppStrings.CREATE_PROFILE_NOTES_HINT,
                  //               hintText: AppStrings.MORE_SKILL_HINT,
                  //               hintStyle: TextStyle(
                  //                   color: AppColors.APP_LIGHT_GREY_40),
                  //               border: OutlineInputBorder(),
                  //               fillColor: AppColors.APP_WHITE,
                  //               filled: true,
                  //               enabledBorder: OutlineInputBorder(
                  //                   borderSide: BorderSide(
                  //                       color: AppColors.APP_LIGHT_BLUE_10)),
                  //               enabled: true),
                  //         )
                  //       ],
                  //     )),
                ],
              ),
            ),
          ),
          Container(
            color: AppColors.APP_WHITE,
            padding: const EdgeInsets.fromLTRB(8.0, 35.0, 8.0, 35.0),
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
                                side: BorderSide(color: AppColors.APP_GREEN)),
                            color: ((_isImageAvailable ||
                                    isFullNameChangeBtnState ||
                                    isMobileNoChangeBtnState ||
                                    isCityChangeBtnState ||
                                    isStateChangeBtnState ||
                                    isAlterMobChangeBtnState ||
                                    isEmailChangeBtnState))
                                ? AppColors.APP_LIGHT_BLUE
                                : AppColors.APP_LIGHT_GREY_20,
                            textColor: AppColors.APP_WHITE,
                            padding: EdgeInsets.all(8.0),
                            splashColor: Colors.grey,
                            onPressed: () {
                              if (_createProfileKey.currentState!.validate()) {
                                if (_isImageAvailable ||
                                    isFullNameChangeBtnState ||
                                    isMobileNoChangeBtnState ||
                                    isCityChangeBtnState ||
                                    isStateChangeBtnState ||
                                    isAlterMobChangeBtnState ||
                                    isEmailChangeBtnState
                                ) {
                                  // var email = emailInputController.text.trim().toString();
                                  // bool isValidEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
                                  //  if(email.isNotEmpty) {
                                  //   if (isValidEmail) {
                                  //     _sumbitDataToServer();
                                  //   } else {
                                  //     showToastMessage(AppStrings.INVALID_EMAIL_ID);
                                  //   }
                                  //  }else {
                                  //   // showToastMessage(AppStrings.ENTER_EMAIL_ID);
                                  //    _sumbitDataToServer();
                                  // }

                                  _sumbitDataToServer();
                                } else {
                                  print('value not changed');
                                }
                              } else {
                                print('validation error');
                              }
                            },
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  ((_isImageAvailable ||
                                          isFullNameChangeBtnState ||
                                          isMobileNoChangeBtnState ||
                                          isCityChangeBtnState ||
                                          isStateChangeBtnState ||
                                          isAlterMobChangeBtnState ||
                                          isEmailChangeBtnState))
                                      ? tr("submit")
                                      : tr("submit"),
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
        ],
      ),
    );
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: AppColors.APP_BLUE,
        textColor: AppColors.APP_GREEN,
        fontSize: 16.0);
  }

  Container _buildSkillList(BuildContext context,
      Widget _buildResourceList(BuildContext context, Axis direction)) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /* Padding(
              padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 15.0),
              child: TextField(
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    hintText: AppStrings.SEARCH_RESOURCE,
                    border: OutlineInputBorder(),
                    fillColor: AppColors.APP_WHITE,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.APP_LIGHT_BLUE_10)),
                    enabled: true),
              ),
            ),*/
            SizedBox(height: 5),
            Expanded(
              child: OrientationBuilder(
                builder: (context, orientation) => _buildResourceList(
                    context,
                    orientation == Orientation.portrait
                        ? Axis.vertical
                        : Axis.horizontal),
              ),
            )
          ],
        ));
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
  void dispose() {
    super.dispose();
  }

  void getFileImage() async {}
}
