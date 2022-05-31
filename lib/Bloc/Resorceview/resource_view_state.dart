part of 'resource_view_bloc.dart';

abstract class ResourceViewState extends Equatable {
  const ResourceViewState();
  @override
  List<Object> get props => [];
}

class ResourceViewInitial extends ResourceViewState {

}
class ResourceLoading extends ResourceViewState{}
class ResourceFetched extends ResourceViewState{
  final ResourceResults resourceDetail;


  ResourceFetched(this.resourceDetail);

}
class ResourceFetchingFailed extends ResourceViewState{}

