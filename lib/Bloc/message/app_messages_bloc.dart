import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ACI/Bloc/message/message_model_class.dart';
import 'package:ACI/data/api/repository/ResourceRepo.dart';

part 'app_messages_event.dart';

part 'app_messages_state.dart';

class AppMessagesBloc extends Bloc<AppMessagesEvent, AppMessagesState> {

  AppMessagesBloc() : super(InitialAppMessagesState());

  @override
  AppMessagesState get initialState => InitialAppMessagesState();

  @override
  Stream<AppMessagesState> mapEventToState(AppMessagesEvent event) async* {
    ResourceRepo resourceRepository=ResourceRepo();
    if (event is FetchMessages) {
      yield MessagesFetching();
      //final AddResourceModel resourceData = await resourceRepository.fetchResourceData(event.resourceId,event.resourceType);
      final MessagesModel messageResponse = await resourceRepository.fetchMessages(event.countryCode,  event.mobileNumber);
      if (messageResponse != null && messageResponse.messages != null)
        yield MessagesFetchSuccess(messageResponse);
      else
        yield MessagesFetchFailed();
    }
  }

}
