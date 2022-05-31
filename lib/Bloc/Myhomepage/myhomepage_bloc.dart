import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ACI/Model/add_resource_model.dart';
import 'package:ACI/Model/resources.dart';
import 'package:ACI/data/api/repository/ResourceRepo.dart';
import 'package:http/http.dart' as http;

part 'myhomepage_event.dart';

part 'myhomepage_state.dart';

class MyhomepageBloc extends Bloc<MyhomepageEvent, MyhomepageState> {
  MyhomepageBloc() : super(MyhomepageInitial());

  @override
  Stream<MyhomepageState> mapEventToState(
    MyhomepageEvent event,
  ) async* {
    if (event is GetHomepage) {
      yield MyhomepageLoading();
      ResourceRepo profileRepo = ResourceRepo();
      http.Response? response = await profileRepo.gethomedata();
      if (response == null) {
        yield MyhomepageFailure();
      }
      if (response!.statusCode == 200) {
        try {
          List<Resources> resources =
              (json.decode(utf8.decode(response.bodyBytes)) as List)
                  .map((i) => Resources.fromJson(i))
                  .toList();
          print(resources);
          yield MyhomepageSuccess(resources);
        } catch (_) {
          print(_);
          yield MyhomepageFailure();
        }
      } else {
        yield MyhomepageFailure();
      }
    } else if (event is DeleteHomepage) {
      yield MyhomepageLoading();
      ResourceRepo profileRepo = ResourceRepo();
      http.Response? response =
          await profileRepo.removeResource(event.resources);
      if (response == null) {
        yield MyhomepageFailure();
      }
      if (response!.statusCode == 200) {
        try {
          yield MyhomepageDeleteSuccess();
        } catch (_) {
          print(_);
          yield MyhomepageFailure();
        }
      } else {
        yield MyhomepageFailure();
      }
    }
  }
}
