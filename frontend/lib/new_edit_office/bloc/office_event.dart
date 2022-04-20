part of 'office_bloc.dart';

@immutable
abstract class OfficeEvent {
  const OfficeEvent();
}


class GetOffices extends OfficeEvent {
  const GetOffices();
}
