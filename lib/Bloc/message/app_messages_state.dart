part of 'app_messages_bloc.dart';


abstract class AppMessagesState {
  const AppMessagesState();

  @override
  List<Object> get props => [];

}

class InitialAppMessagesState extends AppMessagesState {
}



class MessagesFetching extends AppMessagesState{}

class MessagesFetchSuccess extends AppMessagesState{
  final MessagesModel messageResponse;
  MessagesFetchSuccess(this.messageResponse);
}

class MessagesFetchFailed extends AppMessagesState{}
