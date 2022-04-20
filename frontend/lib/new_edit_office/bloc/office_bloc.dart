import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:frontend/app/model/office.dart';
import 'package:meta/meta.dart';

part 'office_event.dart';
part 'office_state.dart';

class OfficeBloc extends Bloc<OfficeEvent, OfficeState> {
  OfficeBloc() : super(OfficeInitial()) {
    on<OfficeEvent>((event, emit) async {
      // TODO: implement event handler
    });
  }
}
