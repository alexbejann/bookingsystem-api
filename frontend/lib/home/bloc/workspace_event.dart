part of 'workspace_bloc.dart';

@immutable
abstract class WorkspaceEvent extends Equatable {
  const WorkspaceEvent();
}


class GetWorkspaces extends WorkspaceEvent {
  const GetWorkspaces();

  @override
  List<Object?> get props => [];
}

class GetWorkspace extends WorkspaceEvent {
  const GetWorkspace(this.workspaceName);

  final String workspaceName;

  @override
  List<Object?> get props => [workspaceName];
}

class WorkspaceUndoDeletionRequested extends WorkspaceEvent {
  const WorkspaceUndoDeletionRequested();

  @override
  List<Object?> get props => [];
}

class DeleteWorkspace extends WorkspaceEvent {
  const DeleteWorkspace(this.workspace);

  final Workspace workspace;

  @override
  List<Object?> get props => [workspace];
}

class RecentlyEditedWorkspace extends WorkspaceEvent {
  const RecentlyEditedWorkspace(this.workspace);

  final Workspace workspace;

  @override
  List<Object?> get props => [workspace];
}
