import 'dart:convert';
import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ACI/Model/OrganizationModel.dart';
import 'package:ACI/Model/add_resource_model.dart';
import 'package:ACI/Screen/search_page.dart';
import 'package:ACI/Screen/zoneview.dart';
import 'package:ACI/data/api/repository/common_repository.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import 'BGVideoPlayerView.dart';

class MyHomePageDMK extends StatefulWidget {
  MyHomePageDMK({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyHomePageDMKState();
}

class _MyHomePageDMKState extends State<MyHomePageDMK> {
  static final ResourceRepository resourceRepository = new ResourceRepository();
  TextEditingController searchEditingController = new TextEditingController();
  String username = "";
  String userImage = "";

  bool isViewVisible = true;
  bool isMyResVisible = false;

  List<String> suggestions = [];

  String currentText = "";

  @override
  void initState() {
    getuserName();
    super.initState();
  }

  String decodeFull() {
    print("decoded decodeFull :==> ");
    String value =
        "%257B%2522orgName%2522%253A%2522The%2BRISE%2BUSA%2522%252C%2522orgLogo%2522%253A%2522https%253A%252F%252Fd1rtv5ttcyt7b.cloudfront.net%252Fapp%252F1596688715903_rise.png%2522%252C%2522contentURI%2522%253A%2522https%253A%252F%252Fd1rtv5ttcyt7b.cloudfront.net%252Flive%252Fimport_export.pdf%2522%252C%2522messageId%2522%253A3%252C%2522messageTitle%2522%253Anull%252C%2522contentTitle%2522%253A%2522This%2Bis%2Ba%2Bimport%2Bexport%2Bdocument%2522%252C%2522messageSent%2522%253A%25222020-09-16T14%253A13%253A55.191%2522%252C%2522message%2522%253Anull%252C%2522contentType%2522%253A%2522pdf%2522%257D";
    // return _Uri._uriDecode(uri, 0, uri.length, utf8, false);
    var decoded = Uri.decodeComponent(value);
    var decoded1 = Uri.decodeComponent(value);
    print("decoded body :==> " + decoded);
    print("decoded1 body :==> " + decoded1);
    //toastMessage("decoded body :==>" + decoded);
    return decoded;
  }

  getuserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String res = prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString();
    var encoded = utf8.encode(res);
    final resourceDetailsResponse = json.decode(utf8.decode(encoded));
    //debugPrint("resourceDetailsResponse:==>" + resourceDetailsResponse.toString());
    setState(() {
      username = resourceDetailsResponse['firstName'];
      globalCurrentUserMobileNo = resourceDetailsResponse['mobile'];
      globalCurrentUserId = resourceDetailsResponse['id'];
      userImage = resourceDetailsResponse['profilePicture'];

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: Column(
  children: [
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
            new CircleAvatar(
                radius: 25.0,
                backgroundColor: const Color(0xFF778899),
                backgroundImage: userImage.toString()!="null"&&userImage != ""
                    ? NetworkImage(userImage.toString())
                    : AssetImage("images/photo_avatar.png") as ImageProvider),

            SizedBox(width: 10),
            new Expanded(
                child: Text(username == null ? "" : username.trim(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)))
          ]),
    ),
    Padding(
      padding: const EdgeInsets.only(
        left: 25,
        top: 10,
        right: 20,
        bottom: 10,
      ),
      child: TextField(
          controller: searchEditingController,
          onSubmitted: (text) {
            globalSearchData = text.trim();
            FocusScope.of(context).requestFocus(new FocusNode());

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchPage()));
            // homeBloc.add(LoadSearchData(text.toString().trim(), 20, 0));

//                    Navigator.pushNamed(
//                        context, AppRoutes.APP_ROUTE_RESOURCE_SEARCH);
//                     _goResourceSearch();
          },
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.blueAccent,
          ),
          decoration: InputDecoration(
              contentPadding:
              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  globalSearchData =
                      searchEditingController.text.toString().trim();
                  FocusScope.of(context).requestFocus(new FocusNode());

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchPage()));
//                          Navigator.pushNamed(
//                              context, AppRoutes.APP_ROUTE_RESOURCE_SEARCH);
//                           _goResourceSearch();
                },
              ),
              hintText: "e.g. Exporters in California",
              border: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.white, width: 32.0),
                  borderRadius: BorderRadius.circular(5.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.white, width: 32.0),
                  borderRadius: BorderRadius.circular(5.0)))),
    ),
    FutureBuilder<OrganizationModel?>(
      future: resourceRepository.getOrganisationData(),
      // async work
      builder: (BuildContext context,
          AsyncSnapshot<OrganizationModel?> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(height:MediaQuery.of(context).size.height-300,child: Center(child: CircularProgressIndicator()));
          default:
            if (snapshot.hasError)
              return Text('Something went wrong');
            else
              print(snapshot.data);
            if (snapshot.data != null) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                  snapshot.data!.organizationCount!,
                  itemBuilder:
                      (BuildContext ctxt, int index) {
                    return Container(
                      height: 60,

                      // color: Colors.grey,
                      child: Card(
                          color: Colors.grey[300],
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          borderOnForeground: true,
                          elevation: 10,
                          margin: EdgeInsets.fromLTRB(
                              0, 0, 0, 0),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        zoneview(
                                          text: snapshot
                                              .data!
                                              .organizations![
                                          index]
                                              .orgName
                                              .toString(),
                                          orgid: snapshot
                                              .data!
                                              .organizations![
                                          index]
                                              .orgId
                                              .toString(),
                                        )),
                              );
                            },
                            contentPadding: EdgeInsets.only(
                                left: 25.0,
                                right: 20.0,
                                top: 2.0,
                                bottom: 5.0),
                            // leading: CircleAvatar(
                            //   backgroundImage:snapshot.data
                            //       .organizations[index]
                            //       .orgPictureLink
                            //       .toString()==null||snapshot.data
                            //       .organizations[index]
                            //       .orgPictureLink
                            //       .toString()==''? NetworkImage(
                            //       snapshot.data
                            //           .organizations[index]
                            //           .orgPictureLink
                            //           .toString()):AssetImage("images/photo_avatar.png"),
                            // ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black45,
                              size: 20,
                            ),
                            title: Text(
                              snapshot
                                  .data!
                                  .organizations![index]
                                  .orgName
                                  .toString(),
                              maxLines: 1,
                              // style:
                              //     TextStyle(backgroundColor: Colors.white),
                            ),
                          )),
                    );
                  });
            } else {
              return Container();
            }
        }
      },
    )
  ],
),    );
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


  Container _buildHomePageData() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 130,
      child: Scaffold(
          body: Column(
            children: [
              Stack(
        // alignment: Alignment.bottomCenter,
        children: [
              Container(
                margin: EdgeInsets.only(bottom: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            new CircleAvatar(
                                radius: 25.0,
                                backgroundColor: const Color(0xFF778899),
                                backgroundImage: ((userImage != "")
                                    ? MemoryImage(base64Decode(userImage))
                                    : AssetImage("images/photo_avatar.png")
                                        as ImageProvider)),
                            SizedBox(width: 10),
                            new Expanded(
                                child: Text(username == null ? "" : username.trim(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 20)))
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 25,
                        top: 10,
                        right: 20,
                        bottom: 10,
                      ),
                      child: SimpleAutoCompleteTextField(
                        decoration: new InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () async {},
                          ),
                          hintText: "Search ",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 32.0),
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        controller: TextEditingController(text: ""),
                        suggestions: suggestions,
                        textChanged: (text) => currentText = text,
                        clearOnSubmit: false,
                        textSubmitted: (text) async {},
                      ),
                    ),

                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),

                          ],
                        )),
                    Column(
                      children: [
                        Expanded(
                            child: Container(
                                padding: const EdgeInsets.only(
                                  left: 25,
                                  top: 7,
                                  right: 15,
                                  bottom: 10,
                                ),
                                child: Container())),
                      ],

                      // second tab bar
                    ),
                  ],
                ),
              ),
        ],
      ),
            ],
          )),
    );
  }
}
