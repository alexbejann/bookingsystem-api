import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/app/model/timeslot.dart';
import 'package:frontend/timeslots/repositories/timeslot_repository.dart';
import 'package:meta/meta.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc({required this.timeslotRepository})
      : super(const BookingState()) {
    on<GetBookings>(_onBookingsRequested);

    on<BookingUndoDeletionRequested>(_onUndoDeletionRequested);

    on<DeleteBooking>(_onDeleteBookingRequested);
  }
  final TimeslotRepository timeslotRepository;

  Future<void> _onBookingsRequested(
    GetBookings event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(status: () => BookingStatus.loading));

    try {
      final bookings = await timeslotRepository.getBookings();
      emit(
        state.copyWith(
          status: () => BookingStatus.success,
          bookings: () => [...bookings],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: () => BookingStatus.failure,
        ),
      );
    }
  }

  Future<void> _onDeleteBookingRequested(
      DeleteBooking event,
    Emitter<BookingState> emit,
  ) async {
    emit(
      state.copyWith(
        lastDeleted: () => event.timeslot,
        bookings: () => [...state.bookings]..remove(event.timeslot),
      ),
    );
    await timeslotRepository.removeTimeslot(
      variables: <String, dynamic>{
        'timeslotId': event.timeslot.id,
      },
    );
  }

  Future<void> _onUndoDeletionRequested(
    BookingUndoDeletionRequested event,
    Emitter<BookingState> emit,
  ) async {
    assert(
      state.lastDeletedTimeslot != null,
      'Last deleted booking can not be null.',
    );

    final timeslot = state.lastDeletedTimeslot!;
    emit(
      state.copyWith(
        lastDeleted: () => null,
        bookings: () => [...state.bookings, timeslot],
      ),
    );
    await timeslotRepository.addTimeslot(
      variables: <String, dynamic>{
        'workspaceId': state.lastDeletedTimeslot?.workspaceID,
        'from':
            state.lastDeletedTimeslot?.from.millisecondsSinceEpoch.toString(),
        'to': state.lastDeletedTimeslot?.to.millisecondsSinceEpoch.toString(),
      },
    );
  }
}
