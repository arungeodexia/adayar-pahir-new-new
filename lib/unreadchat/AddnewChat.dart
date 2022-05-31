import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ACI/Model/AddchatnewModel.dart';
import 'package:ACI/Model/create_edit_profile_model.dart';
import 'package:ACI/data/api/repository/ResourceRepo.dart';
import 'package:ACI/data/api/repository/ResourceRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Controllers/firebaseController.dart';
import 'Controllers/utils.dart';
import 'chatroom.dart';


class AddnewChat extends StatefulWidget {
  @override
  _AddnewChatState createState() => _AddnewChatState();
}

class _AddnewChatState extends State<AddnewChat> {
  static final ResourceRepo resourceRepository = new ResourceRepo();
  List<bool>? _isChecked;
  CreateEditProfileModel? createEditProfileModel;
  AddchatnewModel? addedGroupsModel;
  bool isload = false;
  bool isloadmore = false;
  TextEditingController searchEditingController = new TextEditingController();
  List<String> suggestions = [];
  int page = 0, limit = 10;
  String? currenttext;
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    getuserdetails();
    getdataOfGroups();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        page = page + limit;
        if (addedGroupsModel != null) {
          if (!addedGroupsModel!.lastPage!) {
            print(page);
            setState(() {});
            getdataOfGroups();
            print(addedGroupsModel!.nextStart!);
          }
        }
        // getdataOfGroups();
        print('firing');
      }
    });
  }

  void getuserdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final resourceDetailsResponse = await json
        .decode(prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString());
    createEditProfileModel =
        CreateEditProfileModel.fromJson(resourceDetailsResponse);
  }

  Widget buildLoading() {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height -
            (AppBar().preferredSize.height),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> _moveTochatRoom(selectedUserToken, selectedUserID,
      selectedUserName, selectedUserThumbnail, countrycode) async {
    try {
      String username="", userImage;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final resourceDetailsResponse = await json
          .decode(prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString());

      setState(() {
        username = resourceDetailsResponse['firstName'];
        print(resourceDetailsResponse['profilePicture']);
        userImage = resourceDetailsResponse['profilePicture'];

        if (!userImage.contains("https")) {
          userImage = "https://d1rtv5ttcyt7b.cloudfront.net/" + userImage;
        }
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
                  selectedUserThumbnail,
                  countrycode)));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    globalcontext = context;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // this is all you need
        title: Text("Add Chat"),
        actions: [
          createEditProfileModel == null
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(right: 8, top: 6, bottom: 6),
                  child: createEditProfileModel!.universityLogo == "" ||
                          createEditProfileModel!.universityLogo == null
                      ? Container()
                      : Image.network(
                          createEditProfileModel!.universityLogo!,
                          width: 55,
                          height: 40,
                        ),
                ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                top: 10,
                right: 20,
                bottom: 10,
              ),
              child: SimpleAutoCompleteTextField(
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      searchdataOfGroups(currenttext!);
                    },
                  ),
                  hintText: "Search ",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 32.0),
                      borderRadius: BorderRadius.circular(5.0)),
                ),
                controller: TextEditingController(text: ""),
                suggestions: suggestions,
                textChanged: (text) async {
                  setState(() {
                    currenttext = text;
                  });
                  if (text == "") {
                    searchdataOfGroups(text);
                  }
                },
                clearOnSubmit: false,
                textSubmitted: (text) async {
                  searchdataOfGroups(text);
                },
              ),
            ),
            addedGroupsModel == null || isload
                ? buildLoading()
                : Expanded(
                    child:
                    ListView.separated(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: addedGroupsModel!.members!.length,
                      separatorBuilder: (context, index) {
                        return Container();
                      },
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child:Container(
                            height: 90,
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.APP_LISTVIEW_BACK,
                              // gradient: new LinearGradient(
                              //     colors: [
                              //       AppColors.APP_LISTVIEW_BACK,
                              //       AppColors.APP_LISTVIEW_BACK,
                              //     ],
                              //     begin: const FractionalOffset(0.0, 0.0),
                              //     end: const FractionalOffset(1.0, 0.0),
                              //     stops: [0.0, 1.0],
                              //     tileMode: TileMode.repeated),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: AppColors.APP_LIGHTWHITE, size: 30.0),
                              leading: addedGroupsModel!
                                          .members![index].profilePicture ==
                                      "null"
                                  ? CircleAvatar(
                                      radius: 20.0,
                                      backgroundColor: const Color(0xFF777899),
                                      backgroundImage: (AssetImage(
                                          "images/photo_avatar.png")))
                                  : CircleAvatar(
                                      radius: 20.0,
                                      backgroundColor: const Color(0xFF777899),
                                      backgroundImage: ((addedGroupsModel!
                                                      .members![index]
                                                      .profilePicture !=
                                                  "" ||
                                              addedGroupsModel!.members![index]
                                                      .profilePicture !=
                                                  "null" ||
                                              addedGroupsModel!.members![index]
                                                      .profilePicture !=
                                                  null)
                                          ? NetworkImage(addedGroupsModel!
                                              .members![index].profilePicture!)
                                          : AssetImage(
                                              "images/photo_avatar.png") as ImageProvider)),
                              title: Row(
                                children: [
                                  // Image.network(addedGroupsModel.groupCategory[index].groupIcon,
                                  //   width: 30, height: 30, fit: BoxFit.contain,),

                                  new Text(
                                    addedGroupsModel!.members![index].name!,
                                    style: new TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.APP_WHITE),
                                  ),
                                ],
                              ),
                              subtitle: new Text(
                                addedGroupsModel!.members![index].groupName!.toString(),
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    color: AppColors.APP_LIGHTWHITE),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                _moveTochatRoom(
                                    "",
                                    /*addedGroupsModel.members[index].countryCode.toString()+*/
                                    addedGroupsModel!.members![index].mobileNumber
                                        .toString(),
                                    addedGroupsModel!.members![index].name,
                                    addedGroupsModel!
                                        .members![index].profilePicture,
                                    addedGroupsModel!
                                        .members![index].countryCode);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            Container(
              margin: EdgeInsets.all(isloadmore?10:0),
              height: isloadmore ? 50.0 : 0,
              width: isloadmore ? 50.0 : 0,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.APP_LISTVIEW_BACK,),
              child: Center(
                child: new CircularProgressIndicator(backgroundColor: Colors.white,),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getdataOfGroups() async {
    if (addedGroupsModel == null) {
      setState(() {
        isload = true;
      });
      // addedGroupsModel = await resourceRepository.getchatpersons(
      //     page.toString(), limit.toString());
    } else {
      setState(() {
        isloadmore = true;
      });
      // AddchatnewModel addedGroupsModelnew = await resourceRepository
      //     .getchatpersons(page.toString(), limit.toString());
      // addedGroupsModel!.members!.addAll(addedGroupsModelnew.members!);
      // addedGroupsModel!.lastPage = addedGroupsModelnew.lastPage;
    }
    setState(() {
      isload = false;
      isloadmore = false;
    });
  }

  void searchdataOfGroups(String search) async {
    if (search == "") {
      getdataOfGroups();
    } else {
      setState(() {
        isload = true;
      });
      // addedGroupsModel = await resourceRepository.searchchatpersons(search);

      setState(() {
        isload = false;
      });
    }
  }

}

