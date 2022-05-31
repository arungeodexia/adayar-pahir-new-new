import 'dart:convert';
import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ACI/Bloc/addresource/add_resouce_bloc.dart';
import 'package:ACI/Model/AddUpdateReviewModel.dart';
import 'package:ACI/Model/ResourceSearchNew.dart';
import 'package:ACI/Model/add_resource_model.dart';
import 'package:ACI/Model/resources.dart';
import 'package:ACI/Model/skill_item.dart';
import 'package:ACI/Screen/mydashboard.dart';
import 'package:ACI/data/api/repository/ResourceRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AddResorce extends StatefulWidget {
 final ResourceResults? editResourceDetail;

  const AddResorce({Key? key, this.editResourceDetail}) : super(key: key);

  @override
  _AddResorceState createState() => _AddResorceState();
}

class _AddResorceState extends State<AddResorce> {
  File _image = File("");
  bool _isImageAvailable = false;
  String fileName = "";

  var _addResourceKey = GlobalKey<FormState>();
  bool _currentBtnState = false;

   late Contact _contact;

  // final PhoneContactPicker _contactPicker = new PhoneContactPicker();

  late SkillItemModel skillItem;

  double submitRating = 5;

  String initFullNameVal = "",
      initMobileNoVal = "",
      initAlterMobileVal = "",
      initSkillNameVal = "",
      initEmailVal = "",
      initNotesVal = "",
      initCityNameVal = "",
      initStateVal = "",
      initReviewVal = "";

  double initRatingVal = 0.0;

  bool isFullNameChangeBtnState = false,
      isSkillChangeBtnState = false,
      isMobileNoChangeBtnState = false,
      isAlterMobChangeBtnState = false,
      isEmailChangeBtnState = false,
      isNotesChangeBtnState = false,
      isRatingChangeBtnState = false,
      isCityChangeBtnState = false,
      isStateChangeBtnState = false,
      isReviewChangeBtnState = false;
  static const platform =
      const MethodChannel('samples.flutter.dev/contactDetails');

  late String contactDetails;
  var splitArr;
  String editResourceProfImage = "null";

  dynamic _pickImageError;

  final ImagePicker _picker = ImagePicker();
  List<SkillItemModel> skillList = [];
  ResourceRepo repo = ResourceRepo();

  String dropdownValue = '';

  List<String> spinnerItems = [];

