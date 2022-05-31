part of 'homenew_bloc.dart';

abstract class HomenewState extends Equatable {
  const HomenewState();
  @override
  List<Object> get props => [];
}

class HomenewInitial extends HomenewState {

}
class HomenewLoading extends HomenewState {
   final String value;
   HomenewLoading(this.value);
}
