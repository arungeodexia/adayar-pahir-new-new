import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ACI/Bloc/login/signin_mobile_view.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';

final List<String> imgList = [
  "https://d2c56lckh61bcl.cloudfront.net/live/aci_splash1.jpg",
  "https://d2c56lckh61bcl.cloudfront.net/live/aci_splash2.jpg",
  "https://d2c56lckh61bcl.cloudfront.net/live/aci_splash3.jpg",
  'https://d2c56lckh61bcl.cloudfront.net/live/aci_splash4.jpg'
];

class LoginInitView extends StatefulWidget {

  LoginInitView({Key? key});

  @override
  State<StatefulWidget> createState() => LoginInitViewState();
}

class LoginInitViewState extends State<LoginInitView> {

  int _current = 0;
  bool _currentBtnState = false;
  bool language = false;



  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }
  @override
  void initState() {
    super.initState();
    new Future.delayed(const Duration(seconds: 0), () {

      String lang = context.locale.languageCode;
      if(lang=="en"){
        language=true;
      }else{
        language=false;
      }
      setState(() {

      });
    });

  }

  //endregion
  @override
  Widget build(BuildContext context) {
    globalcontext = context;





final Column slider1 = Column(
        children: [
          CarouselSlider(
            items: imageSliders,
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.map((url) {
              int index = imgList.indexOf(url);
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                    ? Colors.white
                    : Color.fromRGBO(0, 0, 0, 0.4),

                  // color: _current == index
                  //    ? Color.fromRGBO(255, 255, 255, 1.0)
                  //    : Color.fromRGBO(255, 255, 255, 0.4)),
                ),
              );
            }).toList(),
          ),
        ]
      );



//     final Column slider = Column(children: [
//       CarouselSlider(
//         viewportFraction: 1.0,
// //        aspectRatio: 1.0,
//         autoPlay: true,
//         enlargeCenterPage: true,
        

//         items: imgList.map(
//               (url) {
//             return Container(
//               margin: EdgeInsets.only(left: 20, right: 20),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.all(Radius.circular(1.0)),
//                 child: Image.network(url, fit: BoxFit.cover),
//               ),
//             );
//           },
//         ).toList(),
//       ),
//       SizedBox(
//         height: 30,
//       ),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: map<Widget>(imgList, (index, url) {
//           return Container(
//             width: 8.0,
//             height: 8.0,
//             margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: _current == index
//                     ? Color.fromRGBO(255, 255, 255, 1.0)
//                     : Color.fromRGBO(255, 255, 255, 0.4)),
//           );
//         }),
//       )
//     ]);




    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: AppColors.APP_BLUE //or set color with: Color(0xFF0000FF)
    ));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: AppColors.APP_BLUE, //or set color with: Color(0xFF0000FF)
    ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.APP_BLUE,
      ),

      body:  Stack(
          children: <Widget>[
            Container(
              color: AppColors.APP_BLUE,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: language?1:2,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child:
                        Text(
                          tr("appname"),
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: AppColors.APP_WHITE),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 0,),
                  Expanded(
                    flex: language?2:3,
                    child: Padding(
                      padding: EdgeInsets.all(7),
                      child: Text(
                        tr("signuptext"),
                        style:
                        TextStyle(color: AppColors.APP_WHITE, fontSize: 17),
                        softWrap: true,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: language?3:5,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                      child: slider1,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 110.0,
                right: 22.0,
                left: 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          'Powered by PAHIR',
                          style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        )),
                  ],
                )),
            Positioned(
                bottom: 115.0,
                right: 18.0,
                left: 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Ⓡ',
                          style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: 10),
                        )),
                  ],
                )),
            Positioned(
              height: 100,
              bottom: 0.0,
              right: 0.0,
              left: 0.0,
              child: Container(
                  height: 80,
                  color: Colors.white,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 20, top: 20),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                        side: BorderSide(color: AppColors.APP_BLUE)),
                    highlightElevation: 8.0,
                    onHighlightChanged: (valueChanged) {
                      setState(() => _currentBtnState = !_currentBtnState);
                    },
                    color: (_currentBtnState)
                        ? AppColors.APP_BLUE
                        : AppColors.APP_GREEN,
                    // color: AppColors.APP_GREEN,
                    textColor: AppColors.APP_WHITE,
                    padding: EdgeInsets.all(8.0),
                    onPressed: ()  {

                    Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SigninView()),
                    (Route<dynamic> route) => false,
                    );
                  },
                    child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          tr("signup"),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  )),
            )
          ],
        ),
      );
  }
}


final List<Widget> imageSliders = imgList.map((item) => Container(
  child: Container(
    margin: EdgeInsets.all(2.0),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(3.0)),
      child: Stack(
        children: <Widget>[
          Image.network(item, fit: BoxFit.cover, width: 1250.0,height: 800.0),
          // Positioned(
          //   bottom: 0.0,
          //   left: 0.0,
          //   right: 0.0,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         // colors: [
          //         //   Color.fromARGB(200, 0, 0, 0),
          //         //   Color.fromARGB(0, 0, 0, 0)
          //         // ],
          //          colors: [
          //            Color.fromARGB(255, 255, 255, 0),
          //            Color.fromARGB(255, 255, 255, 0)
          //            //AppColors.AppColors.APP_BLUE
          //         ],

          //         begin: Alignment.bottomCenter,
          //         end: Alignment.topCenter,
          //       ),
          //     ),
          //     padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          //     // child: Text(
          //     //   'No. ${imgList.indexOf(item)} image',
          //     //   style: TextStyle(
          //     //     color: Colors.white,
          //     //     fontSize: 20.0,r
          //     //     fontWeight: FontWeight.bold,
          //     //   ),
          //     // ),
          //   ),
          // ),
        ],
      )
    ),

  ),
)).toList();
