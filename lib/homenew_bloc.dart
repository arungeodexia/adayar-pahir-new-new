import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'homenew_event.dart';
part 'homenew_state.dart';

class HomenewBloc extends Bloc<HomenewEvent, HomenewState> {
  HomenewBloc() : super(HomenewInitial());

  @override
  Stream<HomenewState> mapEventToState(
    HomenewEvent event,
  ) async* {

    if(event is LoadHomePageData){
      yield HomenewLoading("new");
    }

  }
}
