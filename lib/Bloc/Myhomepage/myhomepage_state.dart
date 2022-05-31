part of 'myhomepage_bloc.dart';

abstract class MyhomepageState extends Equatable {
  const MyhomepageState();
  @override
  List<Object> get props => [];
}

class MyhomepageInitial extends MyhomepageState {

}
class MyhomepageSuccess extends MyhomepageState {
  final List<Resources> resourcelist;

  MyhomepageSuccess(this.resourcelist);
}
class MyhomepageDeleteSuccess extends MyhomepageState {
}
class MyhomepageFailure extends MyhomepageState {

}
class MyhomepageLoading extends MyhomepageState {

}
