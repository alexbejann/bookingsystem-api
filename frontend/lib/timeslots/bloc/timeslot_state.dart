part of 'timeslot_bloc.dart';

@immutable
abstract class TimeslotState {}

class TimeslotInitial extends TimeslotState {
  TimeslotInitial();
}

class TimeslotLoading extends TimeslotState {
  TimeslotLoading();
}

class TimeslotsLoaded extends TimeslotState {
  TimeslotsLoaded(this.timeSlots);
  final List<Timeslot> timeSlots;
}

class TimeslotError extends TimeslotState {
  TimeslotError(this.error);
  final String error;
}