  @override
  void initState() {
    _fetchProfileData();
    if (widget != null && widget.editResourceDetail != null) {
      //print("widget.editResourceDetail.firstName: ${widget.editResourceDetail.firstName}");
      //appBloc.updateTitle('Update Resource');
      String lastName = (widget.editResourceDetail!.lastName != null)
          ? widget.editResourceDetail!.lastName!
          : "";
      fullNameInputController.text =
          widget.editResourceDetail!.firstName! + "" + lastName;
      skillInputController.text = widget.editResourceDetail!.skill!;
      mobileInputController.text = widget.editResourceDetail!.mobile!;
      emailInputController.text = widget.editResourceDetail!.email!;
      cityInputController.text = widget.editResourceDetail!.city!;
      stateInputController.text = widget.editResourceDetail!.state!;
      //notesInputController.text = widget.editResourceDetail!.notes;
      if (widget.editResourceDetail!.skillTags != null)
        notesInputController.text = widget.editResourceDetail!.skillTags!;
      submitRating = widget.editResourceDetail!.rating!.toDouble();

      editResourceProfImage = widget.editResourceDetail!.profilePicture.toString();

      if (editResourceProfImage != null && editResourceProfImage.isNotEmpty) {
        setState(() {
          editResourceProfImage = widget.editResourceDetail!.profilePicture.toString();
        });
      }

      String initLastName = (widget.editResourceDetail!.lastName! != null)
          ? widget.editResourceDetail!.lastName!
          : "";
      initFullNameVal = widget.editResourceDetail!.firstName! + "" + initLastName;
      initMobileNoVal = widget.editResourceDetail!.mobile!;
      initAlterMobileVal = "";
      initSkillNameVal = widget.editResourceDetail!.skill!;
      initRatingVal = widget.editResourceDetail!.rating!.toDouble();
      initEmailVal = widget.editResourceDetail!.email!;
      //initNotesVal = widget.editResourceDetail!.notes;
      initNotesVal = widget
          .editResourceDetail!.skillTags!; // Instead of Notes We are using skill
      if (globalReviewResponse != null &&
          globalReviewResponse!.reviews != null &&
          globalReviewResponse!.reviews![0] != null) {
        initRatingVal = globalReviewResponse!.reviews![0].rating!.toDouble();
        reviewsInputController.text = globalReviewResponse!.reviews![0].review!;
        initReviewVal = globalReviewResponse!.reviews![0].review!;
      }
      skillItem.skillName=widget.editResourceDetail!.skill!;
      skillItem.skillId=widget.editResourceDetail!.skillId!;

    }

    fullNameInputController.addListener(() {
      // print("fullNameInputController value: ${fullNameInputController.text}");
      setState(() {
        if (initFullNameVal != fullNameInputController.text.toString()) {
          isFullNameChangeBtnState = true;
        } else {
          isFullNameChangeBtnState = false;
        }
      });
    });

    skillInputController.addListener(() {
      //print("skillInputController value: ${skillInputController.text}");
      setState(() {
        if (initSkillNameVal != skillInputController.text.toString()) {
          isSkillChangeBtnState = true;
        } else {
          isSkillChangeBtnState = false;
        }
      });
    });

    cityInputController.addListener(() {
      // print("cityInputController value: ${cityInputController.text}");
      setState(() {
        if (initCityNameVal != cityInputController.text.toString()) {
          isCityChangeBtnState = true;
        } else {
          isCityChangeBtnState = false;
        }
      });
    });
    stateInputController.addListener(() {
      //print("stateInputController value: ${stateInputController.text}");
      setState(() {
        if (initStateVal != stateInputController.text.toString()) {
          isStateChangeBtnState = true;
        } else {
          isStateChangeBtnState = false;
        }
      });
    });

    mobileInputController.addListener(() {
      //print("mobileInputController value: ${mobileInputController.text}");
      setState(() {
        if (initMobileNoVal != mobileInputController.text.toString()) {
          isMobileNoChangeBtnState = true;
        } else {
          isMobileNoChangeBtnState = false;
        }
      });
    });

    alternateMobileInputController.addListener(() {
      //print("alternateMobileInputController value: ${alternateMobileInputController.text}");
      setState(() {
        if (initAlterMobileVal !=
            alternateMobileInputController.text.toString()) {
          isAlterMobChangeBtnState = true;
        } else {
          isAlterMobChangeBtnState = false;
        }
      });
    });

    emailInputController.addListener(() {
      //print("emailInputController value: ${emailInputController.text}");
      setState(() {
        // var email = emailInputController.text.trim().toString();
        // bool isValidEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
        // if(isValidEmail){

        if (initEmailVal != emailInputController.text.toString()) {
          isEmailChangeBtnState = true;
        } else {
          isEmailChangeBtnState = false;
        }
      });
    });

    notesInputController.addListener(() {
      // print("notesInputController value: ${notesInputController.text}");
      setState(() {
        if (initNotesVal != notesInputController.text.toString()) {
          isNotesChangeBtnState = true;
        } else {
          isNotesChangeBtnState = false;
        }
      });
    });

    reviewsInputController.addListener(() {
      //print("reviewsInputController value: ${reviewsInputController.text}");
      setState(() {
        if (initReviewVal != reviewsInputController.text.toString()) {
          isReviewChangeBtnState = true;
        } else {
          isReviewChangeBtnState = false;
        }
      });
    });
  }

