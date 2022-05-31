part of 'myhomepage_bloc.dart';

abstract class MyhomepageEvent extends Equatable {
  const MyhomepageEvent();
  @override
  List<Object> get props => [];
}
class GetHomepage extends MyhomepageEvent{
}
class DeleteHomepage extends MyhomepageEvent{
  final Resources resources;

  DeleteHomepage(this.resources);
}