import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ACI/Bloc/login/login_bloc.dart';
import 'package:ACI/Bloc/user/user_repository.dart';
import 'package:ACI/Screen/otp_verify_form.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;


class SigninView extends StatefulWidget {

  const SigninView();

  @override
  State<StatefulWidget> createState() => SigninState();
}

class SigninState extends State<SigninView> {
  TextEditingController textEditingController = new TextEditingController();
  TextEditingController dialingCodeController = new TextEditingController();
  TextEditingController mobilecontroller = new TextEditingController();

  SigninState();

  bool _currentBtnState = false;
  bool language = false;

  @override
  void initState() {
    textEditingController.text = "India";
    dialingCodeController.text = "+91";


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
    globalcontext = context;
    _launchURL() async {
      const url =
          "https://dlaggtcll95tc.cloudfront.net/app/acipolicy.html";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OTPVerifyForm(
                    mobileNo: mobilecontroller.text,
                    countryCode: dialingCodeController.text)),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(tr("appname")),
              backgroundColor: AppColors.APP_BLUE,
              centerTitle: true,
              /* automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                return LoginInitView(
                  userRepository: widget.userRepository,
                );
                Navigator.pushReplacementNamed(
                    context, AppRoutes.APP_ROUTE_LOGIN_INIT);
                // Navigator.pop(context, false);
              },
            )*/
            ),
            backgroundColor: AppColors.APP_BLUE,
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height-85,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: AppColors.APP_WHITE,
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                            top: 10, left: 20, right: 20, bottom: 20),
                        padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.phone_android,
                                color: AppColors.APP_LIGHT_BLUE_20,
                                size: 75,
                              )),
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                tr("phverify"),
                                style: TextStyle(
                                    fontSize: language?17:20,
                                    fontFamily: "OpenSans",
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.APP_BLACK),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              )),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              tr("pahirsms"),
                              style: TextStyle(
                                color: AppColors.APP_BLACK,
                                fontFamily: "OpenSans",
                                fontSize: language?13:12,
                              ),
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Form(
                            child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  TextFormField(
                                    readOnly: true,
                                    style: TextStyle(
                                        fontSize: 18, fontFamily: "OpenSans"),
                                    controller: textEditingController,
                                    decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 13,
                                        color: AppColors.APP_LIGHT_BLUE_20,
                                      ),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0.0)),
                                        borderSide: const BorderSide(
                                            color: Colors.teal, width: 5.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.APP_LIGHT_BLUE,
                                            width: 1.0),
                                      ),
                                      contentPadding: EdgeInsets.all(16.0),
                                      focusColor: AppColors.APP_LIGHT_BLUE,
                                    ),
                                    onTap: () {
                                      showCountryPicker(
                                        context: context,
                                        //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                                        exclude: <String>['KN', 'MF'],
                                        //Optional. Shows phone code before the country name.
                                        showPhoneCode: true,
                                        onSelect: (Country country) {
                                          print(
                                              'Select country: ${country.displayName}');
                                          setState(() {
                                            textEditingController.text =
                                                country.name;
                                            dialingCodeController.text =
                                                "+" + country.phoneCode;
                                          });
                                        },
                                        // Optional. Sets the theme for the country list picker.
                                        countryListTheme: CountryListThemeData(
                                          // Optional. Sets the border radius for the bottomsheet.
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(40.0),
                                            topRight: Radius.circular(40.0),
                                          ),
                                          // Optional. Styles the search field.
                                          inputDecoration: InputDecoration(
                                            labelText: 'Search',
                                            hintText: 'Start typing to search',
                                            prefixIcon: const Icon(Icons.search),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: const Color(0xFF8C98A8)
                                                    .withOpacity(0.2),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      new Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              readOnly: true,
                                              controller: dialingCodeController,
                                              onChanged: (value) {},
                                              onEditingComplete: () {},
                                              keyboardType: TextInputType.phone,
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontFamily: "OpenSans"),
                                              decoration: InputDecoration(
                                                hintText: AppStrings
                                                    .SIGNUP_MOBILE_ENTER_CC_TF_HINT,
                                                border: const OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(0.0)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColors
                                                          .APP_LIGHT_BLUE,
                                                      width: 1.0),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.all(10.0),
                                                focusColor: Colors.teal,
                                              ),
                                              onTap: () {
                                                //_selectCountry(context, Country.US);
                                              },
                                            ),
                                          )),
                                      new Flexible(
                                        flex: 3,
                                        child: TextFormField(
                                            validator: (value) {
                                              // if (value.length < 10) {
                                              //   return 'Please enter phone number';
                                              // }

                                              if (value!.length == 0) {
                                                Fluttertoast.showToast(
                                                    msg:tr(''),
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white);
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.phone,
                                            maxLength: 15,
                                            inputFormatters: [
                                              new FilteringTextInputFormatter.allow(
                                                  RegExp("[0-9]")),
                                            ],
                                            controller: mobilecontroller,
                                            //maxLength: 11,
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontFamily: "OpenSans"),
                                            onChanged: (value) {
                                              if (mobilecontroller.text.length >=
                                                  8) {
                                                _currentBtnState = true;
                                              } else {
                                                _currentBtnState = false;
                                              }
                                              setState(() {});
                                            },
                                            onEditingComplete: () {
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                            },
                                            decoration: InputDecoration(
                                              counterText: "",
                                              hintText: AppStrings
                                                  .SIGNUP_MOBILE_ENTER_PHNO_TF_HINT,
                                              hintStyle: TextStyle(
                                                  color: AppColors
                                                      .APP_LIGHT_GREY_40),
                                              border: const OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(0.0))),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        AppColors.APP_LIGHT_BLUE,
                                                    width: 1.0),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(10.0),
                                              focusColor: Colors.teal,
                                            )),
                                      )
                                    ],
                                  )
                                ]),
                          ),

                          Visibility(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                              tr("agree"),
                                style: TextStyle(
                                    color: AppColors.APP_BLACK,
                                    fontFamily: "OpenSans"),
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            visible: true,
                          ),
                          Visibility(
                            child: GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 8.0,
                                      bottom: 8.0,
                                      right: 8.0,
                                      top: 4.0),
                                  /* used deprected url launcher*/

                                  child: Center(
                                    child: Text(
                                    tr("terms"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColors.APP_LIGHT_BLUE,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  print("launch");
                                  _launchURL();
                                }),
                            visible: true,
                          ),
                        ]),
                      ),
                      flex: 8,
                    ),
                    Expanded(
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

                                      color: (_currentBtnState)
                                          ? AppColors.APP_BLUE
                                          : AppColors.APP_LIGHT_GREY_20,
                                      //color: AppColors.APP_GREEN,
                                      textColor: AppColors.APP_WHITE,
                                      padding: EdgeInsets.all(8.0),
                                      child: state is OTPVerifyLoading?Container(
                                        margin: EdgeInsets.all(5),
                                        child: CircularProgressIndicator(
                                          color: AppColors.APP_WHITE,
                                        ),
                                      ): Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Text(
                                          tr("agreecontinue"),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      onPressed: () async {
                                        if (_currentBtnState) {
                                          if(state is OTPVerifyLoading){
                                            // Fluttertoast.showToast(msg: "Please Enter Mobile Number");
                                          }else{
                                            BlocProvider.of<LoginBloc>(context).add(
                                                Login(
                                                    mobilecontroller.text
                                                        .toString(),
                                                    dialingCodeController.text.toString()));
                                          }
                                        } else {
                                          Fluttertoast.showToast(msg: tr('nonumber'));
                                        }
                                      },
                                    )),
                              ),
                              flex: 1,
                            ),
                          ],
                        )),
                      ),
                      flex: 2,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
