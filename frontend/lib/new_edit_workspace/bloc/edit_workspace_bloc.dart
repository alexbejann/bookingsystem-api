import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/app/model/workspace.dart';
import 'package:frontend/home/repositories/workspace_repository.dart';
import 'package:meta/meta.dart';

part 'edit_workspace_event.dart';
part 'edit_workspace_state.dart';

class EditWorkspaceBloc extends Bloc<EditWorkspaceEvent, EditWorkspaceState> {
  EditWorkspaceBloc({
    required this.workspaceRepository,
    String? workspaceName,
    String? workspaceId,
  }) : super(
          EditWorkspaceState(
            workspaceName: workspaceName,
            workspaceId: workspaceId,
          ),
        ) {
    on<EditWorkspaceSubmitted>(_onSubmitted);

    on<AddWorkspaceValues>(_onAddedValues);
  }

  final WorkspaceRepository workspaceRepository;

  Future<void> _onAddedValues(
    AddWorkspaceValues event,
    Emitter<EditWorkspaceState> emit,
  ) async {
    emit(
      state.copyWith(
        workspaceId: event.workspaceId,
        workspaceName: event.workspaceName,
      ),
    );
  }

  Future<void> _onSubmitted(
    EditWorkspaceSubmitted event,
    Emitter<EditWorkspaceState> emit,
  ) async {
    emit(state.copyWith(status: EditWorkspaceStatus.loading));
    try {
      Workspace edited;
      if (event.officeId != null) {
        edited = await workspaceRepository.createWorkspace(
          workspaceName: event.name,
          officeId: event.officeId!,
        );
      } else {
        edited = await workspaceRepository.renameWorkspace(
          workspaceName: event.name,
          workspaceId: event.workspaceId!,
        );
      }
      emit(
        state.copyWith(
          status: EditWorkspaceStatus.success,
          lastEdited: edited,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: EditWorkspaceStatus.failure));
    }
  }
}