  void sendFinalValue() {
    Resources addResourceModel = new Resources();
    addResourceModel.userId = globalUserId;
    //addResourceModel.id = globalUserId;
    addResourceModel.firstName = fullNameInputController.text.toString();
    addResourceModel.lastName = "";
    //createEditProfileModel.skill = "";
    //createEditProfileModel.skillId = 0;
    if (skillItem != null) {
      addResourceModel.skillId = skillItem.skillId;
      addResourceModel.skill = skillItem.skillName;
    } else {
      if (widget != null && widget.editResourceDetail != null) {
        //Update Resource details
        addResourceModel.skillId = widget.editResourceDetail!.skillId;
        addResourceModel.skill = widget.editResourceDetail!.skill;
        addResourceModel.isMyResource = widget.editResourceDetail!.isMyResource!;
      }
    }
    addResourceModel.mobile = mobileInputController.text
        .toString()
        .replaceAll(new RegExp("[^+0-9]"), "");
    try {
      if (addResourceModel.mobile.toString().contains("+", 0)) {
        addResourceModel.countryCode = addResourceModel.mobile!
            .substring(0, addResourceModel.mobile.toString().length - 10);
        addResourceModel.mobile = addResourceModel.mobile
            .toString()
            .substring(addResourceModel.mobile.toString().length - 10);
      } else {
        //addResourceModel.countryCode = "";
        addResourceModel.countryCode = globalCountryCode;
      }
    } on Exception catch (e) {
      // addResourceModel.countryCode = "";
      addResourceModel.countryCode = globalCountryCode;
    }
    //addResourceModel.countryCode = "+1";
    //addResourceModel.c = '+1';
    /*addResourceModel.alternateMobile =
        alternateMobileInputController.text.toString();*/
    addResourceModel.email = emailInputController.text.toString();
    addResourceModel.rating = submitRating.ceil();
    addResourceModel.notes = notesInputController.text.toString();
    addResourceModel.skillTags = notesInputController.text.toString();

    addResourceModel.id = "";
    addResourceModel.middleName = "";

    //  createEditProfileModel.notes = notesInputController.text.toString();
    // createEditProfileModel.profilePictureUrl = "";
    //addResourceModel.userStatus = "active";
    //print("filePath final:==>" + fileName);

    //city and state send
    addResourceModel.city = cityInputController.text.trim().toString();
    addResourceModel.state = stateInputController.text.trim().toString();

    //send picture in url
    try {
      if (widget.editResourceDetail!.profilePicture != null &&
          widget.editResourceDetail!.profilePicture != "")
        addResourceModel.profilePicture =
            widget.editResourceDetail!.profilePicture == null
                ? ''
                : widget.editResourceDetail!.profilePicture;
    } catch (e) {
      addResourceModel.profilePicture = null;
    }

    AddUpdateReviewModel addUpdateReviewModel = new AddUpdateReviewModel();
    addUpdateReviewModel.review = reviewsInputController.text.toString();
    addUpdateReviewModel.rating = submitRating.ceil();
    BlocProvider.of<AddResouceBloc>(context).add(AddResources(
      _image.path,
      addUpdateReviewModel,
      addResourceModel,
    ));
  }

  _fetchProfileData() async {
    skillItem = new SkillItemModel();
    prefs = await SharedPreferences.getInstance();
    String profiledata =
        (prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA) ?? "emp");

    final otpVerifyResponse = json.decode(profiledata);

    globalPhoneNo = otpVerifyResponse['mobile'];
    globalCountryCode = otpVerifyResponse['countryCode'];
    globalUserId = otpVerifyResponse['id'];
    fcm_key = prefs.getString(FCM_KEY) ?? "";

