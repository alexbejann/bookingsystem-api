import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:frontend/app/model/office.dart';
import 'package:frontend/new_edit_office/repositories/office_repository.dart';
import 'package:meta/meta.dart';

part 'office_event.dart';
part 'office_state.dart';

class OfficeBloc extends Bloc<OfficeEvent, OfficeState> {
  OfficeBloc({required this.officeRepository}) : super(OfficeInitial()) {
    on<GetOffices>((event, emit) async =>
        emit(OfficeLoaded(await officeRepository.getOffices())),);

    // on<AddOffice>((event, emit) async =>
    //     emit(OfficeLoaded(await officeRepository.addOffice(variables: <String, dynamic>{
    //       'name': state.username.value,
    //     },))),);
  }

  final OfficeRepository officeRepository;
}
