part of 'office_bloc.dart';

enum OfficeStatus { initial, loading, success, failure }

class OfficeState extends Equatable {
  const OfficeState({
    this.status = OfficeStatus.initial,
    this.offices = const [],
  });

  final OfficeStatus status;
  final List<Office> offices;

  OfficeState copyWith({
    OfficeStatus Function()? status,
    List<Office> Function()? offices,
    Office? Function()? lastDeleted,
  }) {
    return OfficeState(
      status: status != null ? status() : this.status,
      offices: offices != null ? offices() : this.offices,
    );
  }

  @override
  List<Object?> get props => [
    offices,
    status,
  ];
}
