part of 'booking_bloc.dart';

enum BookingStatus { initial, loading, success, failure }

class BookingState extends Equatable {
  const BookingState({
    this.status = BookingStatus.initial,
    this.bookings = const [],
    this.lastDeletedTimeslot,
  });

  final BookingStatus status;
  final List<Timeslot> bookings;
  final Timeslot? lastDeletedTimeslot;

  BookingState copyWith({
    BookingStatus Function()? status,
    List<Timeslot> Function()? bookings,
    Timeslot? Function()? lastDeleted,
  }) {
    return BookingState(
      status: status != null ? status() : this.status,
      bookings: bookings != null ? bookings() : this.bookings,
      lastDeletedTimeslot:
      lastDeleted != null ? lastDeleted() : lastDeletedTimeslot,
    );
  }

  @override
  List<Object?> get props => [
    bookings,
    status,
    lastDeletedTimeslot,
  ];
}
