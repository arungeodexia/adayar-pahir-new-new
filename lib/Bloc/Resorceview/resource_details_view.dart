import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ACI/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ACI/Bloc/Resorceview/resource_view_bloc.dart';
import 'package:ACI/Model/AddUpdateReviewModel.dart';
import 'package:ACI/Model/ResourceSearchNew.dart';
import 'package:ACI/Model/ReviewsListResponse.dart';
import 'package:ACI/Screen/add_resorce.dart';
import 'package:ACI/Screen/mydashboard.dart';
import 'package:ACI/data/api/repository/ResourceRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/unreadchat/Controllers/firebaseController.dart';
import 'package:ACI/unreadchat/Controllers/utils.dart';
import 'package:ACI/unreadchat/chatroom.dart';
import 'package:ACI/utils/calls_messages_services.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:add_2_calendar/add_2_calendar.dart';


class ResourceDetailsView extends StatefulWidget {
  final String isRedirectFrom;
  final String resoruceid;
  final String resorucetype;

  ResourceDetailsView({required this.isRedirectFrom, required this.resoruceid, required this.resorucetype});

  @override
  State<StatefulWidget> createState() => ResourceDetailsState();
}

class AppPropertiesBloc {
  StreamController<String> _title = StreamController<String>();

  Stream<String> get titleStream => _title.stream;

  updateTitle(String newTitle) {
    _title.sink.add(newTitle);
  }

  dispose() {
    _title.close();
  }
}

class ResourceDetailsState extends State<ResourceDetailsView> {
  bool isReferralListPage = false;
  bool? useMobileLayout;
  bool isFavorite = false;
  bool ismyres = false;



  final appBloc = AppPropertiesBloc();

  static List<String> gridTitleList = [
    "Mobile",
    "Email",
    "Message",
    "Whatsapp"
  ];
  static List<String> gridTitleContentList = [
    "+123 456 789 234",
    "paul.doe@mail.com",
    "+123 456 789 234",
    "+123 456 789 234"
  ];
  bool boolShowDialog = false;

  //static AddResourceModel gresourceDetail = AddResourceModel();
  static ResourceResults gresourceDetail = ResourceResults();
   ResourceResults resourceResults = ResourceResults();

  // AddResourceModel editResourceDetail;

  //void fillContactData(AddResourceModel resourceDetail) {
  ///Reviews//////
  List<Reviews>? gTempReviews = null;
  List<Reviews>? gReviews = null;
  RichText? richText = null;
  static Reviews? staticReviewItem;
  int showRatingVal = 1;

  var globalSearchResourceModel;


  @override
  void initState() {
    /////Reviews
    fetchReviewList();
    initPlatformState();
    print(widget.isRedirectFrom);
    super.initState();
  }

  void toastMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void fetchReviewList() async {
    //toastMessage("Fetch Reviews List method :==>");
    //print("Fetch Reviews List method :==>");
    // gReviews = await resourceRepository.fetchReviewsList(globalResourceId);
    BlocProvider.of<ResourceViewBloc>(context).add(FetchResourceDetails(widget.resoruceid,widget.resorucetype));

    ////Fetch resource details////
  }