    initCityNameVal = cityInputController.text.trim().toString();
    initStateVal = stateInputController.text.trim().toString();
    isCityChangeBtnState = false;
    isStateChangeBtnState = false;
  }

  Future getImage() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Select the image source"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));
    try {
      final pickedFile = await _picker.getImage(
        source: imageSource!,
        imageQuality: 100,
      );

      // File? croppedFile = await ImageCropper.cropImage(
      //     sourcePath: pickedFile!.path,
      //     aspectRatioPresets: [
      //       CropAspectRatioPreset.square,
      //       CropAspectRatioPreset.ratio3x2,
      //       CropAspectRatioPreset.original,
      //       CropAspectRatioPreset.ratio4x3,
      //       CropAspectRatioPreset.ratio16x9
      //     ],
      //     androidUiSettings: AndroidUiSettings(
      //         toolbarTitle: 'Cropper',
      //         toolbarColor: Colors.deepOrange,
      //         toolbarWidgetColor: Colors.white,
      //         initAspectRatio: CropAspectRatioPreset.original,
      //         lockAspectRatio: false),
      //     iosUiSettings: IOSUiSettings(
      //       minimumAspectRatio: 1.0,
      //     ));

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _isImageAvailable = true;
        });
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  TextEditingController fullNameInputController = new TextEditingController();
  var tempfullName;
  TextEditingController skillInputController = new TextEditingController();
  var tempskill;
  TextEditingController mobileInputController = new TextEditingController();
  var tempmobile;
  TextEditingController alternateMobileInputController =
      new TextEditingController();
  var tempalternateMobile;
  TextEditingController emailInputController = new TextEditingController();
  var tempemail;
  TextEditingController notesInputController = new TextEditingController();
  var tempnotes;
  TextEditingController cityInputController = new TextEditingController();
  TextEditingController stateInputController = new TextEditingController();
  TextEditingController reviewsInputController = new TextEditingController();

  var emailFocusNode = new FocusNode();
  late SharedPreferences prefs;
  String fcm_key = "";
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to Close this page'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () =>exit(context),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    globalcontext = context;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
            title: Text(widget.editResourceDetail==null?"Add Resources":"Edit Resources"),
            centerTitle: true,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                exit(context);
                // Navigator.pushReplacementNamed(
                //     context, AppRoutes.APP_ROUTE_MY_DASHBOARD);
              },
            )),
        backgroundColor: AppColors.APP_LIGHT_GREY_10,
        body: Container(
          child: BlocListener<AddResouceBloc, AddResouceState>(
            listener: (context, state) {
              if (state is AddResouceSuccess) {
                CoolAlert.show(
                    context: context,
                    type: CoolAlertType.success,
                    text: widget.editResourceDetail==null?AppStrings.ADD_NEW_RESOURCE_DIAG_SUCCESS_CONTENT:AppStrings.UPDATE_RESOURCE_DIAG_SUCCESS_CONTENT,
                    title: "Success",
                    loopAnimation: true,
                    onConfirmBtnTap: () {
                      Navigator.of(context).pop();
                      exit(context);
                    });
              } else if (state is AddResouceFailure) {
                CoolAlert.show(
                    context: context,
                    type: CoolAlertType.error,
                    text: widget.editResourceDetail==null?AppStrings.ADD_NEW_RESOURCE_DIAG_FAILURE_CONTENT:AppStrings.UPDATE_RESOURCE_DIAG_FAILURE_CONTENT,
                    title: "Failure",
                    loopAnimation: true,
                    onConfirmBtnTap: () {
                      Navigator.of(context).pop();
                    });
              }
            },
            child: BlocBuilder<AddResouceBloc, AddResouceState>(
              builder: (context, state) {
                if (state is AddResouceLoading) {
                  return buildloading();
                } else if (state is SkillSuccess) {
                  return new ListView.builder(
                      itemCount: state.list.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return new ListTile(
                          onTap: () {
                            skillItem = state.list[index];
                            skillInputController.text = skillItem.skillName;
                            BlocProvider.of<AddResouceBloc>(context)
                                .add(SkillsSelected());
                          },
                          title: Text(
                            state.list[index].skillName,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: "OpenSans",
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      });
                } else {
                  return SingleChildScrollView(child: showForm(skillItem));
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void exit(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Mydashboard()),(Route<dynamic> route) => false,);
  }

  Widget buildloading() {
    return Container(
      height:
          MediaQuery.of(context).size.height - (AppBar().preferredSize.height),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void showCuperActionSheetWithThreeAction(String name, String emailId,
      String mobileNo1, String mobileNo2, String mobileNo3) {
    final action = CupertinoActionSheet(
      title: Text(
        name,
        style: TextStyle(fontSize: 30),
      ),
      message: Text(
        "Select one phone number ",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text(mobileNo1),
          isDefaultAction: true,
          onPressed: () {
            //print("Action 1 is been clicked:==>" + mobileNo1);
            setNamePhoneNo(name, mobileNo1, emailId);
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(mobileNo2),
          isDestructiveAction: true,
          onPressed: () {
            //print("Action 2 is been clicked:==>" + mobileNo2);
            setNamePhoneNo(name, mobileNo2, emailId);
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(mobileNo3),
          isDestructiveAction: true,
          onPressed: () {
            // print("Action 3 is been clicked:==>" + mobileNo3);
            setState(() {
              setNamePhoneNo(name, mobileNo3, emailId);
            });
            Navigator.pop(context);
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  void showCuperActionSheetWithFourAction(String name, String emailId,
      String mobileNo1, String mobileNo2, String mobileNo3, String mobileNo4) {
    final action = CupertinoActionSheet(
      title: Text(
        name,
        style: TextStyle(fontSize: 30),
      ),
      message: Text(
        "Select one phone number ",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text(mobileNo1),
          isDefaultAction: true,
          onPressed: () {
            // print("Action 1 is been clicked:==>" + mobileNo1);
            setNamePhoneNo(name, mobileNo1, emailId);
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(mobileNo2),
          isDefaultAction: true,
          onPressed: () {
            //print("Action 1 is been clicked:==>" + mobileNo2);
            setNamePhoneNo(name, mobileNo2, emailId);
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(mobileNo3),
          isDefaultAction: true,
          onPressed: () {
            //print("Action 1 is been clicked:==>" + mobileNo3);
            setNamePhoneNo(name, mobileNo3, emailId);
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(mobileNo4),
          isDefaultAction: true,
          onPressed: () {
            //print("Action 1 is been clicked:==>" + mobileNo4);
            setNamePhoneNo(name, mobileNo4, emailId);
            Navigator.pop(context);
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  void setNamePhoneNo(String name, mobileNo, String emailId) {
    setState(() {
      fullNameInputController.text = name;
      mobileInputController.text = mobileNo;
      emailInputController.text = emailId;
    });
  }

  Future<void> getContactDetails() async {
    try {
      contactDetails = await platform.invokeMethod('getContactFromNative');
      //print("Contatct Details flutter :==>" + contactDetails);
      var contatctSplitArr;
      contatctSplitArr = contactDetails.split("%");
      splitArr = contatctSplitArr[2].split(",");

      if (splitArr != null) {
        // print("splitArr .length :==>" + splitArr.length.toString());
        if (splitArr.length == 4 &&
            splitArr[0] != "" &&
            splitArr[1] != "" &&
            splitArr[2] != "" &&
            splitArr[3] != "") {
          showCuperActionSheetWithFourAction(
              contatctSplitArr[0],
              contatctSplitArr[1],
              splitArr[0],
              splitArr[1],
              splitArr[2],
              splitArr[3]); // Three No

        } else if (splitArr.length == 3 &&
            splitArr[0] != "" &&
            splitArr[1] != "" &&
            splitArr[2] != "") {
          showCuperActionSheetWithThreeAction(
              contatctSplitArr[0],
              contatctSplitArr[1],
              splitArr[0],
              splitArr[1],
              splitArr[2]); // Three No

        } else if (splitArr.length == 2 &&
            splitArr[0] != "" &&
            splitArr[1] != "") {
          showCuperActionSheetWithTwoAction(contatctSplitArr[0],
              contatctSplitArr[1], splitArr[0], splitArr[1]); // Two No
        } else if (splitArr.length == 1 && splitArr[0] != "") {
          setNamePhoneNo(
              contatctSplitArr[0], splitArr[0], contatctSplitArr[1]); //One No
        } else {
          showCuperActionSheetWithFourAction(
              contatctSplitArr[0],
              contatctSplitArr[1],
              splitArr[0],
              splitArr[1],
              splitArr[2],
              splitArr[3]); //More than 3
        }
      } else {
        setNamePhoneNo(contatctSplitArr[0], contatctSplitArr[1], "");
      }
    } on PlatformException catch (e) {
      contactDetails = "Failed to get Contact: '${e.message}'.";
    }
    //print("Contatct Details flutter :==>" + contactDetails);
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.contacts,
    ].request();
    print(statuses[Permission.location]);
  }

  void showCuperActionSheetWithTwoAction(
      String name, String emailId, String mobileNo1, String mobileNo2) {
    final action = CupertinoActionSheet(
      title: Text(
        name,
        style: TextStyle(fontSize: 30),
      ),
      message: Text(
        "Select one phone number ",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text(mobileNo1),
          isDefaultAction: true,
          onPressed: () {
            // print("Action 1 is been clicked:==>" + mobileNo1);
            setNamePhoneNo(name, mobileNo1, emailId);
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(mobileNo2),
          isDestructiveAction: true,
          onPressed: () {
            // print("Action 2 is been clicked:==>" + mobileNo2);
            setNamePhoneNo(name, mobileNo2, emailId);
            Navigator.pop(context);
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  Widget showForm(SkillItemModel skillItem) {
    return Column(
      children: <Widget>[
        //Form container
        Form(
          key: _addResourceKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //Image Picker and QR code image
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child: Stack(children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(right: 20, bottom: 3),
                            child: CircleAvatar(
                              backgroundImage: (editResourceProfImage != "null"&&!_isImageAvailable)
                                  ? NetworkImage(editResourceProfImage)
                                  : (!_isImageAvailable
                                      ? AssetImage("images/photo_avatar.png") as ImageProvider
                                      : FileImage(_image)),
                              radius: 40.0,
                              foregroundColor: AppColors.APP_WHITE,
                              backgroundColor: AppColors.APP_BLACK_10,
                            )),
                        Positioned.fill(
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(
                                Icons.camera_alt,
                                color: AppColors.APP_LIGHT_GREY,
                              )),
                        )
                      ]),
                      onTap: getImage,
                    ),
                    FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0)),
                        textColor: AppColors.APP_WHITE,
                        padding: EdgeInsets.all(0.0),
                        onPressed: () async {
                          if (!Platform.isAndroid) {

                          } else {
                            PermissionStatus permissionStatus =
                                await _getContactPermission();
                            if (permissionStatus == PermissionStatus.granted) {
                              getContactDetails();
                            } else {
                              _handleInvalidPermissions(permissionStatus);
                            }

                            // cs.Contact result = await Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ContactListPage()));
                            // print(result);
                            // fullNameInputController.text = result.displayName;
                            // mobileInputController.text =
                            //     result.phones.first != null
                            //         ? result.phones.first.value
                            //         : "";

                          }
                        },
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            Image.asset('images/phonebook.png',
                                width: 60, height: 60),
                            SizedBox(height: 10),
                            Text(
                              "Add from contacts",
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ))
                  ],
                ),
                //FullName
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppStrings.ADD_NEW_RESOURCE_FULLNAME_LABEL,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.length == 0) {
                              return ('Please enter name');
                            }
                            return null;
                          },
                          textCapitalization: TextCapitalization.words,
                          controller: fullNameInputController,
                          decoration: InputDecoration(
                              hintText:
                                  AppStrings.ADD_NEW_RESOURCE_FULLNAME_HINT,
                              hintStyle:
                                  TextStyle(color: AppColors.APP_LIGHT_GREY_10),
                              border: OutlineInputBorder(),
                              fillColor: AppColors.APP_WHITE,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.APP_LIGHT_BLUE_10)),
                              enabled: true),
                        )
                      ],
                    )),
                // Skill
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: GestureDetector(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            AppStrings.ADD_NEW_RESOURCE_SKILL_LABEL,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          AbsorbPointer(
                            child: TextFormField(
                              validator: (value) {
                                if (value!.length == 0) {
                                  return ('Please Select skill');
                                }
                                return null;
                              },
                              enabled: true,
                              controller: skillInputController,
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.arrow_forward_ios,
                                      size: 13,
                                      color: AppColors.APP_LIGHT_BLUE_20),
                                  hintText: skillItem == null
                                      ? ""
                                      : AppStrings.ADD_NEW_RESOURCE_SKILL_HINT,
                                  hintStyle: TextStyle(
                                      color: AppColors.APP_LIGHT_GREY_10),
                                  border: OutlineInputBorder(),
                                  fillColor: AppColors.APP_WHITE,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.APP_LIGHT_BLUE_10)),
                                  enabled: false),
                              onTap: () {
                              },
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        BlocProvider.of<AddResouceBloc>(context)
                            .add(GetSkills());
                      },
                    )),
                // City
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppStrings.ADD_NEW_RESOURCE_CITY_LABEL,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: cityInputController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: AppStrings.ADD_NEW_RESOURCE_CITY_HINT,
                              hintStyle:
                                  TextStyle(color: AppColors.APP_LIGHT_GREY_10),
                              border: OutlineInputBorder(),
                              fillColor: AppColors.APP_WHITE,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.APP_LIGHT_BLUE_10)),
                              enabled: true),
                        )
                      ],
                    )),
                //State
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppStrings.ADD_NEW_RESOURCE_STATE_LABEL,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: stateInputController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: AppStrings.ADD_NEW_RESOURCE_STATE_HINT,
                              hintStyle:
                                  TextStyle(color: AppColors.APP_LIGHT_GREY_10),
                              border: OutlineInputBorder(),
                              fillColor: AppColors.APP_WHITE,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.APP_LIGHT_BLUE_10)),
                              enabled: true),
                        )
                      ],
                    )),
                //Mobile Number
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppStrings.ADD_NEW_RESOURCE_MOBILENUMBER_LABEL,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.length == 0) {
                              return ('Please enter phonenumber');
                            }
                            return null;
                          },
                          controller: mobileInputController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              hintText:
                                  AppStrings.ADD_NEW_RESOURCE_MOBILENUMBER_HINT,
                              hintStyle:
                                  TextStyle(color: AppColors.APP_LIGHT_GREY_10),
                              border: OutlineInputBorder(),
                              fillColor: AppColors.APP_WHITE,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.APP_LIGHT_BLUE_10)),
                              enabled: true),
                        )
                      ],
                    )),
                //Alternate Number
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppStrings.ADD_NEW_RESOURCE_ALTERNATE_NUMBER_LABEL,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: alternateMobileInputController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              hintText: AppStrings
                                  .ADD_NEW_RESOURCE_ALTERNATE_NUMBER_HINT,
                              hintStyle:
                                  TextStyle(color: AppColors.APP_LIGHT_GREY_10),
                              border: OutlineInputBorder(),
                              fillColor: AppColors.APP_WHITE,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.APP_LIGHT_BLUE_10)),
                              enabled: true),
                        )
                      ],
                    )),
                //Email
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppStrings.ADD_NEW_RESOURCE_EMAIL_LABEL,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        // TextField(
                        //   controller: emailInputController,
                        //   keyboardType: TextInputType.emailAddress,
                        //   decoration: InputDecoration(
                        //       hintText: AppStrings.ADD_NEW_RESOURCE_EMAIL_HINT,
                        //       hintStyle:
                        //           TextStyle(color: AppColors.APP_LIGHT_GREY_10),
                        //       border: OutlineInputBorder(),
                        //       fillColor: AppColors.APP_WHITE,
                        //       filled: true,
                        //       enabledBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //               color: AppColors.APP_LIGHT_BLUE_10)),
                        //       enabled: true),
                        // )

                        TextFormField(
                          validator: (value) {
                            var email = value;
                            bool isValidEmail = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(email!);

                            // if (email.isNotEmpty && !isValidEmail) {
                            //   emailFocusNode.requestFocus();
                            //   return ('Please enter valid email');
                            // }
                            emailFocusNode.unfocus();
                            return null;
                          },
                          controller: emailInputController,
                          focusNode: emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: AppStrings.ADD_NEW_RESOURCE_EMAIL_HINT,
                              hintStyle:
                                  TextStyle(color: AppColors.APP_LIGHT_GREY_10),
                              border: OutlineInputBorder(),
                              fillColor: AppColors.APP_WHITE,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.APP_LIGHT_BLUE_10)),
                              enabled: true),
                        ),
                      ],
                    )),

                //Rating bar
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          AppStrings.ADD_NEW_RESOURCE_RATING_LABEL,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        RatingBar.builder(
                          initialRating: submitRating,
                          itemSize: 25.0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            submitRating = rating;

                            setState(() {
                              if (initRatingVal != rating) {
                                isRatingChangeBtnState = true;
                              } else {
                                isRatingChangeBtnState = false;
                              }
                            });
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "      ",
                          textAlign: TextAlign.left,
                        ),
                      ],
                    )),
                //Notes or More Skills
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          //AppStrings.ADD_NEW_RESOURCE_NOTES_LABEL,
                          AppStrings.MORE_SKILL_LABEL,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: notesInputController,
                          maxLines: 10,
                          minLines: 4,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                              // hintText: AppStrings.ADD_NEW_RESOURCE_NOTES_HINT,
                              hintText: AppStrings.MORE_SKILL_HINT,
                              hintStyle:
                                  TextStyle(color: AppColors.APP_LIGHT_GREY_10),
                              border: OutlineInputBorder(),
                              fillColor: AppColors.APP_WHITE,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.APP_LIGHT_BLUE_10)),
                              enabled: true),
                        ),
                      ],
                    )),

                //Review label
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          //AppStrings.ADD_NEW_RESOURCE_NOTES_LABEL,
                          AppStrings.REVIEWS_LABEL,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: reviewsInputController,
                          maxLines: 10,
                          minLines: 8,
                          maxLength: 1200,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                              hintText: AppStrings.REVIEW_HINT,
                              hintStyle:
                                  TextStyle(color: AppColors.APP_LIGHT_GREY_10),
                              border: OutlineInputBorder(),
                              fillColor: AppColors.APP_WHITE,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.APP_LIGHT_BLUE_10)),
                              enabled: true),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
        //Bottom button panel
        Container(
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
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              side: BorderSide(color: AppColors.APP_GREEN)),
                          color: ((_isImageAvailable ||
                                  isFullNameChangeBtnState ||
                                  isSkillChangeBtnState ||
                                  isCityChangeBtnState ||
                                  isStateChangeBtnState ||
                                  isMobileNoChangeBtnState ||
                                  isAlterMobChangeBtnState ||
                                  isEmailChangeBtnState ||
                                  isNotesChangeBtnState ||
                                  isRatingChangeBtnState ||
                                  isReviewChangeBtnState))
                              ? AppColors.APP_BLUE
                              : AppColors.APP_LIGHT_GREY_20,
                          textColor: AppColors.APP_WHITE,
                          padding: EdgeInsets.all(8.0),
                          onPressed: () {
                            if (_addResourceKey.currentState!.validate()) {
                              if ((_isImageAvailable ||
                                  isFullNameChangeBtnState ||
                                  isSkillChangeBtnState ||
                                  isCityChangeBtnState ||
                                  isStateChangeBtnState ||
                                  isMobileNoChangeBtnState ||
                                  isAlterMobChangeBtnState ||
                                  isEmailChangeBtnState ||
                                  isNotesChangeBtnState ||
                                  isRatingChangeBtnState ||
                                  isReviewChangeBtnState)) {
                                // var email = emailInputController.text.trim().toString();
                                // bool isValidEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
                                // if(email.isNotEmpty) {
                                //   if (isValidEmail) {
                                //     _sumbitDataToServer();
                                //   } else {
                                //     showToastMessage(AppStrings.INVALID_EMAIL_ID);
                                //   }
                                //  }else {
                                //   // showToastMessage(AppStrings.ENTER_EMAIL_ID);
                                //    _sumbitDataToServer();
                                // }
                                sendFinalValue();
                              }
                            } else {
                              print('validation error');
                            }
                            /*Navigator.pushReplacementNamed(
                                    context, AppRoutes.APP_ROUTE_MY_DASHBOARD);*/
                            //  _sumbitDataToServer();
                          },
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                (widget != null &&
                                        widget.editResourceDetail != null)
                                    ? AppStrings.UPDATE_RESOURCE_SAVE_BT_LBL
                                    : AppStrings.ADD_NEW_RESOURCE_SAVE_BT_LBL,
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              )),
                        ))),
                flex: 1,
              ),
            ],
          )),
        ),
      ],
    );
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.contacts,
      ].request();
      print(statuses[Permission.location]);

      return statuses[Permission.contacts] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }
}
