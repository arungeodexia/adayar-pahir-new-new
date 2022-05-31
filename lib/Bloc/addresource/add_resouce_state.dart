part of 'add_resouce_bloc.dart';

abstract class AddResouceState extends Equatable {
  const AddResouceState();
  @override
  List<Object> get props => [];
}

class AddResouceInitial extends AddResouceState {

}
class AddResouceLoading extends AddResouceState {

}
class SkillSelct extends AddResouceState {

}
class AddResouceSuccess extends AddResouceState {

}
class SkillSuccess extends AddResouceState {
final List<SkillItemModel> list;
  SkillSuccess(this.list);
}
class AddResouceFailure extends AddResouceState {

}
