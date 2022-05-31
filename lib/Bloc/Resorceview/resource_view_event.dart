part of 'resource_view_bloc.dart';

abstract class ResourceViewEvent extends Equatable {
  const ResourceViewEvent();
  @override
  List<Object> get props => [];
}
class FetchResourceDetails extends ResourceViewEvent{
  final String resourceId;
  final String resourceType;
  FetchResourceDetails(this.resourceId,this.resourceType);
}
class UpdateResourceDetails extends ResourceViewEvent{
  final ResourceResults resourcemodel;
  UpdateResourceDetails(this.resourcemodel);
}
