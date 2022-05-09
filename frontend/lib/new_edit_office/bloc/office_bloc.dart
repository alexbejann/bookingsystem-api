import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/app/model/office.dart';
import 'package:frontend/new_edit_office/repositories/office_repository.dart';
import 'package:meta/meta.dart';

part 'office_event.dart';
part 'office_state.dart';

class OfficeBloc extends Bloc<OfficeEvent, OfficeState> {
  OfficeBloc({required this.officeRepository}) : super(const OfficeState()) {
    on<GetOffices>(_onOfficesRequested);

    on<AddOffice>(_onCreationRequested);

    on<RenameOffice>(_onRenameRequest);

    on<DeleteOffice>(_onDeleteRequest);
  }

  final OfficeRepository officeRepository;

  Future<void> _onOfficesRequested(
    GetOffices event,
    Emitter<OfficeState> emit,
  ) async {
    emit(state.copyWith(status: () => OfficeStatus.loading));

    try {
      final offices = await officeRepository.getOffices();
      emit(
        state.copyWith(
          status: () => OfficeStatus.success,
          offices: () => [...offices],
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: () => OfficeStatus.failure));
    }
  }

  Future<void> _onCreationRequested(
    AddOffice event,
    Emitter<OfficeState> emit,
  ) async {
    emit(state.copyWith(status: () => OfficeStatus.loading));

    try {
      final office = await officeRepository.addOffice(
        variables: <String, dynamic>{
          'name': event.name,
        },
      );
      emit(
        state.copyWith(
          status: () => OfficeStatus.editSuccess,
          offices: () => [...state.offices, office],
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: () => OfficeStatus.failure));
    }
  }

  Future<void> _onRenameRequest(
    RenameOffice event,
    Emitter<OfficeState> emit,
  ) async {
    emit(state.copyWith(status: () => OfficeStatus.loading));

    try {
      final office = await officeRepository.renameOffice(
        variables: <String, dynamic>{
          'newName': event.name,
          'officeId': event.officeId,
        },
      );
      emit(
        state.copyWith(
          status: () => OfficeStatus.editSuccess,
          offices: () => [...state.offices, office],
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: () => OfficeStatus.failure));
    }
  }

  Future<void> _onDeleteRequest(
    DeleteOffice event,
    Emitter<OfficeState> emit,
  ) async {
    emit(state.copyWith(status: () => OfficeStatus.loading));

    try {
      final office = await officeRepository.deleteOffice(
        variables: <String, dynamic>{
          'deleteOfficeId': event.officeId,
        },
      );
      emit(
        state.copyWith(
          status: () => OfficeStatus.editSuccess,
          offices: () => [...state.offices]
            ..removeWhere((element) => element.id == office.id),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: () => OfficeStatus.failure));
    }
  }
}
