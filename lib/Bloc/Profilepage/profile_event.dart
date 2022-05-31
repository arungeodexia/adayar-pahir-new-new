part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  List<Object> get props => [];

  const ProfileEvent();
}
class ProfileUpdate extends ProfileEvent{
  final CreateEditProfileModel createEditProfileModel;
  final String path;

  ProfileUpdate(this.createEditProfileModel, this.path);

}
class Profiledata extends ProfileEvent{


  Profiledata();

}