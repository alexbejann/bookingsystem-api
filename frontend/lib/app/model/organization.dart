

import 'package:equatable/equatable.dart';

class Organization extends Equatable {
  const Organization({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}