  Future<bool> onWillPop() async {
    //Go to Dashboard
    if (widget.isRedirectFrom != null &&
        widget.isRedirectFrom == AppStrings.isRedirectFromResourceSearchList) {
      Navigator.pop(context,true);
    } else {
      _goDashboard();
    }
    return false;
  }
  Future<void> _moveTochatRoom(selectedUserToken, selectedUserID,
      selectedUserName, selectedUserThumbnail,countrycode) async {
    try {
      String username="", userImage;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final resourceDetailsResponse = await json
          .decode(prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString());

      setState(() {
        username = resourceDetailsResponse['firstName'];
        print(resourceDetailsResponse['profilePicture']);
        userImage = resourceDetailsResponse['profilePicture'];

        // if (!userImage.contains("https")) {
        //   userImage = "https://d1rtv5ttcyt7b.cloudfront.net/" + userImage;
        // }
      });

      FirebaseController.instanace
          .saveUserDataToFirebaseDatabase(randomIdWithName(selectedUserID),
          selectedUserName, countrycode, selectedUserThumbnail)
          .then((data) {});

      String chatID = makeChatId(globalPhoneNo, selectedUserID);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatRoom(
                  globalPhoneNo,
                  username,
                  selectedUserToken,
                  selectedUserID,
                  chatID,
                  selectedUserName,
                  selectedUserThumbnail,countrycode)));
    } catch (e) {
      print(e);
    }
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

  @override
  Widget build(BuildContext context) {
    globalcontext = context;
    initPlatformState();

    return new WillPopScope(
      onWillPop: onWillPop,
      child: Container(
          child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () => onWillPop(),
          ),
          title: StreamBuilder<Object>(
              stream: appBloc.titleStream,
              initialData: tr("docdet"),
              builder: (context, snapshot) {
                return Text(snapshot.data!.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold));
              }),
          centerTitle: true,
          backgroundColor: AppColors.APP_BLUE,
          automaticallyImplyLeading: true,
          actions: <Widget>[
            Visibility(
                //  visible: ( !isReferralListPage && ((globalAddResourceModel != null && globalAddResourceModel.resourceType == null) || (globalAddResourceModel != null && globalAddResourceModel.resourceType == AppStrings.RESOURCE_LIST_RESOURCE_TYPE_INTERNAL && globalAddResourceModel.isMyResource))),
                visible: (ismyres),
                child: GestureDetector(
                  child: Padding(
                      padding: EdgeInsets.only(right: 13),
                      child: CircleAvatar(
                        child: Icon(
                          Icons.edit,
                          size: 20,
                        ),
                        radius: 14,
                        backgroundColor: AppColors.APP_LIGHT_BLUE_30,
                        foregroundColor: AppColors.APP_BLUE,
                      )),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => AddResorce(editResourceDetail:resourceResults ,)),(Route<dynamic> route) => false,);
                  },
                ))
          ],
        ),
        backgroundColor: AppColors.APP_WHITE,
        body: BlocListener<ResourceViewBloc, ResourceViewState>(
          listener: (context, state) {
            if (state is ResourceFetched) {
              resourceResults=state.resourceDetail;
              ismyres=state.resourceDetail.isMyResource!;
              setState(() {

              });
            }
          },
          child: BlocBuilder<ResourceViewBloc, ResourceViewState>(
            builder: (context, state) {
              if (state is ResourceFetched) {
                return showResourceData(context, state.resourceDetail);
              } else if (state is ResourceLoading) {
                return buildLoading();
              }else if (state is ResourceFetchingFailed) {
                return Center(child: Text(tr('notfound')));
              }
              return Container();
            },
          ),
        ),
      )),
    );
  }

  Widget showEmptyPage() {
    return Container();
  }

  //Widget showResourceData(BuildContext context, AddResourceModel resourceDetail) {
  Widget showResourceData(
      BuildContext context, ResourceResults resourceDetail) {
    if (resourceDetail != null) {
      if (resourceDetail.channelDetails != null &&
          resourceDetail.channelDetails!.showRating != null) {
        showRatingVal = resourceDetail.channelDetails!.showRating!;
      } else {
        showRatingVal = 1;
      }
    }

    return Hero(
      tag: widget.resoruceid,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      color: Colors.blue,
                      height: 70.0,
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 70),
                    //   child: Container(
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: <Widget>[
                    //         Padding(
                    //           padding: EdgeInsets.fromLTRB(0.0, 15.0, 8.0, 8.0),
                    //           child: (resourceDetail != null &&
                    //                   resourceDetail.isMyResource != null &&
                    //                   resourceDetail
                    //                       .isMyResource!) //resourceDetail.isMyResource != null &&
                    //               ? Column(
                    //                   children: <Widget>[
                    //                     GestureDetector(
                    //                       child:
                    //                           //(resourceDetail.favorite == 1)
                    //                           (resourceDetail.favorite==1)
                    //                               ? Icon(
                    //                                   Icons.favorite,
                    //                                   size: 30,
                    //                                   color: Colors.red,
                    //                                 )
                    //                               : Icon(
                    //                                   Icons.favorite_border,
                    //                                   size: 30,
                    //                                   color: Colors.red,
                    //                                 ),
                    //                       onTap: () {
                    //                         // AddResourceModel updateResource = resourceDetail;
                    //                         ResourceResults updateResource =
                    //                             resourceDetail;
                    //
                    //                         if (updateResource.favorite == 0)
                    //                           updateResource.favorite = 1;
                    //                         else
                    //                           updateResource.favorite = 0;
                    //
                    //                         BlocProvider.of<ResourceViewBloc>(context).add(UpdateResourceDetails(updateResource));
                    //
                    //                         setState(() {
                    //                           isFavorite = !isFavorite;
                    //                         });
                    //                       },
                    //                     ),
                    //                     Text(
                    //                       "Favorite",
                    //                       style: TextStyle(fontSize: 10),
                    //                     )
                    //                   ],
                    //                 )
                    //               : Column(
                    //                   children: <Widget>[
                    //                     GestureDetector(
                    //                       child: Icon(
                    //                         Icons.add_circle,
                    //                         size: 30,
                    //                         color: AppColors.APP_GREEN,
                    //                       ),
                    //                       onTap: () {
                    //                         ResourceResults addResource =
                    //                             resourceDetail;
                    //                         addResource.favorite = 0;
                    //                         if (addResource.lastName == null) {
                    //                           addResource.lastName = "";
                    //                         }
                    //
                    //                         AddUpdateReviewModel
                    //                             addUpdateReviewModel =
                    //                             new AddUpdateReviewModel();
                    //                         addUpdateReviewModel.review = "";
                    //                         addUpdateReviewModel.rating = 0;
                    //                         ResourceRepo repo=ResourceRepo();
                    //                         repo.addreviewresource(addResource, "", addUpdateReviewModel);
                    //                         resourceDetail.isMyResource=true;
                    //                         setState(() {
                    //                           try {
                    //
                    //                           } on Exception catch (exception) {
                    //                           }
                    //                         });
                    //                       },
                    //                     ),
                    //                     Text(
                    //                       "Add Resource",
                    //                       style: TextStyle(fontSize: 10),
                    //                     )
                    //                   ],
                    //                 ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Positioned.fill(
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 20.0),
                            /*child: CircleAvatar(
                                backgroundImage: (resourceDetail != null &&
                                    resourceDetail.profilePicture != null &&
                                    resourceDetail.resourceType == null &&
                                    resourceDetail.resourceType ==
                                        AppStrings
                                            .RESOURCE_LIST_RESOURCE_TYPE_EXTERNAL)
                                    ? NetworkImage(resourceDetail.profilePicture)
                                    : (((resourceDetail.profilePicture !=
                                    null &&
                                    resourceDetail.profilePicture !=
                                        ""))
                                    //? MemoryImage(base64Decode(resourceDetail.profilePicture))
                                    ? NetworkImage((resourceDetail.profilePicture))
                                    : AssetImage("images/photo_avatar.png")),
                                radius: 50,
                              ),*/

                            child: CircleAvatar(
                              backgroundImage: (resourceDetail != null &&
                                      resourceDetail.profilePicture != null)
                                  ? NetworkImage(
                                      resourceDetail.profilePicture!.toString())
                                  : AssetImage("images/photo_avatar.png")
                                      as ImageProvider,
                              radius: 50,
                            ),
                          )),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0, top: 125.0, bottom: 5),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      margin: const EdgeInsets.all(0.0),
                                      padding: const EdgeInsets.all(0.0),
                                      child: Text(
                                        (resourceDetail.firstName! != null)
                                            ? resourceDetail.firstName!
                                            : "",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "OpenSans",
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.APP_BLACK_20),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Text(
                                  //   (resourceDetail.skill! != null)
                                  //       ? resourceDetail.skill!
                                  //       : "",
                                  //   textAlign: TextAlign.center,
                                  //   style: TextStyle(
                                  //       fontSize: 20,
                                  //       fontWeight: FontWeight.w400,
                                  //       color: AppColors.APP_BLACK_10),
                                  // ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  resourceDetail.address1 != null? Text(
                                   resourceDetail.address1??'',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.APP_BLACK_10),
                                  ):Container(),
                                  resourceDetail.address1 !=null?  SizedBox(
                                    height: 10,
                                  ):Container(),
                                  resourceDetail.address2 != null?  Text(
                                      resourceDetail.address2??'',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.APP_BLACK_10),
                                  ):Container(),
                                   SizedBox(
                                    height: 10,
                                  ),
                                  Visibility(
                                    visible: true,
                                    child: Stack(
                                      children: <Widget>[
                                        Text(
                                          "${(resourceDetail.city == null) ? "" : "${resourceDetail.city.toString()}, ${resourceDetail.state.toString()}"}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors.APP_BLACK_10,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    //visible: (resourceDetail != null &&resourceDetail.channelDetails !=null &&resourceDetail.channelDetails.showRating !=null)
                                    visible: (showRatingVal == 1) ? true : false,

                                    child: Column(children: <Widget>[
                                      SizedBox(
                                        height: 8,
                                      ),
                                      RatingBarIndicator(
                                        rating: ((resourceDetail.rating != null)
                                            ? resourceDetail.rating!.toDouble()
                                            : 0),
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 20.0,
                                        direction: Axis.horizontal,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ]),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  // Visibility(
                                  //   //visible: true,
                                  //   visible: (resourceDetail != null &&
                                  //           resourceDetail.channelDetails !=
                                  //               null &&
                                  //           resourceDetail.channelDetails!
                                  //                   .channelIcon! !=
                                  //               null &&
                                  //           resourceDetail.channelDetails!
                                  //                   .channelIcon! !=
                                  //               "")
                                  //       ? true
                                  //       : false,
                                  //   child: Column(children: <Widget>[
                                  //     SizedBox(
                                  //       height: 5,
                                  //     ),
                                  //     CircleAvatar(
                                  //       backgroundImage: (resourceDetail !=
                                  //                   null &&
                                  //               resourceDetail.channelDetails !=
                                  //                   null &&
                                  //               resourceDetail.channelDetails!
                                  //                       .channelIcon !=
                                  //                   null &&
                                  //               resourceDetail.channelDetails!
                                  //                       .channelIcon !=
                                  //                   "")
                                  //           ? NetworkImage((resourceDetail
                                  //               .channelDetails!.channelIcon!))
                                  //           : AssetImage(
                                  //                   "images/photo_avatar.png")
                                  //               as ImageProvider,
                                  //       radius: 25,
                                  //     ),
                                  //     SizedBox(
                                  //       height: 7,
                                  //     ),
                                  //   ]),
                                  // ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                resourceDetail.displayPhoneNumber!.toString()=="false"
                    ? Container(): Text(
                  "${(resourceDetail.countryCode == null && resourceDetail.mobile == null) ? "" : " ${tr('phone')} : ${resourceDetail.countryCode.toString()}" " ${resourceDetail.mobile.toString()}"}",
                  style: TextStyle(
                      color: AppColors.APP_BLACK_10,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 7,
                ),
                Container(
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 12,
                                  ),
                                  resourceDetail.allowCall!.toString()=="false"
                                      ? Container(): GestureDetector(
                                    child: Image(
                                        image: AssetImage(
                                            'images/icon_call_new1.png'),
                                        width: 40,
                                        height: 40),
                                    onTap: () =>
                                        contactOptions("phone", resourceDetail),
                                  ),
                                  resourceDetail.allowSms!.toString()=="false"
                                      ? Container(): SizedBox(
                                    width: 20,
                                  ),
                                  resourceDetail.allowSms!.toString()=="false"
                                      ? Container():GestureDetector(
                                    child: Image(
                                      image:
                                          AssetImage('images/icon_sms_new.png'),
                                      width: 40,
                                      height: 40,
                                    ),
                                    onTap: () =>
                                        contactOptions("sms", resourceDetail),
                                  ),
                                  resourceDetail.allowChat!.toString()=="false"
                                      ? Container():SizedBox(
                                    width: 20,
                                  ),
                                  resourceDetail.allowChat!.toString()=="false"
                                      ? Container():GestureDetector(
                                    child: CircleAvatar(
                                      child: Icon(Icons.message),
                                    ),
                                    onTap: () =>
                                        contactOptions("chat", resourceDetail),
                                  ),
                                  resourceDetail.allowEmail!.toString()=="false"
                                      ? Container():SizedBox(
                                    width: 20,
                                  ),
                                  resourceDetail.allowEmail!.toString()=="false"
                                      ? Container():GestureDetector(
                                    child: Image(
                                      image: (gresourceDetail != null &&
                                              gresourceDetail.email != null &&
                                              gresourceDetail.email != "")
                                          ? AssetImage('images/icon_mail_new.png')
                                          : AssetImage(
                                              'images/icon_mail_new_gray.png'),
                                      width: 40,
                                      height: 40,
                                    ),
                                    onTap: () =>
                                        contactOptions("mail", resourceDetail),
                                  ),
                                  resourceDetail.allowWhatsapp!.toString()=="false"
                                      ? Container(): SizedBox(
                                    width: 20,
                                  ),
                                  resourceDetail.allowWhatsapp!.toString()=="false"
                                      ? Container(): GestureDetector(
                                    child: Image(
                                      image: AssetImage(
                                          'images/icon_whatsapp_new2.png'),
                                      width: 45,
                                      height: 45,
                                    ),
                                    onTap: () => contactOptions(
                                        "whatsApp", resourceDetail),
                                  ),
                                  resourceDetail.allowCalendar!.toString()=="false"
                                      ? Container():SizedBox(
                                    width: 20,
                                  ),
                                  resourceDetail.allowCalendar!.toString()=="false"
                                      ? Container():GestureDetector(
                                    child: Image(
                                      image:
                                          AssetImage('images/icon_calendar.png'),
                                      width: 45,
                                      height: 45,
                                    ),
                                    onTap: () => contactOptions(
                                        "calendar", resourceDetail),
                                  ),
                                ],
                              ),
                              Visibility(
                                  visible: false,
//                               visible: (getReferredByName(resourceDetail) != "")
//                                   ? true
//                                   : false,
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                                      child: GestureDetector(
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "Show Reviews",
                                              style: TextStyle(
                                                  color:
                                                      AppColors.APP_LIGHT_BLUE_20,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              width: 7,
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          /*  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ResourceReviewsListView(
                                                resourceDetail: editResourceDetail),
                                          ),
                                        );*/
                                        },
                                      ))),
                            ],
                          ))),
                ),

                Visibility(
                  visible: (resourceDetail.review != null &&
                          resourceDetail.review != "")
                      ? true
                      : false,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            (resourceDetail.review != null)
                                ? resourceDetail.review!
                                : "",
                            style: TextStyle(
                                color: AppColors.APP_BLACK_10,
                                fontWeight: FontWeight.normal,
                                fontSize: 11),
                          ),
                        ]),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                resourceDetail.notes==null?Container():Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0,top: 8),
                      child: Text(tr('notes'), style:
                      kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.w500,
                          height: 1,
                          color: Colors.black,
                        fontSize: 19
                      ),
                          textAlign: TextAlign.left
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0,top: 20,bottom: 20),
                  child: Text(resourceDetail.notes??'',
                    style: TextStyle(
                      color: AppColors.APP_BLACK_10,
                      fontWeight: FontWeight.w500,letterSpacing: 1,wordSpacing: 1,
                      fontSize: 14),
                  // style:kSubtitleTextSyule1.copyWith(
                  //     fontWeight: FontWeight.w200,
                  //     height: 1,
                  //     color: Colors.black,
                  //   fontSize: 13,letterSpacing: 1,wordSpacing: 1
                  // ),
                  ),
                )
                //////Show reviews list
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> contactOptions(
      String contactType, ResourceResults resourceDetail) async {
    String number=resourceDetail.countryCode.toString()+resourceDetail.mobile.toString();
    number=number.replaceAll(' ', '');
    // print("contact Options resourceDetail.mobile :==>" +
    //     resourceDetail.mobile);
    // print("contact Options gridTitleContentList[1] :==>" +
    //     gridTitleContentList[1]);
    if (contactType == "phone") {
      if (resourceDetail.mobile != null && resourceDetail.mobile != "") {
        CallsAndMessagesService.call(number);
      }
    } else if (contactType == "whatsApp") {
      if (resourceDetail.mobile != null && resourceDetail.mobile != "") {
        whatsAppOpen(number, "",
            context);
      }
    } else if (contactType == "chat") {
      _moveTochatRoom(
        '',
        resourceDetail.mobile.toString(),
        resourceDetail.firstName.toString(),
        resourceDetail.profilePicture.toString(),
        resourceDetail.countryCode.toString(),
      );

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ChatScreen(
      //             peerId: resourceDetail.mobile.toString(),
      //             peerAvatar: resourceDetail.profilePicture.toString(),
      //             peerName: resourceDetail.firstName.toString(),
      //             peergcm: '0',
      //             userid: '0')));
    } else if (contactType == "mail") {
      if (resourceDetail.email != null && resourceDetail.email != "")
        try{
          CallsAndMessagesService.sendEmail(resourceDetail.email??'');
        }on PlatformException catch (err) {
          Fluttertoast.showToast(msg: err.toString());
        }catch(_){
           Fluttertoast.showToast(msg: _.toString());
        }
    } else if (contactType == "sms") {
      if (resourceDetail.mobile != null && resourceDetail.mobile != "") {
        CallsAndMessagesService
            .sendSms(number);
      }
    } else if (contactType == "calendar") {
      String userName;
      /*if(resourceDetail.firstName != null &&resourceDetail.lastName != null){
        userName = resourceDetail.firstName+" "+resourceDetail.lastName;
      }else if(resourceDetail.firstName != null){
        userName = resourceDetail.firstName;
      }else if(resourceDetail.lastName != null){
        userName = resourceDetail.lastName;
      }else{
        userName = "-";
      }*/

      //Get the application username
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final resourceDetailsResponse =
          json.decode(prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString());
      print(
          "resourceDetailsResponse :==>" + resourceDetailsResponse.toString());
      String firstName = resourceDetailsResponse['firstName'];
      print("resourceDetailsResponse firstName :==>" + firstName);
      String lastName = resourceDetailsResponse['lastName'];
      print("resourceDetailsResponse lastName :==>" + lastName);
      userName = firstName + " " + lastName;

      Event event = Event(
        title: userName,
        description: '-',
        location: '',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 0)),
        allDay: false,
          timeZone:timezone

      );

      Add2Calendar.addEvent2Cal(event).then((success) {
        //toastMessage(success ? 'Event created Successfully' : 'Something went wrong');
      });
    }
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

  var gridView = new GridView.builder(
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: new Card(
              elevation: 5.0,
              color: AppColors.APP_LIGHT_GREY_30,
              child: new Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        //GetGridCircularIconWidget(index)
                        (index == 0)
                            ? Image(
                                image: AssetImage('images/icon_call_new1.png'),
                                width: 150,
                                height: 150,
                              )
                            : (index == 1)
                                ? Image(
                                    image: (gresourceDetail != null &&
                                            gresourceDetail.email != null &&
                                            gresourceDetail.email != "")
                                        ? AssetImage('images/icon_mail_new.png')
                                        : AssetImage(
                                            'images/icon_mail_new_gray.png'),
                                    width: 100,
                                    height: 100,
                                  )
                                : (index == 2)
                                    ? Image(
                                        image: AssetImage(
                                            'images/icon_sms_new.png'),
                                        width: 90,
                                        height: 90,
                                      )
                                    : Image(
                                        image: AssetImage(
                                            'images/icon_whatsapp_new1.png'),
                                        width: 150,
                                        height: 150,
                                      ),
                      ],
                    ),
                  ],
                ),
                /*child: new Text('Item $index'),*/
              ),
            ),
          ),
          onTap: () {
            switch (index) {
              case 0:
                {
                  if (gridTitleContentList[index] != null &&
                      gridTitleContentList[index] != "") {
                    // _service.call(gridTitleContentList[index]);
                    CallsAndMessagesService.call(gridTitleContentList[index]
                        .toString()
                        .replaceAll(' ', ''));
                  }

                  break;
                }
              case 1:
                {
                  if (gridTitleContentList[index] != null &&
                      gridTitleContentList[index] != "")
                    try{
                      CallsAndMessagesService.sendEmail(gridTitleContentList[1]);
                    }on PlatformException catch (err) {
                      Fluttertoast.showToast(msg: err.toString());
                    }catch(_){
                      Fluttertoast.showToast(msg: _.toString());
                    }
                  break;
                }
              case 2:
                {
                  if (gridTitleContentList[index] != null &&
                      gridTitleContentList[index] != "") {
                    //CallsAndMessagesService.sendSms(gridTitleContentList[index]);
                    CallsAndMessagesService.sendSms(gridTitleContentList[index]
                        .toString()
                        .replaceAll(' ', ''));
                  }
                  break;
                }
              case 3:
                {
                  if (gridTitleContentList[index] != null &&
                      gridTitleContentList[index] != "") {
                    whatsAppOpen(
                        gridTitleContentList[index]
                            .toString()
                            .replaceAll(' ', ''),
                        "",
                        context);
                  }
                  break;
                }
            }
          },
        );
      });

  static void whatsAppOpen(
      String phone, String message, BuildContext context) async {
    // await FlutterLaunch.launchWathsApp(phone: "5534992019999", message: "Hello");
    var whatsappUrl = "whatsapp://send?phone=$phone";
    await canLaunch(whatsappUrl)
        ? launch(whatsappUrl)
        : Fluttertoast.showToast(msg: AppStrings.WHATSAPP_ERROR);
  }

  showAlertDialog(BuildContext context) {}

  getResourceLevel(String level) {
    String levelString = "";
    int levelInt = int.parse(level[level.length - 1]) - 1;

    if (levelInt > 0) {
      levelString = "Level-${levelInt.toString()}";
    }

    return levelString;
  }

  getResourceLevelByDegreeSymbol(String level) {
    String levelString = "";
    int levelInt = int.parse(level[level.length - 1]) - 1;

    if (levelInt > 0) {
      levelString = "${levelInt.toString()}\u{00B0}";
    }

    return levelString;
  }

  isMyResource(String level) {
    bool isMyResource = true;

    if (int.parse(level[level.length - 1]) > 1) {
      isMyResource = false;
    }

    return isMyResource;
  }

  ////Reviews list changes

  Widget EmptyPage() {
    return Container(
      color: Colors.white,
      height:
          MediaQuery.of(context).size.height - (AppBar().preferredSize.height),
      child: Center(
        child: Text(""),
      ),
    );
  }

  //Expanded listview//

  Future<void> initPlatformState() async {
    String timezonenew;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      timezonenew = await FlutterNativeTimezone.getLocalTimezone();
    } on PlatformException {
      timezonenew = 'Failed to get the timezonenew.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      timezone = timezonenew;
    });
  }
}
