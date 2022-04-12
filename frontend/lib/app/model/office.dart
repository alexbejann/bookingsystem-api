

import 'package:equatable/equatable.dart';
import 'package:frontend/app/model/organization.dart';

class Office extends Equatable {
  const Office(this.name);

  final String name;
  // final Organization organization;

  @override
  List<Object?> get props => [name];
}
