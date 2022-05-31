import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ACI/Model/create_edit_profile_model.dart';
import 'package:ACI/data/api/repository/ProfileRepo.dart';
import 'package:http/http.dart' as http;

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileUpdate) {
      yield ProfileLoading();
      ProfileRepo profileRepo = ProfileRepo();
      http.Response? response = await profileRepo.createProfile(event.path,
          createEditProfileModel: event.createEditProfileModel);
      if (response == null) {
        yield Profileupdatefailure();
      }
      if (response!.statusCode == 200) {
        yield Profileupdatesuccess();
      } else {
        yield Profileupdatefailure();
      }
    }else if(event is Profiledata){
      yield ProfileLoading();
      ProfileRepo profileRepo = ProfileRepo();
      http.Response? response = await profileRepo.getProfile();
      if (response == null) {
        yield Profileupdatefailure();
      }
      if (response!.statusCode == 200) {
        try{
          CreateEditProfileModel createEditProfileModel=CreateEditProfileModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
          yield Profiledatasuccess(createEditProfileModel);
        }catch(_){
          yield Profileupdatefailure();
        }
      } else {
        yield Profileupdatefailure();
      }
    }
  }
}
