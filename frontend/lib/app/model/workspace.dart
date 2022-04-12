
import 'package:equatable/equatable.dart';
import 'package:frontend/app/model/office.dart';

class Workspace extends Equatable {
  const Workspace({required this.name, required this.office});

  final String name;
  final Office office;

  @override
  List<Object?> get props => [name];

}
