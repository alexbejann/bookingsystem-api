import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:frontend/app/model/timeslot.dart';
import 'package:meta/meta.dart';

part 'timeslot_event.dart';
part 'timeslot_state.dart';

class TimeslotBloc extends Bloc<TimeslotEvent, TimeslotState> {
  TimeslotBloc() : super(TimeslotInitial()) {
    on<TimeslotEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
