import 'dart:io';

import 'package:ACI/utils/values/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';

class PictureView extends StatefulWidget {
  const PictureView({Key? key, required this.file}) : super(key: key);
  final File file;

  @override
  State<PictureView> createState() => _PictureViewState();
}

class _PictureViewState extends State<PictureView> {
  late File newFile;

  @override
  void initState() {
    super.initState();
    newFile = widget.file;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: (){
          Navigator.pop(context, newFile);

        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () async {
                File? croppedFile = await ImageCropper.cropImage(
                    sourcePath: widget.file.path,
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
                String tempPath =
                    tempDir.path + "/" + tempFileName.toString() + ".jpg";
                File fileNew = File(tempPath);
                File? result = await FlutterImageCompress.compressAndGetFile(
                    croppedFile!.absolute.path, tempPath,
                    quality: 50);
                // File result = croppedFile;

                //print("filePath from ImagePicker :==>" + fileName);
                if (croppedFile != null) {
                  setState(() {
                    newFile = fileNew;
                    //Clear Edit Resource bytes
                    // editResourceProfImage = "";
                    // widget.editResourceDetail.profilePicture = "";
                  });
                }
              },
              icon: Icon(Icons.crop_rotate, size: 28)),
          // IconButton(
          //     onPressed: () {},
          //     icon: Icon(Icons.emoji_emotions_outlined, size: 28)),
          // IconButton(onPressed: () {}, icon: Icon(Icons.title, size: 28)),
          // IconButton(onPressed: () {}, icon: Icon(Icons.edit, size: 28))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            newFile != null
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 150,
                    child: Image.file(
                      newFile,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(),
            // Positioned(
            //   bottom: 0.0,
            //   left: 0.0,
            //   child: Container(
            //       color: Colors.black,
            //       width: MediaQuery.of(context).size.width,
            //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            //       child: CircleAvatar(
            //         radius: 27,
            //               backgroundColor: Colors.tealAccent[700],
            //         child: Icon(
            //           Icons.check,
            //           color: Colors.white,
            //           size: 27,
            //         ),
            //       )
            //
            //       // TextFormField(
            //       //   style: TextStyle(
            //       //     color: Colors.white,
            //       //     fontSize: 17,
            //       //   ),
            //       //   maxLines: 6,
            //       //   minLines: 1,
            //       //   decoration: InputDecoration(
            //       //     prefixIcon: Icon(
            //       //       Icons.add_photo_alternate,
            //       //       color: Colors.white,
            //       //       size: 27,
            //       //     ),
            //       //     suffixIcon:
            //       //     CircleAvatar(
            //       //       radius: 27,
            //       //       backgroundColor: Colors.tealAccent[700],
            //       //       child: Icon(
            //       //         Icons.check,
            //       //         color: Colors.white,
            //       //         size: 27,
            //       //       ),
            //       //     ),
            //       //     hintText: "Add caption!",
            //       //     hintStyle: TextStyle(
            //       //       color: Colors.white,
            //       //       fontSize: 17,
            //       //     ),
            //       //     border: InputBorder.none,
            //       //   ),
            //       // ),
            //       ),
            // ),
          ],
        ),
      ),
    );
  }
}
