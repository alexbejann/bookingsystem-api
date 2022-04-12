import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:frontend/app/model/office.dart';
import 'package:frontend/app/model/workspace.dart';
import 'package:frontend/home/home.dart';
import 'package:meta/meta.dart';

part 'workspace_event.dart';
part 'workspace_state.dart';

class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  WorkspaceBloc() : super(WorkspaceLoaded([Workspace(name: 'worksapce1', office: Office('Office1')),
    Workspace(name: 'worksapce2', office: Office('Office2')),
    Workspace(name: 'worksapce2', office: Office('Office2')),
    Workspace(name: 'worksapce3', office: Office('Office1'))])) {
    on<WorkspaceEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
