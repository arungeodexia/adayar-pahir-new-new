import 'package:ACI/Screen/login_init_view.dart';
import 'package:ACI/Screen/mydashboard.dart';
import 'package:ACI/utils/background.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Language extends StatefulWidget {
  final String from;
  Language({Key? key, required this.from}) : super(key: key);

  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  bool language=true;


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


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: AppColors.APP_BLUE, //or set color with: Color(0xFF0000FF)
    ));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: AppColors.APP_BLUE, //or set color with: Color(0xFF0000FF)
    ));
    return WillPopScope(
      onWillPop: () async {
        if(widget.from != "1"){
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Mydashboard()),
                (Route<dynamic> route) => false,
          );
        }else{
          SystemNavigator.pop(); //for Android from flutter/services.dart
        }

        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: widget.from=="0"?AppBar(
            centerTitle: true,
            title: Text(tr("language")),
          ):AppBar(
            centerTitle: true,
            title: Text(tr("appname")),
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height-80,
              child: Background(
                child: Stack(
                  children: [
                    // Positioned(
                    //   top: 0,
                    //   left: 0,
                    //   child: Image.asset(
                    //     "assets/images/wear_mask.png",
                    //   ),
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(bottom: 10),
                    //   child: Align(
                    //     alignment: Alignment.bottomLeft,
                    //     child: Image.asset(
                    //       "images/logo.png",
                    //     ),
                    //   ),
                    // ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 40.0, horizontal: 8.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: CupertinoButton(
                          onPressed: () => {},
                          borderRadius: new BorderRadius.circular(20),
                          child: new Text(
                            tr("lang"),
                            textAlign: TextAlign.center,
                            style: new TextStyle(color: AppColors.APP_BLUE),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 150),
                            child: Image.asset('images/language.jpg',)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Divider(height: 5,thickness: 1,),
                                ListTile(
                                  onTap: ()async{
                                    setState(() {
                                      language=true;
                                    });
                                    await context.setLocale(Locale('en'));
                                  },
                                  title: Text('English',style: TextStyle(color: AppColors.APP_BLUE),),
                                  trailing:Transform.scale(
                                    scale: 1.7,
                                    child: Checkbox(
                                      value: language,
                                      activeColor: AppColors.APP_BLUE,
                                      shape: CircleBorder(),
                                      tristate: false,
                                      splashRadius: 10,
                                      side: MaterialStateBorderSide.resolveWith(
                                            (states) => BorderSide(width: 1.0, color: AppColors.APP_BLUE),
                                      ),
                                      onChanged: (bool? value) async {
                                        setState(() {
                                          language=true;
                                        });
                                        await context.setLocale(Locale('en'));
                                      },
                                    ),
                                  ),
                                  // trailing: InkWell(
                                  //   onTap: () async{
                                  //     setState(() {
                                  //       language=true;
                                  //     });
                                  //     await context.setLocale(Locale('en'));
                                  //   },
                                  //   child: Container(
                                  //     decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.APP_WHITE,
                                  //                               border: Border.all(color: Colors.grey),
                                  //
                                  //     ),
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(10.0),
                                  //       child: language
                                  //           ? Icon(
                                  //         Icons.check,
                                  //         size: 15,
                                  //         color: Colors.white,
                                  //       )
                                  //           : Icon(
                                  //         Icons.check_box_outline_blank,
                                  //         size: 20,
                                  //         color: AppColors.APP_BLUE,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                                Divider(height: 5,thickness: 1,),
                                ListTile(
                                  onTap: ()async{
                                    language=false;
                                    setState(() {

                                    });
                                      await context.setLocale(Locale('ta'));

                                  },
                                  title: Text('தமிழ்',style: TextStyle(color: AppColors.APP_BLUE),),
                                  trailing:Transform.scale(
                                    scale: 1.7,
                                    child: Checkbox(
                                      value: !language,
                                      activeColor: AppColors.APP_BLUE,
                                      shape: CircleBorder(),
                                      tristate: false,
                                      splashRadius: 20,
                                        side: MaterialStateBorderSide.resolveWith(
                                              (states) => BorderSide(width: 1.0, color: AppColors.APP_BLUE),
                                        ),
                                      onChanged: (bool? value) async {
                                        language=false;
                                        setState(() {

                                        });

                                        await context.setLocale(Locale('ta'));
                                      },
                                    ),
                                  ),

                                  // trailing: InkWell(
                                  //   onTap: () async{
                                  //     language=false;
                                  //     setState(() {
                                  //
                                  //     });
                                  //
                                  //     await context.setLocale(Locale('ta'));
                                  //   },
                                  //   child: Container(
                                  //     decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.APP_BLUE),
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(10.0),
                                  //       child: !language
                                  //           ? Icon(
                                  //         Icons.check,
                                  //         size: 15,
                                  //         color: Colors.white,
                                  //       )
                                  //           : Icon(
                                  //         Icons.check_box_outline_blank,
                                  //         size: 15,
                                  //         color: AppColors.APP_BLUE,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                                // CheckboxListTile(
                                //   checkColor: Colors.white,
                                //   shape: CircleBorder(),
                                //   value: language,
                                //   onChanged: (val)async {
                                //   language=true;
                                //   setState(() {
                                //   });
                                //   await context.setLocale(Locale('en'));
                                // },
                                //   title:  Text('English',style: TextStyle(color: AppColors.APP_BLUE),),),
                                // Divider(height: 5,thickness: 1,),
                                // CheckboxListTile(
                                //   checkColor: Colors.white,
                                //   shape: CircleBorder(),
                                //   value: !language, onChanged: (val)async {
                                //   language=false;
                                //   setState(() {
                                //
                                //   });
                                //
                                //   await context.setLocale(Locale('ta'));
                                // },
                                //   title:  Text('தமிழ்',style: TextStyle(color: AppColors.APP_BLUE),),),
                                Divider(height: 5,thickness: 1,),

                              ],
                            ),
                          ),
                        ),

                      ],
                    ),

                    // Center(
                    //   child: Column(
                    //     children: [
                    //       CupertinoButton(
                    //         onPressed: () async{
                    //               await context.setLocale(Locale('en'));
                    //         },
                    //         child:  Center(
                    //           child: Text('English',style: TextStyle(color: AppColors.APP_BLUE),),
                    //         ),
                    //       ),
                    //       CupertinoButton(
                    //         onPressed: () async{
                    //               await context.setLocale(Locale('ta'));
                    //         },
                    //         child:  Center(
                    //           child: Text('Arabic',style: TextStyle(color: AppColors.APP_BLUE),),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    widget.from=="0"?Container():Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 30),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          width: double.infinity,

                          child: new RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                                side: BorderSide(color: AppColors.APP_GREEN)),
                            textColor: AppColors.APP_WHITE,
                            padding: EdgeInsets.all(8.0),
                            splashColor: Colors.grey,
                            color: AppColors.APP_BLUE,
                            onPressed: ()  {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginInitView()),
                              );

                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new
                              Text(
                                tr("getstarted"),
                                textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
