import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ACI/Model/ChannelModel.dart';
import 'package:ACI/data/api/repository/ResourceRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/calls_messages_services.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckBoxInListView extends StatefulWidget {
  final String orgid;
 final List<int> channelsids;

   CheckBoxInListView({Key? key, required this.orgid, required this.channelsids}) : super(key: key);

  @override
  _CheckBoxInListViewState createState() => _CheckBoxInListViewState();
}

class _CheckBoxInListViewState extends State<CheckBoxInListView> {
  List<String> _texts = [
    "InduceSmile.com",
    "Flutter.io",
    "google.com",
    "youtube.com",
    "yahoo.com",
    "gmail.com"
  ];
  ResourceRepo resourceRepo = ResourceRepo();

  late List<bool> _isChecked;
   List<int> _channels=[];
  ChannelModel channelModel = ChannelModel();

  @override
  void initState() {
    super.initState();
    getdata();
  }

  void getdata() async {
    channelModel =await resourceRepo.getchannel(widget.orgid);
    setState(() {

    });
    _isChecked = List<bool>.filled(channelModel.orgChannels!.length, false);
    for(int i=0;i<channelModel.orgChannels!.length;i++){
      for(int j=0;j<widget.channelsids.length;j++){
        print(j);
        if (channelModel.orgChannels![i].orgChannelId==widget.channelsids[j]) {
          _isChecked[i]=true;
        }
      }
    }
    setState(() {

    });
  }

  Future<bool> backPressed() async {
    // onWillPop();
    _channels.clear();
    channelsname.clear();
    for(int i=0;i<_isChecked.length;i++){
      if(_isChecked[i]){
        _channels.add(channelModel.orgChannels![i].orgChannelId!);
        channelsname.add(channelModel.orgChannels![i].orgChannelName!);
      }
    }
    print(_channels);
    Navigator.pop(context, _channels);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: backPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Select Channel",
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              backPressed();
            },
          ),
        ),
        backgroundColor: AppColors.APP_LIGHT_GREY_10,
        body: channelModel.orgChannels==null?Center(child: CircularProgressIndicator()):ListView.builder(
          itemCount: channelModel.orgChannels!.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              title: Text(
                channelModel.orgChannels![index].orgChannelName!,
                style: ktextstyle,
              ),
              value: _isChecked[index],
              onChanged: (val) {
                print(val!);
                // if(val){
                //   _channels.add(channelModel.orgChannels![index].orgChannelId!);
                // }else{
                //   for(int i=0;i<_channels.length;i++){
                //     if (_channels[i]==channelModel.orgChannels![index].orgChannelId) {
                //       _channels.removeAt(i);
                //     }
                //   }
                // }
                print(_channels);
                setState(
                  () {
                    _isChecked[index] = val;
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
