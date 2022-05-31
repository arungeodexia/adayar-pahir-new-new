import 'dart:io';

import 'package:ACI/utils/values/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:ACI/utils/values/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: AppStyles.lightTheme(context),
      home: SplashView(),
    );
  }
}

class SplashView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashState();
}

class SplashState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  var _iconAnimationController;
  var _iconAnimation;

  //final Firestore _db = Firestore.instance;

  @override
  void initState() {
    super.initState();

   // try{
   //   _iconAnimationController = AnimationController(duration: Duration(milliseconds: 100),vsync: this);
   //   _iconAnimation = CurvedAnimation(parent: _iconAnimationController,curve: Curves.fastOutSlowIn);
   //   _iconAnimation.addListener(() => this.setState(() {}));
   //   _iconAnimationController.forward();
   // }catch(_){
   //
   // }




   /* _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );*/

  }

  @override
  Widget build(BuildContext context) {
    globalcontext = context;
    return Scaffold(
    backgroundColor: AppColors.APP_BLUE,
    body: Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
               //image: AssetImage("images/ishare_logo_transparent.png"),
                image: tr('appname').toString()=='ACI'?AssetImage("images/pahir_logo_transparent.png"):AssetImage("images/pahir_logo_transparent.png"),
                // width: _iconAnimation.value * 180,
                // height: _iconAnimation.value * 180,
              ),
              SizedBox(height: 10,),
              Text(AppStrings.APP_NAME,style: TextStyle(fontSize: 18, color: Colors.white),),
              SizedBox(height: 20,),
              // Padding(
              //   padding: const EdgeInsets.all(30.0),
              //   child: Text("STAY SAFE!",style: TextStyle(fontSize: 14, color: Colors.white),          textAlign: TextAlign.center,),
              // )
            ],
          ),
        ),
        // Positioned(
        //   bottom: 10.0,
        //   right: 0.0,
        //   left: 0.0,
        //   child:  Text(
        //     'Powered by pahir ®',
        //     style: TextStyle(
        //         color: Colors.white,
        //         fontStyle: FontStyle.normal,
        //         fontSize: 18),
        //     textAlign: TextAlign.center,
        //   ),
        // )
      ],
    ),
    );
  }




  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(FCM_KEY, token);
  }
}
