import 'package:ACI/Bloc/Resorceview/resource_details_view.dart';
import 'package:ACI/Model/care_team_model.dart';
import 'package:ACI/data/api/repository/SurveyRepo.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ACI/Model/appointment_details.dart';
import 'package:ACI/Model/taksmodel.dart';
import 'package:ACI/Screen/ScreenCheck.dart';
import 'package:ACI/data/api/repository/SurveyRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/calls_messages_services.dart';
import 'package:ACI/utils/constants.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Careteam extends StatefulWidget {
  Careteam({Key? key}) : super(key: key);

  @override
  _CareteamState createState() {
    return _CareteamState();
  }
}

class _CareteamState extends State<Careteam> {
  final String avatar = "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F1.jpg?alt=media";

  final TextStyle whiteText = TextStyle(color: Colors.white);
  String username = "";

  String userImage = "";
  bool isload = false;
  static final SurveyRepo resourceRepository = new SurveyRepo();
  CareTeamModel careTeamModel=CareTeamModel();

  @override
  void initState() {
    super.initState();
    getuserName();
    getsurvey();
  }
  void getsurvey() async {
    isload = true;
    http.Response? response =
    await resourceRepository.getorgchannelmember();
    if(response!.statusCode==200){
      careTeamModel = CareTeamModel.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    }



    setState(() {
      isload = false;
    });
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
      print(userImage);
    });
  }

  @override
  void dispose() {
    super.dispose();
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
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: AppColors.APP_WHITE,
      body: isload?buildLoading():careTeamModel.orgMembers==null?Center(
          child: Text("Something went wrong",style: ktextstyle.copyWith(
            fontSize: 15
          ),)
      ):_buildBody(context),
    );
  }
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 2.0),
          // Row(
          //   children: [
          //     GestureDetector(
          //       child: Container(
          //         padding: EdgeInsets.only(top: 7, bottom: 7,left: 25,right: 20),
          //         margin: EdgeInsets.all(8),
          //         child: CircleAvatar(
          //             radius: 38.0,
          //             backgroundColor: AppColors.APP_LIGHT_BLUE,
          //             backgroundImage:  appointmentDetails.picture.toString()!="null"&&appointmentDetails.picture != ""
          //                 ? NetworkImage(appointmentDetails.picture.toString())
          //                 : AssetImage("images/photo_avatar.png") as ImageProvider),
          //       ),
          //
          //       onTap: () {
          //
          //       },
          //     ),
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.all(3),
          //           child: Text(
          //             appointmentDetails.name.toString()+"  "+appointmentDetails.designation.toString(),
          //             overflow: TextOverflow.ellipsis,
          //             softWrap: false,
          //             maxLines: 3,
          //             style: kSubtitleTextSyule1.copyWith(
          //                 fontWeight: FontWeight.w600,
          //                 height: 1,
          //                 color: AppColors.APP_BLUE
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.all(3),
          //           child: Text(
          //             appointmentDetails.institute.toString(),
          //             overflow: TextOverflow.ellipsis,
          //             softWrap: false,
          //             maxLines: 3,
          //             style:kSubtitleTextSyule1.copyWith(
          //                 fontWeight: FontWeight.w600,
          //                 height: 1,
          //                 color: AppColors.APP_BLUE
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.all(3),
          //           child: Text(
          //             appointmentDetails.address.toString(),
          //             overflow: TextOverflow.ellipsis,
          //             softWrap: false,
          //             maxLines: 3,
          //             style: kSubtitleTextSyule1.copyWith(
          //                 fontWeight: FontWeight.w600,
          //                 height: 1,
          //                 color: AppColors.APP_BLUE
          //             ),
          //           ),
          //         ),
          //         GestureDetector(
          //           onTap: (){
          //             CallsAndMessagesService.call(appointmentDetails.phone1.toString().replaceAll(' ', ''));
          //           },
          //           child: Row(
          //             children: [
          //               CircleAvatar(backgroundColor: AppColors.APP_WHITE,radius: 15,child: Icon(FontAwesomeIcons.phoneAlt,color: AppColors.APP_BLUE,size: 18,)),
          //               Padding(
          //                 padding: const EdgeInsets.only(top: 5,bottom: 5,left: 5),
          //                 child: Text(
          //                   appointmentDetails.phone1.toString(),
          //                   overflow: TextOverflow.ellipsis,
          //                   softWrap: false,
          //                   maxLines: 3,
          //                   style: kSubtitleTextSyule1.copyWith(
          //                       fontWeight: FontWeight.w600,
          //                       height: 1,
          //                       color: AppColors.APP_BLUE
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          // Padding(
          //   padding: EdgeInsets.only(top: 7, bottom: 7,left: 40,right: 40),
          //   child: Divider(
          //     height: 5,
          //     thickness: 1,
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(top: 7, bottom: 7),
          //   child: Container(
          //       padding: const EdgeInsets.only(
          //         left: 40,
          //         top: 7,
          //         right: 15,
          //         bottom: 7,
          //       ),
          //       // decoration: BoxDecoration(
          //       //     color: AppColors.APP_LIGHT_BLUE,
          //       //     borderRadius: BorderRadius.only(
          //       //         bottomRight: Radius.circular(16.0),
          //       //         topRight: Radius.circular(16.0))),
          //       child: Text(
          //         "Care Team Members",
          //         style:
          //         TextStyle(fontWeight: FontWeight.bold,
          //             fontSize: 16,
          //             color: AppColors.APP_BLUE1),
          //       )),
          // ),
          careTeamModel.orgMembers!=null?ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemCount: careTeamModel.orgMembers!.length,
              itemBuilder: (BuildContext context,
                  int index) {
                return Hero(
                  tag: careTeamModel.orgMembers![index].orgMemberId.toString(),
                  child: Card(
                    color: AppColors.APP_BLUE1,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(8),
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ResourceDetailsView(isRedirectFrom: AppStrings.isRedirectFromResourceSearchList,resoruceid: careTeamModel.orgMembers![index].orgMemberId.toString(),resorucetype: "internal-channel",)),);
                      },
                      leading:  Container(
                        margin: EdgeInsets.all(8),
                        child: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: AppColors.APP_LIGHT_BLUE,
                            backgroundImage:  careTeamModel.orgMembers![index].profilePictureLink.toString()!="null"&&careTeamModel.orgMembers![index].profilePictureLink.toString() != ""
                                ? NetworkImage(careTeamModel.orgMembers![index].profilePictureLink.toString())
                                : AssetImage("images/photo_avatar.png") as ImageProvider),
                      ),
                      title: Text(careTeamModel.orgMembers![index].firstName.toString(), style:
                      kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: Colors.white,
                      )
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 8,),
                          careTeamModel.orgMembers![index].address1 !=null? Text(careTeamModel.orgMembers![index].address1??'',
                            style: kSubtitleTextSyule1.copyWith(
                              fontWeight: FontWeight.w500,
                              height: 1,
                              color: Colors.white70),
                          ):Container(),
                          SizedBox(height: careTeamModel.orgMembers![index].address1 !=null?8:0,),
                          Text(careTeamModel.orgMembers![index].address2??'',
                            style: kSubtitleTextSyule1.copyWith(
                              fontWeight: FontWeight.w500,
                              height: 1,
                              color: Colors.white70),
                          ),
                          SizedBox(height: 8,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(careTeamModel.orgMembers![index].city!+" , ",
                                style: kSubtitleTextSyule1.copyWith(
                                  fontWeight: FontWeight.w500,
                                  height: 1,
                                  color: Colors.white70
                              ),),
                              SizedBox(width: 2,),
                              Text(careTeamModel.orgMembers![index].state??'',
                                style: kSubtitleTextSyule1.copyWith(
                                    fontWeight: FontWeight.w500,
                                    height: 1,
                                    color: Colors.white70
                                ),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }):Center(
            child: Container(
              margin: EdgeInsets.only(top: 50),
              child: Text("No Care Team Members",style: kSubtitleTextSyule1.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  color: AppColors.APP_GREY
              ),),

            ),
          )
        ],
      ),
    );
  }

}