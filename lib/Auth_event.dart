part of 'Auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}
class AuthRequested extends AuthEvent {
  final String city;

  const AuthRequested({required this.city}) : assert(city != null);

  @override
  List<Object> get props => [city];
}