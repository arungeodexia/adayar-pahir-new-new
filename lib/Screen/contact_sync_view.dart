import 'dart:convert';
import 'dart:io' show HttpHeaders, Platform;
import 'dart:math';
import 'package:contacts_service/contacts_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:ACI/Model/phone_contact_model.dart';
import 'package:ACI/Screen/mydashboard.dart';
import 'package:ACI/data/api/repository/api_intercepter.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ContactSyncView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ContactSyncState();
}

class ContactSyncState extends State<ContactSyncView> {
  bool isAppReadingContacts = false;
  static const MethodChannel _channel = const MethodChannel('app_settings');
  List<Contact> _contacts = <Contact>[];
  List<CustomContact> _uiCustomContacts = <CustomContact>[];
  List<CustomContact> _allContacts = <CustomContact>[];
  List<CustomContact> contactsFiltered = <CustomContact>[];
  bool _isLoading = false;
  final String reloadLabel = 'Reload!';
  final String fireLabel = 'Fire in the hole!';

  bool _isSelectedContactsView = false;
  String floatingButtonLabel = 'syncing';
  late Color floatingButtonColor;
  late IconData icon;

  bool selectall = false;
  TextEditingController searchController = new TextEditingController();
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);
  getContactsFromMobile() async {
    try {
      var status = await Permission.contacts.status;
      if (status.isGranted) {
        refreshContacts();
      } else if (status.isDenied) {
        if (await Permission.contacts.request().isGranted) {
          refreshContacts();
        }
        Map<Permission, PermissionStatus> statuses = await [
          Permission.contacts,
        ].request();
        print(statuses[Permission.contacts]);
        throw new PlatformException(
            code: "PERMISSION_DENIED",
            message: "Access to contact denied",
            details: null);

      } else {
        openAppSettings();
      }
    } on PlatformException catch (err) {
      openAppSettings();
    } catch (err) {
      // other types of Exceptions
    }

  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.contacts,
      ].request();

      return statuses[Permission.contacts] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) async {
    print(permissionStatus);
    if (permissionStatus == PermissionStatus.denied) {
      // Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Enable Contact permission');
      if (await Permission.contacts.request().isGranted) {
        getContactsFromMobile();
      }
      Map<Permission, PermissionStatus> statuses = await [
        Permission.contacts,
      ].request();

      print(statuses[Permission.contacts]);

      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to contact denied",
          details: null);
    } else {
      //Navigator.pop(context);
      if (await Permission.contacts.isPermanentlyDenied) {
        // The user opted to never again see the permission request dialog for this
        // app. The only way to change the permission's status now is to let the
        // user manually enable it in the system settings.
        openAppSettings();
      }
      handleToastMsgDialog(
          "Allow contact permission : Settings --> ACI(Contact Permission)");
    }
  }

  /// Future async method call to open app specific settings screen.
  static Future<void> openAppSettings() async {
    _channel.invokeMethod('app_settings');
  }

  @override
  initState() {
    super.initState();
    getContactsFromMobile();
    searchController.addListener(() {
      filterContacts();
    });
  }

  @override
  dispose() {
    super.dispose();
    searchController.dispose();
  }

  Future<bool> onWillPop() async {
    _goDashboard();
    return false;
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

    bool isSearching = searchController.text.isNotEmpty;

    return new WillPopScope(
        onWillPop: () => onWillPop(),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                title: Text(AppStrings.CONTACT_SYNC_TITLE),
                backgroundColor: AppColors.APP_BLUE,
                centerTitle: true,
                actions: [
                  // data: ThemeData(
                  //   primarySwatch: Colors.blue,
                  //   unselectedWidgetColor: Colors.red, // Your color
                  // ),
                  Checkbox(
                      activeColor: Colors.green,
                      hoverColor: Colors.white,
                      value: selectall,
                      onChanged: (bool? value) {
                        setState(() {
                          if (selectall) {
                            selectall = false;
                            _uiCustomContacts = _allContacts;

                            for (int i = 0; i < _allContacts.length; i++) {
                              _allContacts[i].isChecked = false;
                            }
                          } else {
                            selectall = true;
                            _allContacts = _allContacts;

                            for (int i = 0; i < _allContacts.length; i++) {
                              _allContacts[i].isChecked = true;
                            }
                          }
                        });
                      })
                ],
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    //Navigator.pop(context);
                    _goDashboard();
                  },
                ),
                automaticallyImplyLeading: false),
            floatingActionButton: new FloatingActionButton.extended(
              backgroundColor: AppColors.APP_BLUE,
              onPressed: _onSubmit,
              icon: Icon(Icons.contacts),
              label: Text(floatingButtonLabel),
            ),
            body: contactUploadbuildLoading(
                AppStrings.WELCOME_UPDATE_CONTACT_MSG, isSearching)));
  }

  void _restateFloatingButton(String label, IconData icon, Color color) {
    floatingButtonLabel = label;
    icon = icon;
    floatingButtonColor = color;
  }

  void _onSubmit() async {
    if (floatingButtonLabel == 'Sync  contacts') {
      List<CustomContact> _uiCustomContacts1 = <CustomContact>[];
      setState(() {
        _uiCustomContacts1 =
            _allContacts.where((contact) => contact.isChecked == true).toList();
      });
      List<PhoneContactModel> phoneContactList = <PhoneContactModel>[];

      for (var i = 0; i < _uiCustomContacts1.length; i++) {
        for (final Item phone
            in _uiCustomContacts1[i].contact!.phones!.toList()) {
          PhoneContactModel phoneContactModel = PhoneContactModel();

          if (phone != null && phone.value != null) {
            String phoneNumber =
                phone.value!.replaceAll(new RegExp("[^+0-9]"), "");

            if (phoneNumber.contains("+", 0) && phoneNumber.length > 10) {
              phoneContactModel.countryCode =
                  phoneNumber.substring(0, phoneNumber.length - 10);
              phoneContactModel.mobileNumber =
                  phoneNumber.substring(phoneNumber.length - 10);
            } else {
              phoneContactModel.countryCode = "";
              phoneContactModel.mobileNumber = phoneNumber;
            }
          }
          if (phoneContactModel.mobileNumber.length < 10) break;
          phoneContactList.add(phoneContactModel);
        }
      }
      // profileBloc.add(UploadPhoneBookEvent(phoneContactList));
      if (phoneContactList.length != 0) {
        setState(() {
          _isLoading = true;
          floatingButtonLabel = 'Syncing...';
        });
        var hur = await uploadContactsnew(phoneContactList);
        setState(() {
          _isLoading = false;
          floatingButtonLabel = 'Sync  contacts';
        });
        print(hur);
        if (hur.toString() == '200') {
          Widget okButton = FlatButton(
            child: Text("OK"),
            onPressed: () async {
              Navigator.of(context).pop();
              _goDashboard();
            },
          );

          showGeneralDialog(
              barrierDismissible: false,
              barrierColor: Colors.black.withOpacity(0.5),
              transitionBuilder: (context, a1, a2, widget) {
                return Transform.scale(
                  scale: a1.value,
                  child: Opacity(
                    opacity: a1.value,
                    child: AlertDialog(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      title: Text('Updated Contact(s)'),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: 2.0,
                            height: 5.0,
                          ),
                          Text(
                            'Selected contact(s) updated in ACI',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          Container(
                            width: 2.0,
                            height: 5.0,
                          ),
                        ],
                      ),
                      actions: [okButton],
                    ),
                  ),
                );
              },
              transitionDuration: Duration(milliseconds: 200),
              barrierLabel: '',
              context: context,
              pageBuilder: (context, animation1, animation2) {
                return Container();
              });
        } else {}
        // Fluttertoast.showToast(msg: 'contacts synced successfully');
      } else {
        Fluttertoast.showToast(msg: 'Please Select contacts to sync');
      }
    } else {
      Fluttertoast.showToast(msg: 'Sync on progress');
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

  Widget _buildListTile(CustomContact c, List<Item> list) {
    try {
      print(list[0].value.toString());
      if (!list[0].value.toString().contains('*') &&
          !list[0].value.toString().contains('#') &&
          list[0].value.toString().length > 8) {
        return ListTile(
          leading:
              /* (c.contact.avatar != null)
          ? CircleAvatar(backgroundImage: MemoryImage(c.contact.avatar))
          :*/
              CircleAvatar(
            backgroundColor:
                Colors.primaries[Random().nextInt(Colors.primaries.length)],
            child: Text(
                (c.contact!.displayName![0] +
                    c.contact!.displayName![1].toUpperCase()),
                style: TextStyle(color: Colors.white)),
          ),
          title: Text(c.contact!.displayName ?? ""),
          subtitle: list.length >= 1 && list[0].value != null
              ? Text(list[0].value!)
              : Text(''),
          trailing: Checkbox(
              activeColor: Colors.green,
              value: c.isChecked,
              onChanged: (bool? value) async {
                setState(() {
                  c.isChecked = value!;

                  int count = 0;
                  int total = _allContacts.length;
                  for (int i = 0; i < _allContacts.length; i++) {
                    if (_allContacts[i].isChecked) {
                      count = count + 1;
                    }
                  }

                  if (count == total) {
                    setState(() {
                      selectall = true;
                    });
                  } else {
                    setState(() {
                      selectall = false;
                    });
                  }
                });
              }),
        );
      } else {
        return Container();
      }
    } catch (e) {
      return Container();
    }
  }

  Widget contactUploadbuildLoading(String message, bool isSearching) {
    return !_isLoading
        ? Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      labelText: 'Search',
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Theme.of(context).primaryColor)),
                      prefixIcon: Icon(Icons.search,
                          color: Theme.of(context).primaryColor)),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _allContacts.length,
                  itemBuilder: (BuildContext context, int index) {
                    CustomContact _contact = _allContacts[index];
                    var _phonesList = _contact.contact!.phones!.toList();

                    return _buildListTile(_contact, _phonesList);
                  },
                ),
              )
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );

    return Container(
      height:
          MediaQuery.of(context).size.height - (AppBar().preferredSize.height),
      child: Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Center(
              child: new SizedBox(
                height: 50.0,
                width: 50.0,
                child: CircularProgressIndicator(),
              ),
            ),
            SizedBox(height: 6),
            Padding(
              padding: EdgeInsets.all(5.0),
              // child: Text( isAppReadingContacts ? AppStrings.WELCOME_UPDATE_CONTACT_MSG : AppStrings.LOADING_MSG,
              child: Text(message,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Roboto',
                    color: new Color(0xFF000000),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  refreshContacts() async {
    setState(() {
      _isLoading = true;
      floatingButtonLabel = 'Sync  contacts';
    });
    var contacts = await ContactsService.getContacts();
    _populateContacts(contacts);
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  filterContacts() {
    if (searchController.text.toString().length == 0) {
      print("Second text field: ${searchController.text}");
      setState(() {
        _allContacts = _uiCustomContacts;
      });
    } else {
      List<CustomContact> _contacts = [];
      _contacts.addAll(_uiCustomContacts);
      if (searchController.text.isNotEmpty) {
        _contacts.retainWhere((contact) {
          String searchTerm = searchController.text.toLowerCase();
          String searchTermFlatten = flattenPhoneNumber(searchTerm);
          String contactName = contact.contact!.displayName!.toLowerCase();
          bool nameMatches = contactName.contains(searchTerm);
          if (nameMatches == true) {
            return true;
          }

          if (searchTermFlatten.isEmpty) {
            return false;
          }

          var phone = contact.contact!.phones!.firstWhere((phn) {
            String phnFlattened = flattenPhoneNumber(phn.value!);
            return phnFlattened.contains(searchTermFlatten);
          });

          return phone != null;
        });
      }
      setState(() {
        _allContacts = _contacts;
      });
    }
  }

  void _populateContacts(Iterable<Contact> contacts) {
    _contacts = contacts.where((item) => item.displayName != null).toList();
    _contacts.sort((a, b) => a.displayName!.compareTo(b.displayName!));
    _allContacts =
        _contacts.map((contact) => CustomContact(contact: contact)).toList();
    setState(() {
      _uiCustomContacts = _allContacts;
      _isLoading = false;
    });
  }

  void handleToastMsgDialog(String message) {
    //Navigator.pop(context); //pop dialog
    _goDashboard();
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.APP_BLUE,
        textColor: AppColors.APP_WHITE,
        fontSize: 16.0);
  }
}

uploadContactsnew(List<PhoneContactModel> phoneContactList) async {
  String jsonArray =
      jsonEncode(phoneContactList.map((e) => e.toJson()).toList());

  //  final stopwatch = Stopwatch()..start();
  // var startTimeNow = new DateTime.now();
  // print(new DateFormat("H:m:s").format(startTimeNow));
  // showToastMessage("UploadContacts startTimeNow Now :==>"+startTimeNow.toString());

  // for(int arrIndx = 0;arrIndx < phoneContactList.length;arrIndx++){
  //  showToastMessage("Uploading contact value:==> "+"Country code: "+phoneContactList[arrIndx].countryCode+"Mobile no :==>"+phoneContactList[arrIndx].mobileNumber);
  // }
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);

  final response = await client.post(
      Uri.parse('${AppStrings.BASE_URL}api/v1/user/${globalUserId}/contacts'),

      body: jsonArray);

  //   var endTimeNow = new DateTime.now();
  //     print(new DateFormat("H:m:s").format(endTimeNow));
  // showToastMessage("UploadContacts EndTime Now :==>"+endTimeNow.toString());

  //  showToastMessage("statusCode :==>"+response.statusCode.toString());

  // print('API executed in : ${stopwatch.elapsed}');

  // showToastMessage("UploadContacts API execution time :==>"+stopwatch.elapsed.toString());

  return response.statusCode;
}

class CustomContact {
  final Contact? contact;
  bool isChecked;

  CustomContact({
    this.contact,
    this.isChecked = false,
  });
}
