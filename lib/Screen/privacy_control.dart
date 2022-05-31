import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ACI/Model/PrivacyModel.dart';
import 'package:ACI/Model/create_edit_profile_model.dart';
import 'package:ACI/data/api/repository/ResourceRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Privacy_Control extends StatefulWidget {
  final String name;

  Privacy_Control({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  privacycontrolstate createState() => privacycontrolstate();
}

class privacycontrolstate extends State<Privacy_Control> {
  static final ResourceRepo resourceRepository = new ResourceRepo();
  bool _isImageAvailable = false;

  bool isFullNameChangeBtnState = false;

  String username="", userImage="";
  late SharedPreferences prefs;
  late CreateEditProfileModel createEditProfileModel;
  bool isload = false;

  bool phonecallval = false;
  bool smsval = false;
  bool emailval = false;
  bool clartiechatval = false;
  bool whatsappval = false;
  bool classval = false;
  bool groupval = false;

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  void getdata() async {
    setState(() {
      isload = true;
    });
    PrivacyModel privacyModel =
    await resourceRepository.getprivacy(createEditProfileModel);
    setState(() {
      isload = false;
    });

    if (privacyModel != null) {
      phonecallval = privacyModel.allowCall!;
      smsval = privacyModel.allowSms!;
      emailval = privacyModel.allowEmail!;
      whatsappval = privacyModel.allowWhatsapp!;
      clartiechatval = privacyModel.allowChat!;
      classval = privacyModel.allowClass!;
      groupval = privacyModel.allowGroup!;
      setState(() {});
    }
  }

  void fetchdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final resourceDetailsResponse = await json
        .decode(prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString());
    createEditProfileModel =
        CreateEditProfileModel.fromJson(resourceDetailsResponse);
    getdata();

    setState(() {
      username = resourceDetailsResponse['firstName'];
      print(resourceDetailsResponse['profilePicture']);
      userImage = resourceDetailsResponse['profilePicture'];
      if (userImage == "null") {
      } else {
        if (!userImage.contains("https")) {
          userImage = "https://d1rtv5ttcyt7b.cloudfront.net/" + userImage;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    globalcontext = context;
    return Scaffold(
        backgroundColor: AppColors.APP_LIGHT_GREY_10,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true, // this is all you need
          title: Text(tr("setpri")),
          actions: [
            // createEditProfileModel == null
            //     ? Container()
            //     : Padding(
            //   padding: EdgeInsets.only(right: 8, top: 6, bottom: 6),
            //   child: createEditProfileModel.universityLogo == "" ||
            //       createEditProfileModel.universityLogo == null
            //       ? Container()
            //       : Image.network(
            //     createEditProfileModel.universityLogo,
            //     width: 55,
            //     height: 40,
            //   ),
            // ),
          ],
        ),
        body: isload ? buildLoading() : showForm());
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




  Widget showForm() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 80,
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    top: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        userImage == "null" || userImage == ""
                            ? new CircleAvatar(
                            radius: 25.0,
                            backgroundColor: const Color(0xFF778899),
                            backgroundImage:
                            AssetImage("images/photo_avatar.png"))
                            : new CircleAvatar(
                            radius: 25.0,
                            backgroundColor: const Color(0xFF778899),
                            backgroundImage: ((userImage.toString() != "" ||
                                userImage.toString() != "null")
                                ? NetworkImage(userImage.toString())
                                : AssetImage("images/photo_avatar.png") as ImageProvider)),
                        SizedBox(width: 10),
                        new Expanded(
                            child: Text(username == null ? "" : username.trim(),
                                style: TextStyle(
                                    color: AppColors.APP_BLACK,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans',
                                    fontSize: 20))),
                      ]),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      "Take full control on how your network of contacts can reach you",
                      style: TextStyle(
                          color: AppColors.APP_BLACK,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'OpenSans',
                          fontSize: 16)),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      'images/icon_call_new1.png',
                    ),
                  ),
                  title: Text("Phone Calls",
                      style: TextStyle(
                          color: AppColors.APP_BLACK,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'OpenSans',
                          fontSize: 15)),
                  trailing: Switch(
                    activeColor: AppColors.APP_BLUE,
                    value: phonecallval,
                    onChanged: (value) {
                      print("VALUE : $value");

                      setState(() {
                        isFullNameChangeBtnState = true;
                        phonecallval = value;
                        if(value){

                        }else{
                          whatsappval = value;
                          smsval = value;
                        }
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      'images/icon_sms_new.png',
                    ),
                  ),
                  title: Text("SMS ",
                      style: TextStyle(
                          color: AppColors.APP_BLACK,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'OpenSans',
                          fontSize: 15)),
                  trailing: Switch(
                    activeColor: AppColors.APP_BLUE,
                    value: smsval,
                    onChanged: (value) {
                      print("VALUE : $value");
                      setState(() {
                       if(phonecallval){
                         isFullNameChangeBtnState = true;
                         smsval = value;
                       }else{
                         Fluttertoast.showToast(msg: "Turn on Phone calls to access SMS");
                       }
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      'images/icon_mail_new.png',
                    ),
                  ),
                  title: Text("Email ",
                      style: TextStyle(
                          color: AppColors.APP_BLACK,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'OpenSans',
                          fontSize: 15)),
                  trailing: Switch(
                    activeColor: AppColors.APP_BLUE,
                    value: emailval,
                    onChanged: (value) {
                      print("VALUE : $value");
                      setState(() {
                        emailval = value;
                        isFullNameChangeBtnState = true;
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(
                      'images/ishare_logo.png',
                    ),
                  ),
                  title: Text("ACI Chat ",
                      style: TextStyle(
                          color: AppColors.APP_BLACK,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'OpenSans',
                          fontSize: 15)),
                  trailing: Switch(
                    activeColor: AppColors.APP_BLUE,
                    value: clartiechatval,
                    onChanged: (value) {
                      print("VALUE : $value");
                      setState(() {
                        clartiechatval = value;
                        isFullNameChangeBtnState = true;
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      'images/icon_whatsapp_new1.png',
                    ),
                  ),
                  title: Text("Whatsapp",
                      style: TextStyle(
                          color: AppColors.APP_BLACK,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'OpenSans',
                          fontSize: 15)),
                  trailing: Switch(
                    activeColor: AppColors.APP_BLUE,
                    value: whatsappval,
                    onChanged: (value) {
                      print("VALUE : $value");
                      setState(() {
                        if(phonecallval){
                          whatsappval = value;
                          isFullNameChangeBtnState = true;
                        }else{
                          Fluttertoast.showToast(msg: "Turn on Phone calls to access Whatsapp");
                        }

                      });
                    },
                  ),
                ),
                // ListTile(
                //   leading: CircleAvatar(
                //     child: Icon(Icons.view_compact)
                //   ),
                //   title: Text("Class",
                //       style: TextStyle(
                //           color: AppColors.APP_BLACK,
                //           fontWeight: FontWeight.w700,
                //           fontFamily: 'OpenSans',
                //           fontSize: 15)),
                //   trailing: Switch(
                //     activeColor: AppColors.APP_BLUE,
                //     value: classval,
                //     onChanged: (value) {
                //       print("VALUE : $value");
                //       setState(() {
                //         classval = value;
                //         isFullNameChangeBtnState = true;
                //       });
                //     },
                //   ),
                // ),
                // ListTile(
                //   leading: CircleAvatar(
                //       child: Icon(Icons.supervised_user_circle)
                //   ),
                //   title: Text("Groups",
                //       style: TextStyle(
                //           color: AppColors.APP_BLACK,
                //           fontWeight: FontWeight.w700,
                //           fontFamily: 'OpenSans',
                //           fontSize: 15)),
                //   trailing: Switch(
                //     activeColor: AppColors.APP_BLUE,
                //     value: groupval,
                //     onChanged: (value) {
                //       print("VALUE : $value");
                //       setState(() {
                //         groupval = value;
                //         isFullNameChangeBtnState = true;
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: AppColors.APP_WHITE,
                padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
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
                                        side:
                                        BorderSide(color: AppColors.APP_GREEN)),
                                    color: ((isFullNameChangeBtnState))
                                        ? AppColors.APP_BLUE
                                        : AppColors.APP_LIGHT_GREY_20,
                                    textColor: AppColors.APP_WHITE,
                                    padding: EdgeInsets.all(8.0),
                                    onPressed: () async {
                                      if (isFullNameChangeBtnState) {
                                        PrivacyModel privacy = PrivacyModel();
                                        privacy.allowChat = clartiechatval;
                                        privacy.allowWhatsapp = whatsappval;
                                        privacy.allowEmail = emailval;
                                        privacy.allowCall = phonecallval;
                                        privacy.allowSms = smsval;
                                        // privacy.displayPhoneNumber=true;
                                        privacy.allowCalendar = true;
                                        privacy.allowClass = classval;
                                        privacy.allowGroup = groupval;
                                        print(privacy.toJson());
                                        setState(() {
                                          isload = true;
                                        });
                                        PrivacyModel privacymodel =
                                        await resourceRepository.setprivacy(
                                            createEditProfileModel, privacy);
                                        if (privacymodel != null) {
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.success,
                                              text: "Privacy updated successfully",
                                              title: "Success",
                                              loopAnimation: true,
                                              onConfirmBtnTap: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              });

                                        } else {
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.error,
                                              text: "Privacy update failed",
                                              title: "Failure",
                                              loopAnimation: true,
                                              onConfirmBtnTap: () {
                                                Navigator.of(context).pop();
                                              });

                                        }
                                        setState(() {
                                          isload = false;
                                        });
                                      }
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Text(
                                          (widget != null) ? "SAVE" : "SAVE",
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
        ),
      ),
    );
  }
}
