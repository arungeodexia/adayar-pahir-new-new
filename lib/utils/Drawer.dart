import 'dart:convert';
import 'dart:io';

import 'package:ACI/Screen/mydashboard.dart';
import 'package:ACI/utils/constants.dart';
import 'package:ACI/utils/language.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ACI/Model/create_edit_profile_model.dart';
import 'package:ACI/Model/drawer_item.dart';
import 'package:ACI/Screen/Webview.dart';
import 'package:ACI/Screen/contact_sync_view.dart';
import 'package:ACI/Screen/edit_profile_view.dart';
import 'package:ACI/Screen/help_view.dart';
import 'package:ACI/Screen/login_init_view.dart';
import 'package:ACI/Screen/privacy_control.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class IShareAppDrawer extends StatelessWidget {
  int _selectedIndex = 0;

  final userDrawerItems = [
    new DrawerItem(tr("home"), Icons.home, "/mydashboard"),
    new DrawerItem(tr("mypro"), Icons.account_circle, "/updateprofile"),
    /*new DrawerItem("Change Number",
        IconData(59504, fontFamily: 'MaterialIcons'), "/updatemobile"),*/
    // new DrawerItem(tr("setpri"), Icons.settings, "/privacy"),
    new DrawerItem(
        tr("privacysecurity"), Icons.insert_drive_file, "/privacysecurity"),
    new DrawerItem(tr("help"), Icons.help, "/help"),
    new DrawerItem(tr("language"), Icons.translate, "/language"),
    // new DrawerItem(
    //     AppStrings.CONTACT_SYNC_TITLE, Icons.sync, "/contactsyncview"),
  ];

  final socialDrawerItems = [
    // new DrawerItem("Invite a friend", Icons.assignment_ind, "/myresources"),

    // new DrawerItem("Share QR Code",
    //     Icons.scanner, "/qrresourcedetails"),

    // new DrawerItem(AppStrings.CONTACT_SYNC_TITLE,
    //     Icons.sync, "/contactsyncview"),
  ];

  Widget _createUserProfile() {
    return FutureBuilder(
        future: getUserDetail(),
        // The async function we wrote earlier that will be providing the data i.e vers. no
        builder: (BuildContext context,
            AsyncSnapshot<CreateEditProfileModel>? snapshot) {
          if (snapshot!.hasData) {
            return GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditProfileView(
                      edit: "edit",
                    )));
              },
              child: new UserAccountsDrawerHeader(

                  decoration: BoxDecoration(
                      color: AppColors.APP_BLUE,
                      borderRadius: BorderRadius.circular(0.0)),
                  accountName: new Text(
                    snapshot.data!.firstName.toString(),
                    style: new TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: "OpenSans"),
                  ),
                  accountEmail: new Text(
                    snapshot.data!.email.toString(),
                    style: new TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: "OpenSans"),
                  ),
                  currentAccountPicture: Stack(
                    children: [
                      CircleAvatar(
                          radius: 60.0,
                          backgroundColor: AppColors.APP_BLUE,
                          backgroundImage: snapshot.data!.profilePicture == null
                              ? AssetImage("images/photo_avatar.png") as ImageProvider
                              : NetworkImage(snapshot.data!.profilePicture!)),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(radius:13,child: Icon(Icons.edit,color: Colors.white,size: 13,)),
                      )
                    ],
                  )


              ),
            );
          } else {
            return Container();
          }
        });
  }

  _createDrawerItems(BuildContext context, var drawerItems) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < drawerItems.length; i++) {
      DrawerItem d = drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: d.title == "Be a Volunteer"
            ? Image(
                image: AssetImage("images/volunteergrey.jpeg"),
                width: 20,
                height: 20,
              )
            : new Icon(d.icon,color: AppColors.APP_BLUE,),
        // leading:  Image(image:AssetImage("images/photo_avatar.png"),width: 20,height: 20,),
        title: new Text(
          d.title!,
           style: TextStyle(
              fontSize: 17,
              color: AppColors.APP_BLUE,
              fontFamily: "Poppins"
            )
          // style: kSubtitleTextSyule1.copyWith(
          //     fontWeight: FontWeight.w500,
          //     height: 1.5,
          //     color: AppColors.APP_BLUE
          //
          // ),
        ),
        // selected: i == _selectedIndex,
        onTap: () async {
          if (d.route == "Invite a friend")
            shareData();
          else if (d.route == "/privacysecurity") {
            Navigator.pop(context);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => WebViewExample()));
          } else if (d.route == "/updateprofile") {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditProfileView(
                      edit: "edit",
                    )));
          } else if (d.route == "/help") {
            Navigator.pop(context);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HelpView()));
            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => ContactsPage()));

          } else if (d.route == "/privacy") {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Privacy_Control(
                        name: "/privacy",
                      )),
            );
          }else if (d.route == "/mydashboard") {
            Navigator.pop(context);
            if(currentIndex!=0){
              currentIndex=0;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Mydashboard()),
                    (Route<dynamic> route) => false,
              );
            }


          }else if (d.route == "/language") {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Language(from: "0",)),
            );
          } else if (d.title == AppStrings.CONTACT_SYNC_TITLE) {
            Navigator.pop(context);
            try {
              var status = await Permission.contacts.status;
              if (status.isGranted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactSyncView()),
                );
              } else if (status.isDenied) {
                if (await Permission.contacts.request().isGranted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactSyncView()),
                  );
                }
                Map<Permission, PermissionStatus> statuses = await [
                  Permission.contacts,
                ].request();
                print(statuses[Permission.contacts]);
                throw new PlatformException(
                    code: "PERMISSION_DENIED",
                    message: "Access to contact denied",
                    details: null);
              } else {
                openAppSettings();
              }
            } on PlatformException catch (err) {
              openAppSettings();
            } catch (err) {
              // other types of Exceptions
            }
          }else{
            Navigator.pop(context);
          }
        },
      ));
    }
    return drawerOptions;
  }

  void handleToastMsgDialog(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.APP_BLUE,
        textColor: AppColors.APP_GREEN,
        fontSize: 16.0);
  }

  _launchTermsURL() async {
    const url =
        "https://d2c56lckh61bcl.cloudfront.net/live/CovidTermsandConditions.html";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    globalcontext = context;
    return new Drawer(
      child: new Column(
        children: <Widget>[
          //TODO This has to come from the server
          _createUserProfile(),
          new Column(children: _createDrawerItems(context, userDrawerItems)),
          Divider(),
          new Column(children: _createDrawerItems(context, socialDrawerItems)),
          kIsWeb
              ? Column(
                  children: <Widget>[
                    _createFooterItem(
                        icon: Icons.logout,
                        text: 'Logout',
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool(IS_LOGGED_IN, false);
                          await prefs.clear();
                          Navigator.pushAndRemoveUntil(
                              context, _dashBoardRoute, (Route<dynamic> r) => false);
                        })
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
  final PageRouteBuilder _dashBoardRoute = new PageRouteBuilder(
    pageBuilder: (BuildContext context, _, __) {
      return LoginInitView();
    },
  );
  Widget _createFooterItem(
      {IconData? icon, String? text, GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              text!,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: "OpenSans"),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Future<String> getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return "version:${packageInfo.version}";
  }

  Future<CreateEditProfileModel> getUserDetail() async {
    CreateEditProfileModel createEditProfileModel;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString();
    createEditProfileModel = CreateEditProfileModel.fromJson(json.decode(data));
    return createEditProfileModel;
  }

  Future<String> getUserImage64() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_PROFILE_IMAGE_64) ?? "";
  }

  static Future<String?> shareData() async {
    Share.share(
        'Inviting you join the fight against Corona. Install ACI, find vacant beds, oxygen cylinders, plasma, ambulance services, and more. Stay safe, and save lives. Visit https://www.geodexia.com/ACI/ for details.',
        subject: 'ACI!');
  }

  static _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
