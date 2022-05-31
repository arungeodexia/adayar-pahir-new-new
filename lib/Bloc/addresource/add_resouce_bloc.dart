import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ACI/Model/AddUpdateReviewModel.dart';
import 'package:ACI/Model/resources.dart';
import 'package:ACI/Model/skill_item.dart';
import 'package:ACI/data/api/repository/ResourceRepo.dart';
import 'package:http/http.dart' as http;

part 'add_resouce_event.dart';

part 'add_resouce_state.dart';

class AddResouceBloc extends Bloc<AddResouceEvent, AddResouceState> {
  AddResouceBloc() : super(AddResouceInitial());

  @override
  Stream<AddResouceState> mapEventToState(
    AddResouceEvent event,
  ) async* {
    if (event is GetSkills) {
      yield AddResouceLoading();
      ResourceRepo profileRepo = ResourceRepo();
      List<SkillItemModel> response = await profileRepo.getSkillList();
      yield SkillSuccess(response);
    } else if (event is SkillsSelected) {
      yield AddResouceLoading();
      yield SkillSelct();
    } else if (event is AddResources) {
      yield AddResouceLoading();
      ResourceRepo profileRepo = ResourceRepo();
      http.Response? response = await profileRepo.addreview(
          event.resources, event.path, event.addUpdateReviewModel);
      if (response == null) {
        yield AddResouceFailure();
      }
      if (response!.statusCode == 200) {
        try {
          yield AddResouceSuccess();
        } catch (_) {
          print(_);
          yield AddResouceFailure();
        }
      } else {
        yield AddResouceFailure();
      }
    }
  }

}
