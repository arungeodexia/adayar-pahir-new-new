import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';


class HelpView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HelpState();
}

class HelpState extends State<HelpView>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    globalcontext = context;
    return Container(
      child: Scaffold(
        appBar: AppBar(
            title: Text(tr("help")),
            centerTitle: true,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        backgroundColor: AppColors.APP_LIGHT_BLUE,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Content One
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      tr('p1'),
                      style: TextStyle(
                        color: AppColors.APP_WHITE,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  //
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      tr('a1'),
                      style: TextStyle(
                        color: AppColors.APP_WHITE,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Content One
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      tr('p2'),
                      style: TextStyle(
                          color: AppColors.APP_WHITE,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  //
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      tr('a2'),
                      style: TextStyle(
                        color: AppColors.APP_WHITE,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Content One
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      tr('p3'),
                      style: TextStyle(
                          color: AppColors.APP_WHITE,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  //
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      tr('a3'),
                      style: TextStyle(
                        color: AppColors.APP_WHITE,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Content One
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      tr('p4'),
                      style: TextStyle(
                          color: AppColors.APP_WHITE,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  //
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      tr('a4'),
                      style: TextStyle(
                        color: AppColors.APP_WHITE,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Content One
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      AppStrings.APP_HELP_SUB_TITLE_FIVE,
                      style: TextStyle(
                          color: AppColors.APP_WHITE,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  //
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      AppStrings.APP_HELP_SUB_CONTENT_FIVE,
                      style: TextStyle(
                        color: AppColors.APP_WHITE,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],

              ),
            ),
          ),
        ),
      ),
    );
  }

}
