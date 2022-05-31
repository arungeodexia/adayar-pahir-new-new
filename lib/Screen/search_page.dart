import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ACI/Bloc/Resorceview/resource_details_view.dart';
import 'package:ACI/Model/ResourceSearchNew.dart';
import 'package:ACI/Screen/BGVideoPlayerView.dart';
import 'package:ACI/data/api/repository/ResourceRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/unreadchat/fullphoto.dart';
import 'package:ACI/utils/PdfViewer.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchEditingController = new TextEditingController();
  String username = "";
  String userImage = "";
  ResourceSearchNew resourceList = ResourceSearchNew();
  ResourceRepo resourceRepo = ResourceRepo();
  late RichText richText;

  bool isloading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserName();
    searchEditingController.text = globalSearchData.toString();
  }

  getuserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String res = prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString();
    // prefs.setBool(IS_LOGGED_IN, false);

    var encoded = utf8.encode(res);
    final resourceDetailsResponse = json.decode(utf8.decode(encoded));
    isloading = true;
    //debugPrint("resourceDetailsResponse:==>" + resourceDetailsResponse.toString());
    setState(() {
      username = resourceDetailsResponse['firstName'];
      globalCurrentUserMobileNo = resourceDetailsResponse['mobile'];
      globalCurrentUserId = resourceDetailsResponse['id'];
      userImage = resourceDetailsResponse['profilePicture'];
      print(userImage);
    });
    resourceList =
        await resourceRepo.getSearchData2(globalSearchData.toString(), 0, 0);
    isloading = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    globalcontext = context;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Search"),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
                            backgroundImage: userImage != ""
                                ? NetworkImage(userImage.toString())
                                : AssetImage("images/photo_avatar.png")
                                    as ImageProvider),
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
                      onSubmitted: (text) async {
                        globalSearchData = text.trim();
                        FocusScope.of(context).requestFocus(new FocusNode());
                        isloading = true;
                        setState(() {});
                        resourceList = await resourceRepo.getSearchData2(
                            globalSearchData.toString(), 0, 0);
                        isloading = false;

                        setState(() {});
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
                            onPressed: () async {
                              globalSearchData = searchEditingController.text
                                  .toString()
                                  .trim();
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              isloading = true;
                              setState(() {});
                              resourceList = await resourceRepo.getSearchData2(
                                  globalSearchData.toString(), 0, 0);
                              isloading = false;

                              setState(() {});
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
                isloading
                    ? buildLoading()
                    : resourceList.searchResults!.length == 0
                        ? showNoResultFound()
                        : Expanded(
                            child: new ListView.builder(
                              shrinkWrap: true,
                              itemCount: resourceList.searchResults!.length,
                              itemBuilder: (context, i) {
                                return Container(
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: AppColors.APP_LIGHT_GREY_PROFILE,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      border: Border.all(
                                          color: Colors.transparent)),
                                  child: new ExpansionTile(
                                    // trailing: Icon(Icons.keyboard_arrow_up),
                                    backgroundColor:
                                        AppColors.APP_LIGHT_GREY_PROFILE,
                                    //initiallyExpanded: true,
                                    initiallyExpanded: (i == 0),
                                    title: Container(
                                        // color: AppColors.APP_LIGHT_GREY_PROFILE,
                                        /*decoration:BoxDecoration(
                      color: AppColors.APP_LIGHT_GREY_PROFILE,
                      borderRadius:BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: Colors.transparent)

                  ),*/

                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              transform:
                                                  Matrix4.translationValues(
                                                      5.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                // mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 0, bottom: 0),
                                                    child: CircleAvatar(
                                                      backgroundImage: ((resourceList
                                                                      .searchResults![
                                                                          i]
                                                                      .icon !=
                                                                  null &&
                                                              resourceList
                                                                      .searchResults![
                                                                          i]
                                                                      .icon !=
                                                                  ""))
                                                          ? NetworkImage(
                                                              resourceList
                                                                  .searchResults![
                                                                      i]
                                                                  .icon!)
                                                          //? AssetImage("images/photo_avatar.png")
                                                          : AssetImage(
                                                                  "images/photo_avatar.png")
                                                              as ImageProvider,
                                                      radius: 22,
                                                      // backgroundColor: resourceItem.color,
                                                      backgroundColor:
                                                          AppColors.APP_BLUE,
                                                      foregroundColor:
                                                          AppColors.APP_WHITE,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              transform:
                                                  Matrix4.translationValues(
                                                      0.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 3,
                                                        bottom: 3,
                                                        left: 5.0),
                                                    child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 10,
                                                          top: 7,
                                                          right: 15,
                                                          bottom: 7,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                                // color: AppColors.APP_LIGHT_GREY_PROFILE,
                                                                color: Colors
                                                                    .transparent,
                                                                borderRadius: BorderRadius.only(
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            16.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            16.0))),
                                                        child: Text(
                                                          resourceList
                                                                  .searchResults![
                                                                      i]
                                                                  .title! +
                                                              " (" +
                                                              resourceList
                                                                  .searchResults![
                                                                      i]
                                                                  .resourceMatchCount
                                                                  .toString() +
                                                              ") ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 13,
                                                              color: AppColors
                                                                  .APP_BLUE),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                    children: <Widget>[
                                      new Column(
                                        children: [
                                          for (final resourceItem
                                              in resourceList.searchResults![i]
                                                  .resourceResults!)
                                            resourceItem.contentDetails != null
                                                ? //Show Contentdetails
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        8.0, 0.0, 8.0, 0.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Scaffold.of(context).showSnackBar(SnackBar(
                                                            backgroundColor:
                                                                Colors.pink,
                                                            duration: Duration(
                                                                microseconds:
                                                                    2000),
                                                            content: Text(
                                                                "Selected Item " +
                                                                    ":==>" +
                                                                    resourceItem
                                                                        .firstName!)));
                                                      },
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 70,
                                                        child: GestureDetector(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    23.0,
                                                                    0.0,
                                                                    23.0,
                                                                    0.0),
                                                            // padding:  const EdgeInsets.all(1.0),

                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .stretch,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    //crossAxisAlignment: CrossAxisAlignment.center,

                                                                    children: <
                                                                        Widget>[
                                                                      Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Stack(
                                                                            children: <Widget>[
                                                                              Padding(
                                                                                padding: EdgeInsets.only(right: 3, bottom: 3),
                                                                                child: CircleAvatar(
                                                                                  backgroundImage: ((resourceItem.contentDetails!.contentIcon != null && resourceItem.contentDetails!.contentIcon != ""))
                                                                                      ? NetworkImage(resourceItem.contentDetails!.contentIcon!)
                                                                                      //? AssetImage("images/photo_avatar.png")
                                                                                      : AssetImage("images/photo_avatar.png") as ImageProvider,
                                                                                  radius: 22.0,
                                                                                  foregroundColor: AppColors.APP_WHITE,
                                                                                  backgroundColor: AppColors.APP_BLACK_10,
                                                                                ),
                                                                              ),
                                                                              Positioned.fill(
                                                                                child: Align(
                                                                                    alignment: Alignment.bottomRight,
                                                                                    child: Text(
                                                                                      "",
                                                                                      style: TextStyle(fontSize: 10, color: AppColors.APP_BLACK_10),
                                                                                    )),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: 6),
                                                                            child:
                                                                                Container(
                                                                              color: Colors.transparent,
                                                                              constraints: BoxConstraints(maxWidth: 180),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    (resourceItem.contentDetails!.contentTitle != null) ? resourceItem.contentDetails!.contentTitle.toString() : "",
                                                                                    overflow: TextOverflow.fade,
                                                                                    softWrap: false,
                                                                                    maxLines: 1,
                                                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.APP_BLUE),
                                                                                  ),
                                                                                  Text((resourceItem.contentDetails!.contentAuthor == null && resourceItem.contentDetails!.contentVersion == null) ? "" : "${"From : " + resourceItem.contentDetails!.contentAuthor! + ", " + resourceItem.contentDetails!.contentVersion!}"),

                                                                                  // Text("test Tamilnadu")
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              Padding(
                                                                                  padding: EdgeInsets.only(left: 10),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: <Widget>[
                                                                                      Text(
                                                                                        (resourceItem.contentDetails!.contentBusinessSector != null) ? resourceItem.contentDetails!.contentBusinessSector! : "",
                                                                                        //"skill",
                                                                                        style: TextStyle(
                                                                                            color: AppColors.APP_LIGHT_BLUE_20,
                                                                                            //color: AppColors.APP_WHITE,
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      Text(
                                                                                        "",
                                                                                        style: TextStyle(
                                                                                            color: AppColors.APP_LIGHT_BLUE_20,
                                                                                            //color: AppColors.APP_WHITE,
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                    ],
                                                                                  )),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 1,
                                                                  ),
                                                                ]),
                                                          ),
                                                          onTap: () async {
                                                            print("resourceItem.contentDetails.contentUri :==>" +
                                                                resourceItem
                                                                    .contentDetails!
                                                                    .contentUri!);

                                                            if (resourceItem
                                                                    .contentDetails!
                                                                    .contentCategory ==
                                                                "video") {
                                                              if (resourceItem
                                                                          .contentDetails!
                                                                          .contentUri !=
                                                                      null &&
                                                                  resourceItem
                                                                          .contentDetails!
                                                                          .contentUri !=
                                                                      "") {
                                                                /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VideoPlayerScreen(videoUrl : resourceItem.contentDetails.contentUri)));*/

                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => BGVideoPlayerView(
                                                                            title: resourceItem.contentDetails!.contentTitle
                                                                                .toString(),
                                                                            local:
                                                                                "",
                                                                            videoUrl:
                                                                                resourceItem.contentDetails!.contentUri!)));
                                                              } else {
                                                                print(
                                                                    "Video Url is empty");
                                                              }
                                                            } else if (resourceItem
                                                                    .contentDetails!
                                                                    .contentCategory ==
                                                                "image") {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          FullPhoto(
                                                                            url:
                                                                                resourceItem.contentDetails!.contentUri!,
                                                                            title:
                                                                                resourceItem.contentDetails!.contentTitle.toString(),
                                                                          )));
                                                            } else if (resourceItem
                                                                    .contentDetails!
                                                                    .contentCategory ==
                                                                "url") {
                                                              if (await canLaunch(
                                                                  resourceItem
                                                                      .contentDetails!
                                                                      .contentUri!)) {
                                                                await launch(
                                                                    resourceItem
                                                                        .contentDetails!
                                                                        .contentUri!);
                                                              } else {
                                                                String url =
                                                                    resourceItem
                                                                        .contentDetails!
                                                                        .contentUri!;
                                                                throw 'Could not launch $url';
                                                              }
                                                            } else {
                                                              if (resourceItem
                                                                          .contentDetails!
                                                                          .contentUri !=
                                                                      null &&
                                                                  resourceItem
                                                                          .contentDetails!
                                                                          .contentUri !=
                                                                      "") {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => PdfViewerNew(
                                                                            title:
                                                                                resourceItem.contentDetails!.contentTitle.toString(),
                                                                            pdfUrl: resourceItem.contentDetails!.contentUri!)));
                                                              } else {
                                                                print(
                                                                    "Pdf Url is empty");
                                                              }
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        8.0, 0.0, 8.0, 0.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        //Scaffold.of(context).showSnackBar(SnackBar(backgroundColor: Colors.pink,duration:Duration(microseconds: 2000),content: Text("Selected Item "+this.widget.searchItemTitle+":==>"+resourceItem.firstName )));
                                                      },
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 70,
                                                        child: GestureDetector(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    23.0,
                                                                    0.0,
                                                                    23.0,
                                                                    0.0),
                                                            // padding:  const EdgeInsets.all(1.0),

                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .stretch,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    //crossAxisAlignment: CrossAxisAlignment.center,

                                                                    children: <
                                                                        Widget>[
                                                                      Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Stack(
                                                                            children: <Widget>[
                                                                              Padding(
                                                                                padding: EdgeInsets.only(right: 3, bottom: 3),
                                                                                child: CircleAvatar(
                                                                                  backgroundImage: ((resourceItem.profilePicture != null && resourceItem.profilePicture != ""))
                                                                                      ? NetworkImage(resourceItem.profilePicture!)
                                                                                      //? AssetImage("images/photo_avatar.png")
                                                                                      : AssetImage("images/photo_avatar.png") as ImageProvider,
                                                                                  radius: 22.0,
                                                                                  foregroundColor: AppColors.APP_WHITE,
                                                                                  backgroundColor: AppColors.APP_BLACK_10,
                                                                                ),
                                                                              ),
                                                                              Positioned.fill(
                                                                                child: Align(
                                                                                    alignment: Alignment.bottomRight,
                                                                                    child: Text(
                                                                                      //"${resourceItem.resourceLevel}\u{00B0}",
                                                                                      //"${getResourceLevel((resourceItem.level != null) ?resourceItem.level : "") }",
                                                                                      "",
                                                                                      style: TextStyle(fontSize: 10, color: AppColors.APP_BLACK_10),
                                                                                    )),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: 6),
                                                                            child:
                                                                                Container(
                                                                              color: Colors.transparent,
                                                                              constraints: BoxConstraints(maxWidth: 180),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    (resourceItem.firstName != null) ? resourceItem.firstName! : "",
                                                                                    overflow: TextOverflow.fade,
                                                                                    softWrap: false,
                                                                                    maxLines: 1,
                                                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.APP_BLUE),
                                                                                  ),
                                                                                  Text((resourceItem.city == null && resourceItem.state == null) ? "" : "${resourceItem.city}, ${resourceItem.state}"),

                                                                                  Visibility(
                                                                                    visible: (resourceItem != null && resourceItem.manualAddedReferrerName != null && resourceItem.manualAddedReferrerName != ""),
                                                                                    //visible: true,
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(left: 2),
                                                                                      child: Container(
                                                                                        color: Colors.transparent,
                                                                                        child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                                                                          richText = RichText(
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            maxLines: 1,
                                                                                            strutStyle: StrutStyle(fontSize: 6.0),
                                                                                            text: TextSpan(style: TextStyle(color: Colors.black), text: (resourceItem != null && resourceItem.manualAddedReferrerName != null && resourceItem.manualAddedReferrerName != "") ? ("Ref : " + resourceItem.manualAddedReferrerName!) : ""
                                                                                                //text: "Ref : Test"
                                                                                                ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 1,
                                                                                          ),
                                                                                        ]),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  // Text("test Tamilnadu")
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              Padding(
                                                                                  padding: EdgeInsets.only(left: 10),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: <Widget>[
                                                                                      Text(
                                                                                        (resourceItem.skill != null) ? resourceItem.skill! : "",
                                                                                        //"skill",
                                                                                        style: TextStyle(
                                                                                            color: AppColors.APP_LIGHT_BLUE_20,
                                                                                            //color: AppColors.APP_WHITE,
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      Visibility(
                                                                                        visible: (resourceList.searchResults![i].showRating != null && resourceList.searchResults![i].showRating! != 0) ? true : false,
                                                                                        //visible: true,
                                                                                        key: PageStorageKey('RatingBarIndicator'),
                                                                                        child: RatingBarIndicator(
                                                                                          rating: (resourceItem != null && resourceItem.rating != null) ? resourceItem.rating!.toDouble() : 0.0,
                                                                                          //rating: 0.0,
                                                                                          itemBuilder: (context, index) => Icon(
                                                                                            Icons.star,
                                                                                            color: Colors.amber,
                                                                                          ),
                                                                                          itemCount: 5,
                                                                                          itemSize: 10.0,
                                                                                          direction: Axis.horizontal,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  )),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 1,
                                                                  ),
                                                                ]),
                                                          ),
                                                          onTap: () {
                                                            //   globalResourceId = resourceItem.id;
                                                            //   globalResourceType = resourceItem.resourceType;
                                                            //
                                                            //   //globalAddResourceModel = resourceItem;
                                                            //   globalSearchResourceModel = resourceItem;
                                                            //
                                                            //   FocusScopeNode currentFocus = FocusScope.of(context);
                                                            //   if (!currentFocus.hasPrimaryFocus) {
                                                            //     currentFocus.unfocus();
                                                            //   }
                                                            //
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ResourceDetailsView(
                                                                              isRedirectFrom: "resource_search_list",
                                                                              resoruceid: resourceItem.id.toString(),
                                                                                resorucetype: resourceItem.resourceType.toString()
                                                                            )));
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
              ],
            )));
  }

  Widget buildLoading() {
    return Container(
      height: MediaQuery.of(context).size.height/3,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget showNoResultFound() {
    return Container(
      height: MediaQuery.of(context).size.height/3,
      child: Center(
        child: Padding(
            padding: EdgeInsets.only(bottom: 0),
            child: Text(
              "No Resource Found!!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
