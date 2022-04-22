import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:frontend/app/model/timeslot.dart';
import 'package:meta/meta.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(const BookingInitial()) {
    on<BookingEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
