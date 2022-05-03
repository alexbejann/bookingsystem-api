part of 'add_timeslot_bloc.dart';

@immutable
abstract class AddTimeslotState extends Equatable {
  const AddTimeslotState();
}

class AddTimeslotInitial extends AddTimeslotState {

  const AddTimeslotInitial({required this.from, required this.to});
  final DateTime from;
  final DateTime to;

  @override
  List<Object?> get props => [from, to];
}

class SavedTimeslot extends AddTimeslotState {

  const SavedTimeslot({required this.timeslot});

  final Timeslot timeslot;

  @override
  List<Object?> get props => [timeslot];
}

class SaveTimeslotFailure extends AddTimeslotState {

  const SaveTimeslotFailure(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
