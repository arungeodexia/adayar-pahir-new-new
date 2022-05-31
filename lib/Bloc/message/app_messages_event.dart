part of 'app_messages_bloc.dart';

@immutable
abstract class AppMessagesEvent extends Equatable {
  const AppMessagesEvent();

  @override
  List<Object> get props => [];

}


class FetchMessages extends AppMessagesEvent{
  final String countryCode;
  final String mobileNumber;

  FetchMessages({required this.countryCode, required this.mobileNumber});

  @override
  List<Object> get props => [countryCode, mobileNumber];

  @override
  String toString() => 'messages for countryCode: $countryCode, mnobile: $mobileNumber';

}
