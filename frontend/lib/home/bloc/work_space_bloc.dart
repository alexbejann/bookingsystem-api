import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'work_space_event.dart';
part 'work_space_state.dart';

class WorkSpaceBloc extends Bloc<WorkSpaceEvent, WorkSpaceState> {
  WorkSpaceBloc() : super(WorkSpaceInitial()) {
    on<WorkSpaceEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
