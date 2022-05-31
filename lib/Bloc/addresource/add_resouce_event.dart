part of 'add_resouce_bloc.dart';

abstract class AddResouceEvent extends Equatable {
  const AddResouceEvent();
  @override
  List<Object> get props => [];
}
class AddResources extends AddResouceEvent{
 final String path;
 final AddUpdateReviewModel addUpdateReviewModel;
 final Resources resources;
  AddResources(this.path, this.addUpdateReviewModel, this.resources);


}
class GetSkills extends AddResouceEvent{
}
class SkillsSelected extends AddResouceEvent{

}
