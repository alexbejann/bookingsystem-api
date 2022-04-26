import 'package:equatable/equatable.dart';
import 'package:frontend/app/model/organization.dart';

class Office extends Equatable {
  Office({
    required this.id,
    required this.name,
    required this.organization,
  });

  factory Office.fromJson(Map<String, dynamic> json) => Office(
        id: json['id'] as String,
        name: json['name'] as String,
        organization: Organization.fromJson(
          json['organizationID'] as Map<String, dynamic>,
        ),
      );

  String id;
  String name;
  Organization organization;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    if (organization != null) {
      map['organizationID'] = organization.toJson();
    }
    return map;
  }

  @override
  List<Object?> get props => [name];
}
