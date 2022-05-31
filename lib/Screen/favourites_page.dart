import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ACI/Bloc/Resorceview/resource_details_view.dart';
import 'package:ACI/Model/add_resource_model.dart';
import 'package:ACI/Model/resources.dart';
import 'package:ACI/data/api/repository/ResourceRepo.dart';
import 'package:http/http.dart' as http;
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouritesPage extends StatefulWidget {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  ResourceRepo resourceRepo = ResourceRepo();

  TextEditingController searchEditingController = new TextEditingController();

  String username = "";

  String userImage = "";

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
      print(userImage);
    });
  }

  @override
  void initState() {
    getuserName();
    super.initState();
  }

  _getRequests() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    globalcontext = context;
    return Scaffold(
      body: FutureBuilder<http.Response?>(
        future: resourceRepo.gethomedata(),
        builder:
            (BuildContext context, AsyncSnapshot<http.Response?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return buildLoading();
            default:
              if (snapshot.hasError)
                return showNoResultFound();
              else if (snapshot.data == null) {
                return showNoResultFound();
              } else {
                List<Resources> resources;
                if (snapshot.data!.statusCode == 200) {
                  resources =
                      (json.decode(utf8.decode(snapshot.data!.bodyBytes)) as List)
                          .map((i) => Resources.fromJson(i))
                          .toList();
                  resources = resources.reversed.toList();
                  resources = filterOnlyFavorites(resources);
                  return _buildHomePageData(resources, context);
                }else{
                  return showNoResultFound();
                }
              }
          }
        },
      ),
    );
  }
  List<Resources> filterOnlyFavorites(
      List<Resources> resourceList) {
    List<Resources> tempfavorites = <Resources>[];

    for (final resource in resourceList) {
      if (resource.favorite == 1) tempfavorites.add(resource);
    }

    return tempfavorites;
  }

  Container _buildHomePageData(
      List<Resources> resources, BuildContext context) {
    return Container(
      child: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset('assets/comingsoon.json'),
          ],
        ),
      ),
    );
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height -
            150, //TODO Subtract all the height for individual stuff
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
//             Padding(
//               padding: const EdgeInsets.only(
//                 left: 25,
//                 top: 10,
//                 right: 20,
//                 bottom: 10,
//               ),
//               child: TextField(
//                   controller: searchEditingController,
//                   onSubmitted: (text) {
//                     globalSearchData = text.trim();
//                     // homeBloc.add(LoadSearchData(text.toString().trim(), 20, 0));
//
// //                    Navigator.pushNamed(
// //                        context, AppRoutes.APP_ROUTE_RESOURCE_SEARCH);
// //                     _goResourceSearch();
//                   },
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     color: Colors.blueAccent,
//                   ),
//                   decoration: InputDecoration(
//                       contentPadding:
//                           EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                       suffixIcon: IconButton(
//                         icon: Icon(Icons.search),
//                         onPressed: () {
//                           globalSearchData =
//                               searchEditingController.text.toString().trim();
//
// //                          Navigator.pushNamed(
// //                              context, AppRoutes.APP_ROUTE_RESOURCE_SEARCH);
// //                           _goResourceSearch();
//                         },
//                       ),
//                       hintText: "e.g. Exporters in California",
//                       border: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.white, width: 32.0),
//                           borderRadius: BorderRadius.circular(5.0)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.white, width: 32.0),
//                           borderRadius: BorderRadius.circular(5.0)))),
//             ),
            Visibility(
              visible: ((resources == null || resources == 0)) ? false : true,
              //visible:isMyResVisible,

              child: Padding(
                padding: EdgeInsets.only(top: 7, bottom: 7),
                child: Container(
                    padding: const EdgeInsets.only(
                      left: 25,
                      top: 7,
                      right: 15,
                      bottom: 7,
                    ),
                    decoration: BoxDecoration(
                        color: AppColors.APP_LIGHT_GREY_10,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(16.0),
                            topRight: Radius.circular(16.0))),
                    child: Text(
                      AppStrings.RESOURCE_FAVORITE_SUB_TITLE,
                      style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    )),
              ),
            ),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.only(
                      left: 25,
                      top: 7,
                      right: 15,
                      bottom: 0,
                    ),
                    child: (resources == null)
                        ? Container()
                        : new ListView.builder(
                        itemCount: resources.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return
                            Slidable(
                              // secondaryActions: <Widget>[
                              //
                              //   new IconSlideAction(
                              //     caption: 'Delete',
                              //     color: Colors.red,
                              //     icon: Icons.delete,
                              //     onTap: () {},
                              //   ),
                              // ],
                              child: new ListTile(
                                onTap: () {
                                  Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>new ResourceDetailsView(
                                      isRedirectFrom: AppStrings.isRedirectFromResourceSearchList,
                                      resoruceid: resources[index]
                                          .id
                                          .toString(),
                                      resorucetype: resources[index].resourceType.toString()
                                  )),)
                                      .then((val)=>val?_getRequests():null);
                                },
                                title: Text(
                                  resources[index].firstName!,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: "OpenSans",
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  resources[index].city!,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 1,
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      resources[index].skill!,
                                      style: TextStyle(
                                          color: AppColors.APP_LIGHT_BLUE_20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    RatingBarIndicator(
                                      rating:
                                      resources[index].rating!.toDouble(),
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      direction: Axis.horizontal,
                                    )
                                  ],
                                ),
                                leading: Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: 5, bottom: 2),
                                      child: CircleAvatar(
                                        backgroundImage: resources[index]
                                            .profilePicture ==
                                            null
                                            ? AssetImage(
                                            'images/photo_avatar.png')
                                        as ImageProvider
                                            : NetworkImage(resources[index]
                                            .profilePicture!),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child:
                                        (resources[index].favorite == 1)
                                            ? Icon(
                                          Icons.favorite,
                                          size: 20,
                                          color: Colors.red,
                                        )
                                            : Icon(
                                          Icons.favorite,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                        })))
          ],
        ));
  }
  Widget showNoResultFound() {
    return Container(
      height:
      MediaQuery.of(context).size.height - (AppBar().preferredSize.height),
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
  Widget buildLoading() {
    return Container(
      height:
      MediaQuery.of(context).size.height - (AppBar().preferredSize.height),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}
