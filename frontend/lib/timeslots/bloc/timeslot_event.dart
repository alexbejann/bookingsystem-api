part of 'timeslot_bloc.dart';

@immutable
abstract class TimeslotEvent {
  const TimeslotEvent();
}

class GetTimeslots extends TimeslotEvent {
  const GetTimeslots(this.workspaceId);

  final String workspaceId;
}

class DeleteTimeslot extends TimeslotEvent {
  const DeleteTimeslot(this.timeslotId);

  final String timeslotId;
}

