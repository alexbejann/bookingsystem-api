part of 'workspace_bloc.dart';

enum WorkspaceStatus { initial, loading, success, failure }

class WorkspaceState extends Equatable {
  const WorkspaceState({
    this.status = WorkspaceStatus.initial,
    this.workspaces = const [],
    this.lastDeletedWorkspace,
    this.lastAddedWorkspace,
  });

  final WorkspaceStatus status;
  final List<Workspace> workspaces;
  final Workspace? lastDeletedWorkspace;
  final Workspace? lastAddedWorkspace;

  WorkspaceState copyWith({
    WorkspaceStatus Function()? status,
    List<Workspace> Function()? workspaces,
    Workspace? Function()? lastDeleted,
    Workspace? Function()? lastAdded,
  }) {
    return WorkspaceState(
      status: status != null ? status() : this.status,
      workspaces: workspaces != null ? workspaces() : this.workspaces,
      lastDeletedWorkspace:
          lastDeleted != null ? lastDeleted() : lastDeletedWorkspace,
      lastAddedWorkspace:
          lastAdded != null ? lastAdded() : lastAddedWorkspace,
    );
  }

  @override
  List<Object?> get props => [
        workspaces,
        status,
        lastAddedWorkspace,
        lastDeletedWorkspace,
      ];
}
