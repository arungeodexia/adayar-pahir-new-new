part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {
}
class ProfileLoading extends ProfileState {
}
class Profileupdatefailure extends ProfileState {
}
class Profileupdatesuccess extends ProfileState {
}
class Profiledatasuccess extends ProfileState {
  final CreateEditProfileModel createEditProfileModel;

  Profiledatasuccess(this.createEditProfileModel);
}
