import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/app/model/office.dart';
import 'package:frontend/app/model/workspace.dart';
import 'package:frontend/home/home.dart';
import 'package:frontend/home/repositories/workspace_repository.dart';
import 'package:frontend/new_edit_workspace/bloc/edit_workspace_bloc.dart';
import 'package:frontend/new_edit_workspace/bloc/edit_workspace_bloc.dart';
import 'package:frontend/new_edit_workspace/bloc/edit_workspace_bloc.dart';
import 'package:meta/meta.dart';

part 'workspace_event.dart';
part 'workspace_state.dart';

class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  WorkspaceBloc({
    required this.workspaceRepository,
  }) : super(const WorkspaceState()) {
    on<GetWorkspaces>(_onSubscriptionRequested);

    on<WorkspaceUndoDeletionRequested>(_onUndoDeletionRequested);

    on<DeleteWorkspace>(_onWorkspaceDeleted);

    on<RecentlyEditedWorkspace>(_onRecentlyEdited);
  }

  final WorkspaceRepository workspaceRepository;

  Future<void> _onSubscriptionRequested(
    GetWorkspaces event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(state.copyWith(status: () => WorkspaceStatus.loading));

    try {
      final workspaces = await workspaceRepository.getWorkspaces();
      emit(
        state.copyWith(
          status: () => WorkspaceStatus.success,
          workspaces: () => [...workspaces],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: () => WorkspaceStatus.failure,
        ),
      );
    }
  }

  Future<void> _onWorkspaceDeleted(
    DeleteWorkspace event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(
      state.copyWith(
        lastDeleted: () => event.workspace,
        workspaces: () => [...state.workspaces]..remove(event.workspace),
      ),
    );
    await workspaceRepository.deleteWorkspace(workspaceId: event.workspace.id);
  }

  Future<void> _onUndoDeletionRequested(
    WorkspaceUndoDeletionRequested event,
    Emitter<WorkspaceState> emit,
  ) async {
    assert(
      state.lastDeletedWorkspace != null,
      'Last deleted Workspace can not be null.',
    );

    final workspace = state.lastDeletedWorkspace!;
    emit(
      state.copyWith(
        lastDeleted: () => null,
        workspaces: () => [...state.workspaces, workspace],
      ),
    );
    await workspaceRepository.createWorkspace(
      officeId: workspace.office!.id,
      workspaceName: workspace.name!,
    );
  }

  Future<void> _onRecentlyEdited(
    RecentlyEditedWorkspace event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(state.copyWith(status: () => WorkspaceStatus.loading));

    try {
      emit(
        state.copyWith(
          status: () => WorkspaceStatus.success,
          workspaces: () => [...state.workspaces]
            ..removeWhere((element) => element.id == event.workspace.id)
            ..add(event.workspace),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: () => WorkspaceStatus.failure));
    }
  }
}
