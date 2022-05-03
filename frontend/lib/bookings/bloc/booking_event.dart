part of 'booking_bloc.dart';

@immutable
abstract class BookingEvent extends Equatable {
  const BookingEvent();
}

class GetBookings extends BookingEvent{
  const GetBookings();

  @override
  List<Object?> get props => [];
}

class BookingUndoDeletionRequested extends BookingEvent {
  const BookingUndoDeletionRequested();

  @override
  List<Object?> get props => [];
}

class DeleteBooking extends BookingEvent {
  const DeleteBooking(this.timeslot);

  final Timeslot timeslot;

  @override
  List<Object?> get props => [timeslot];
}
