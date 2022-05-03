part of 'office_bloc.dart';

@immutable
abstract class OfficeEvent extends Equatable {
  const OfficeEvent();
}


class GetOffices extends OfficeEvent {
  const GetOffices();

  @override
  List<Object?> get props => [];
}

class AddOffice extends OfficeEvent {
  const AddOffice({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

class RenameOffice extends OfficeEvent {
  const RenameOffice({required this.name, required this.officeId});

  final String name;
  final String officeId;

  @override
  List<Object?> get props => [name, officeId];
}

class DeleteOffice extends OfficeEvent {
  const DeleteOffice({required this.officeId});

  final String officeId;

  @override
  List<Object?> get props => [officeId];
}
