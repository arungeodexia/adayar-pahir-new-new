import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ACI/Model/AddchatnewModel.dart';
import 'package:ACI/Model/GroupchatMembersModel.dart';
import 'package:ACI/Model/create_edit_profile_model.dart';
import 'package:ACI/data/api/repository/ChatRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/utils/Uploadchat.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:path_provider/path_provider.dart';

class ProfileView extends StatefulWidget {
  final String name;
  final String imgurl;
  final String groupid;
  final bool admin;
  final GroupchatMembersModel? groupchatMembersModel;

  ProfileView(this.name, this.imgurl, this.groupid, this.groupchatMembersModel, this.admin);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  CreateEditProfileModel? createEditProfileModel;
  static final ChatRepo resourceRepository = new ChatRepo();
  bool _isLoading = false;
  int chatListLength = 20;
  double _scrollPosition = 560;
  File? _image;
  bool _isImageAvailable = false;
  String fileName = "";
  File? imageFile;
  bool isLoading=false;
  bool isShowSticker=false;
  String imageUrl="";
  AddchatnewModel? addedGroupsModelnew;
  List<int> text = [1, 2, 3, 4];

  @override
  void initState() {
    super.initState();
  }

  void _handleSubmitted(String los) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.groupid)
        .update({
      'name': widget.name,
      'userImageUrl': imageUrl,
    });
  }

  Future<bool> onBackPress() async {
    if (imageFile==null) {
      imageUrl=widget.imgurl;
    }
    Navigator.pop(context, imageUrl);

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    globalcontext = context;
    return WillPopScope(
      onWillPop: onBackPress,
      child: new Scaffold(
        body: new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: 350.0,
              floating: false,
              pinned: true,
              flexibleSpace: new FlexibleSpaceBar(
                title: new Text(widget.name),
                background: GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: new Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      imageFile != null
                          ? Image.file(
                              imageFile!,
                              fit: BoxFit.cover,
                            )
                          : new Image.network(
                              widget.imgurl.toString(),
                              fit: BoxFit.cover,
                            ),
                    ],
                  ),
                ),
              ),
            ),
            new SliverList(
              delegate: new SliverChildListDelegate(<Widget>[
                new ListTile(
                  title: new Text("Mute notifications"),
                  trailing: new Switch(
                    value: false,
                    onChanged: null,
                    inactiveThumbColor: Theme.of(context).primaryColor,
                  ),
                ),
                new ListTile(title: new Text("Custom notifications")),
                new ListTile(
                  title: new Text("Encryption"),
                  subtitle: new Text(
                      "Message to this chat and calls sre secured with end-to-end encryption. Tap to verify"),
                  trailing: new Icon(
                    Icons.lock,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                new Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0)),
                new Text(
                  "    About and phone number",
                  style: new TextStyle(color: Theme.of(context).primaryColor),
                ),
                new ListTile(
                  title: new Text("Hey there! I am using Claritea"),
                  subtitle: new Text("15 may"),
                ),
                new Text(
                  "    Groups in common",
                  style: new TextStyle(color: Theme.of(context).primaryColor),
                ),
                // new ListView.builder(
                //     itemCount: 2,
                //     shrinkWrap: true,
                //     itemBuilder: (BuildContext ctxt, int index) {
                //       return
                //         new ListTile(
                //           title: new Text("Encryption"),
                //           leading: new CircleAvatar(
                //             backgroundImage: new NetworkImage(widget.imgurl),
                //           ),
                //
                //         );
                //
                //     }),
                widget.groupchatMembersModel!=null&&widget.groupchatMembersModel!.groupChatUsers!=null?Column(
                  children: [
                    for (var i in widget.groupchatMembersModel!.groupChatUsers!)
                      new ListTile(
                        leading: new CircleAvatar(
                          backgroundImage: new NetworkImage(i.profilePictureLink.toString()),
                        ),
                        title: new Text(i.firstName!),
                        subtitle: new Text(i.mobileNumber!),
                      ),
                  ],
                ):Container(),

                widget.admin? ListTile(
                  onTap: (){
                    CoolAlert.show(
                        context: context,
                        type: CoolAlertType.confirm,
                        text: "Do you want to Delete group?",
                        title: "Delete Group",
                        loopAnimation: true,
                        onConfirmBtnTap: (){

                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.groupid)
                              .delete().then((_)  {
                                FirebaseFirestore.instance
                                .collection('chatroom')
                                .doc(widget.groupid)
                                .delete().then((dtat) {
                                  Navigator.of(context).pop();
                                  Navigator.pop(context, "delete");
                            });

                          });

                        }
                    );

                  },
                  leading: IconButton(
                    onPressed: (){

                    },
                    icon: new Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                  title: new Text(
                    "Delete Group",
                    style: new TextStyle(color: Colors.red),
                  ),
                ):Container(),
                new ListTile(
                  leading: IconButton(
                    onPressed: (){

                    },
                    icon: new Icon(
                      Icons.thumb_down,
                      color: Colors.red,
                    ),
                  ),
                  title: new Text(
                    "Report spam",
                    style: new TextStyle(color: Colors.red),
                  ),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }

  Future getImage() async {
    // var image = await ImagePicker().getImage(source: ImageSource.gallery);

    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: AppColors.APP_BLUE,
              title: Text("Select the image to Upload",
                  style: TextStyle(color: Colors.white)),
              actions: <Widget>[
                MaterialButton(
                  child: Text(
                    "Camera",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text(
                    "Gallery",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));
    if (imageSource != null) {
      var file;
      file = await ImagePicker.platform.pickImage(source: imageSource);

      if (imageSource == ImageSource.camera) {
        //  file = await FlutterExifRotation.rotateAndSaveImage(path: file.path);

      }

      if (file != null) {
        File? croppedFile = await ImageCropper.cropImage(
            sourcePath: file.file,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: tr('chat'),
                toolbarColor: AppColors.APP_BLUE,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            iosUiSettings: IOSUiSettings(
              minimumAspectRatio: 1.0,
            ));
        var tempFileName = (new DateTime.now()).millisecondsSinceEpoch;
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path + "/" + tempFileName.toString() + ".jpg";
        File fileNew = File(tempPath);
        File? result = await FlutterImageCompress.compressAndGetFile(
            croppedFile!.absolute.path, tempPath,
            quality: 50);
        // File result = croppedFile;

        fileName = tempPath;
        //print("filePath from ImagePicker :==>" + fileName);
        if (croppedFile != null) {
          setState(() {
            _image = fileNew;
            _isImageAvailable = true;

            //Clear Edit Resource bytes
            // editResourceProfImage = "";
            // widget.editResourceDetail.profilePicture = "";
          });
        }
      }
    }

    if (_image != null) {
      imageFile = File(_image!.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        String los = await fileuploadchat(filePath: _image!.path);
        if (los != '') {
          imageUrl = los;
          _handleSubmitted(los);
        } else {}
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
