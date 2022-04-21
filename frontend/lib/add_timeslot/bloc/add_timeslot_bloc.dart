import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'add_timeslot_event.dart';
part 'add_timeslot_state.dart';

class AddTimeslotBloc extends Bloc<AddTimeslotEvent, AddTimeslotState> {
  AddTimeslotBloc() : super(AddTimeslotInitial()) {
    on<AddTimeslotEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
