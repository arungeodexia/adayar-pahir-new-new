import 'dart:async';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ACI/Bloc/login/login_bloc.dart';
import 'package:ACI/Screen/edit_profile_view.dart';
import 'package:ACI/Screen/mydashboard.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    globalcontext = context;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: PinCodeVerificationScreen(
          "+8801376221100"), // a random number, please don't call xD
    );
  }
}

class PinCodeVerificationScreen extends StatefulWidget {
  final String? phoneNumber;

  PinCodeVerificationScreen(this.phoneNumber);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    globalcontext = context;
    return Scaffold(
      backgroundColor: AppColors.APP_LIGHT_BLUE_20,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(""),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  tr("phverify"),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: tr("etcode"),
                      children: [
                        TextSpan(
                            text: "${widget.phoneNumber}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: true,
                      obscuringCharacter: '*',
                      obscuringWidget: FlutterLogo(
                        size: 24,
                      ),
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "I'm from validator";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        print("Completed");
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  TextButton(
                      onPressed: () => snackBar("OTP resend!!"),
                      child: Text(
                        "RESEND",
                        style: TextStyle(
                            color: Color(0xFF91D3B3),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ))
                ],
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                margin:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      formKey.currentState!.validate();
                      // conditions for validating
                      if (currentText.length != 6 || currentText != "123456") {
                        errorController!.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() => hasError = true);
                      } else {
                        setState(
                              () {
                            hasError = false;
                            snackBar("OTP Verified!!");
                          },
                        );
                      }
                    },
                    child: Center(
                        child: Text(
                          "VERIFY".toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(-1, 2),
                          blurRadius: 5)
                    ]),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: TextButton(
                        child: Text("Clear"),
                        onPressed: () {
                          textEditingController.clear();
                        },
                      )),
                  Flexible(
                      child: TextButton(
                        child: Text("Set Text"),
                        onPressed: () {
                          setState(() {
                            textEditingController.text = "123456";
                          });
                        },
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


class OTPVerifyForm extends StatefulWidget {
  final mobileNo;
  final countryCode;

  const OTPVerifyForm({
    required this.mobileNo,
    required this.countryCode,
  }) : super();

  @override
  State<OTPVerifyForm> createState() =>
      _OTPVerifyFormState(this.mobileNo, this.countryCode);
}

class _OTPVerifyFormState extends State<OTPVerifyForm> {
  String fcm_key = "";

  final _otpTokenController = TextEditingController();
  bool isOtpChangeBtnState = false;
  StreamController<ErrorAnimationType>? errorController;

  int pinLength = 6;
  bool hasError = false;
  bool isOtpFilled = false;
  String errorText = "";
  bool isResendOtpAllowed = false;

  // FocusNode? otpFocusNode;

  int _timeRemaining = 30;
  String _timeRemainingText = "0:30";
  Timer? _timer;
  bool _currentBtnState = false;

  final countryCode = "";
  final mobileNo = "";

  _OTPVerifyFormState(mobileNo, countryCode);

  void _getTime() {
    setState(() {
      _timeRemaining == 0 ? _timeRemaining = 0 : _timeRemaining--;
      _timeRemaining == 0
          ? isResendOtpAllowed = true
          : isResendOtpAllowed = false;
      int seconds = _timeRemaining % 60;
      int minutes = (_timeRemaining / 60).floor();
      _timeRemainingText = minutes.toString() +
          ":" +
          (seconds < 10 ? "0" + seconds.toString() : seconds.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    // otpFocusNode!.dispose();
    _timer!.cancel();
    errorController!.close();

  }

  @override
  initState() {
    errorController = StreamController<ErrorAnimationType>();

    // otpFocusNode = FocusNode();
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

    _otpTokenController.addListener(() {
      print("_otpTokenController value: ${_otpTokenController.text}");
      print("triggered");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_otpTokenController.text.length!=6) {
      // FocusScope.of(context).requestFocus(otpFocusNode);
    }

    _onVerifyButtonPressed() {
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is OTPVerifySuccess) {
          Fluttertoast.showToast(msg: "OTP Verified");
          if (state.response==1) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Mydashboard()),
                  (Route<dynamic> route) => false,
            );
          }  else{
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => EditProfileView()),
                  (Route<dynamic> route) => false,
            );

          }

        } else if (state is OTPVerifyFailure) {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              text: "Access Token Error",
              title: "Verification Failed",
              loopAnimation: true,
              onConfirmBtnTap: (){
                Navigator.of(context).pop();
                _otpTokenController.clear();
                isOtpFilled = false;
                isOtpChangeBtnState = false;
                errorText="";
              }
          );


        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                title: Text(AppStrings.APP_NAME),
                backgroundColor: AppColors.APP_BLUE,
                centerTitle: true,
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )),
            backgroundColor: AppColors.APP_BLUE,
            body: Container(
                child: Column(
              children: <Widget>[
                Flexible(
                  child: Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              constraints: BoxConstraints(
                                  minWidth: MediaQuery.of(context).size.width),
                              decoration: BoxDecoration(
                                  color: AppColors.APP_WHITE,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 20.0, bottom: 20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            child: Icon(
                                              Icons.check,
                                            ),
                                            backgroundColor:
                                                AppColors.APP_LIGHT_BLUE_20,
                                            foregroundColor:
                                                AppColors.APP_WHITE,
                                            radius: 25,
                                          )),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            8.0, 15.0, 8.0, 8.0),
                                        child: Text(
                                          widget.countryCode +
                                              "  " +
                                              widget.mobileNo,
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.APP_BLACK_10),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            25.0, 8.0, 25.0, 8.0),
                                        child: Text(
                                          tr("otptxt") +
                                             " "+ widget.countryCode +
                                              "  " +
                                              widget.mobileNo,
                                          style: TextStyle(
                                              color: AppColors.APP_BLACK_10,
                                              height: 1.5),
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 30),
                                child: PinCodeTextField(
                                  appContext: context,
                                  inputFormatters: [
                                    new FilteringTextInputFormatter.allow(
                                        RegExp("[0-9]"))
                                  ],
                                  pastedTextStyle: TextStyle(
                                    color: Colors.green.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  length: 6,
                                  // obscureText: false,
                                  // obscuringCharacter: '*',
                                  // obscuringWidget: FlutterLogo(
                                  //   size: 24,
                                  // ),
                                  // blinkWhenObscuring: false,
                                  animationType: AnimationType.fade,
                                  validator: (v) {
                                    if (v!.length < 3) {
                                      return "Enter an valid OTP";
                                    } else {
                                      return null;
                                    }
                                  },
                                  pinTheme: PinTheme(
                                    disabledColor: AppColors.APP_LIGHT_BLUE_20,
                                    errorBorderColor: AppColors.APP_LIGHT_BLUE_20,
                                    inactiveFillColor: AppColors.APP_WHITE,
                                    shape: PinCodeFieldShape.circle,
                                    borderRadius: BorderRadius.circular(5),
                                    fieldHeight: 50,
                                    fieldWidth: 40,
                                    inactiveColor: AppColors.APP_LIGHT_BLUE_20,
                                    activeColor: AppColors.APP_LIGHT_BLUE_20,
                                    selectedColor: AppColors.APP_LIGHT_BLUE_20,
                                    selectedFillColor: AppColors.APP_LIGHT_BLUE_20,
                                    activeFillColor: AppColors.APP_LIGHT_BLUE_20,
                                  ),
                                  cursorColor: Colors.white,
                                  animationDuration: Duration(milliseconds: 300),
                                  enableActiveFill: true,
                                  errorAnimationController: errorController,
                                  controller: _otpTokenController,
                                  keyboardType: TextInputType.number,
                                  textStyle: TextStyle(color: Colors.white),
                                  boxShadows: [
                                    BoxShadow(
                                      offset: Offset(0, 1),
                                      color: Colors.black12,
                                      blurRadius: 10,
                                    )
                                  ],
                                  onCompleted: (v) {
                                    print("Completed");
                                    BlocProvider.of<LoginBloc>(context).add(OTPVerify(widget.mobileNo,
                                                    widget.countryCode, _otpTokenController.text.toString()));
                                                isOtpChangeBtnState = true;
                                  },
                                  // onTap: () {
                                  //   print("Pressed");
                                  // },
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                    });
                                  },
                                  beforeTextPaste: (text) {
                                    print("Allowing to paste $text");
                                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                    return true;
                                  },
                                ),),
                                      // PinCodeTextField(
                                      //   focusNode: otpFocusNode,
                                      //   autofocus: true,
                                      //   controller: _otpTokenController,
                                      //   hideCharacter: false,
                                      //   highlight: true,
                                      //   highlightColor: Colors.blue,
                                      //   defaultBorderColor: Colors.black,
                                      //   hasTextBorderColor: Colors.green,
                                      //   maxLength: pinLength,
                                      //   hasError: hasError,
                                      //   onTextChanged: (text) {
                                      //     print(text.length);
                                      //
                                      //
                                      //     if (text.length == 6 ) {
                                      //       if (state is OTPVerifyLoading) {
                                      //
                                      //       }  else{
                                      //         print("clicked");
                                      //         BlocProvider.of<LoginBloc>(context).add(OTPVerify(widget.mobileNo,
                                      //             widget.countryCode, text.toString()));
                                      //         isOtpChangeBtnState = true;
                                      //         FocusScope.of(context).unfocus();
                                      //       }
                                      //     } else {
                                      //       isOtpChangeBtnState = false;
                                      //     }
                                      //
                                      //     // setState(() {
                                      //     //   hasError = false;
                                      //     //   if (text.length < 6) {
                                      //     //     isOtpFilled = false;
                                      //     //     //errorText = "Please enter otp.";
                                      //     //     errorText =
                                      //     //         "Please enter Access Code.";
                                      //     //   } else {
                                      //     //     isOtpFilled = true;
                                      //     //   }
                                      //     // });
                                      //   },
                                      //   onDone: (text) {
                                      //     hasError = false;
                                      //     isOtpFilled = true;
                                      //     },
                                      //   pinBoxWidth: 40,
                                      //   pinBoxHeight: 55,
                                      //   wrapAlignment: WrapAlignment.center,
                                      //   pinBoxDecoration:
                                      //       ProvidedPinBoxDecoration
                                      //           .underlinedPinBoxDecoration,
                                      //   pinTextStyle: TextStyle(fontSize: 30.0),
                                      //   pinTextAnimatedSwitcherTransition:
                                      //       ProvidedPinBoxTextAnimation
                                      //           .scalingTransition,
                                      //   pinTextAnimatedSwitcherDuration:
                                      //       Duration(milliseconds: 300),
                                      // ),
                                      Visibility(
                                        child: Text(
                                          errorText,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        visible: hasError,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                        tr("digits"),
                                          style: TextStyle(
                                              color:
                                                  AppColors.APP_LIGHT_GREY_20,
                                              fontWeight: FontWeight.bold),
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      GestureDetector(
                                        child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                30.0, 15.0, 30.0, 10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Tab(
                                                      icon: Icon(
                                                          Icons.messenger,
                                                          color: isResendOtpAllowed
                                                              ? AppColors
                                                                  .APP_LIGHT_BLUE
                                                              : AppColors
                                                                  .APP_LIGHT_GREY_10),
                                                    ),
                                                    SizedBox(width: 15),
                                                    Text(

                                                    tr("resendsms"),
                                                      style: TextStyle(
                                                          color: isResendOtpAllowed
                                                              ? AppColors
                                                                  .APP_LIGHT_BLUE
                                                              : AppColors
                                                                  .APP_LIGHT_GREY_10,
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  '$_timeRemainingText',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            )),
                                        onTap: () {
                                          if (isResendOtpAllowed) {
                                            BlocProvider.of<LoginBloc>(context).add(
                                                Login(
                                                    widget.mobileNo,
                                                    widget.countryCode));
                                          }
                                        },
                                      ),
                                      /*GestureDetector(
                                    child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            30.0, 10.0, 30.0, 15.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.call,
                                                    color: isResendOtpAllowed
                                                        ? AppColors.APP_LIGHT_BLUE
                                                        : AppColors
                                                            .APP_LIGHT_GREY_10),
                                                SizedBox(width: 15),
                                                Text(
                                                  AppStrings
                                                      .SIGNUP_OTP_ENTER_CALLME,
                                                  style: TextStyle(
                                                      color: isResendOtpAllowed
                                                          ? AppColors
                                                              .APP_LIGHT_BLUE
                                                          : AppColors
                                                              .APP_LIGHT_GREY_10),
                                                )
                                              ],
                                            ),
                                            Text('$_timeRemainingText'),
                                          ],
                                        )),
                                    onTap: () {
                                      if (isResendOtpAllowed) {
                                        _resendOtp(true);
                                      }
                                    },
                                  ),*/
                                      GestureDetector(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                            tr("wrongnumber"),
                                              style: TextStyle(
                                                  color: AppColors.APP_BLUE,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          })
                                    ],
                                  )),
                            )
                          ],
                        ),
                      )),
                  flex: 8,
                ),
                Flexible(
                  child: Container(
                    color: AppColors.APP_WHITE,
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                          child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: RaisedButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(8.0),
                                        side: BorderSide(
                                            color: AppColors.APP_GREEN)),
//                              highlightElevation: 8.0,
//                              onHighlightChanged: (valueChanged) {
//                                setState(() => _currentBtnState = !_currentBtnState);
//
//                              },
                                    color: (isOtpChangeBtnState)
                                        ? AppColors.APP_BLUE
                                        : AppColors.APP_LIGHT_GREY_20,
                                    // color: AppColors.APP_GREEN,
                                    textColor: AppColors.APP_WHITE,
                                    padding: EdgeInsets.all(8.0),
                                    /*onPressed: state is! LoginLoading
                                            ? _onVerifyButtonPressed
                                            : null,*/
                                    onPressed: (){
                                      if (isOtpFilled) {
                                        if (state is OTPVerifyLoading) {

                                        }  else{
                                          print("clicked");
                                          BlocProvider.of<LoginBloc>(context).add(OTPVerify(widget.mobileNo,
                                              widget.countryCode, _otpTokenController.text.toString()));
                                        }

                                      } else {
                                        setState(() {
                                          hasError = true;
                                          errorText = "Pls Enter Otp";
                                        });
                                      }
                                    },
                                    child: state is OTPVerifyLoading?Container(
                                      margin: EdgeInsets.all(5),
                                      child: CircularProgressIndicator(
                                        
                                      ),
                                    ):Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Text(
                                          tr('verify'),
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ))),
                          flex: 1,
                        ),
                      ],
                    )),
                  ),
                  flex: 2,
                )
              ],
            )),
          );
        },
      ),
    );
  }
}

Future<String> getVersionNumber() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return "version:${packageInfo.version}";
}
