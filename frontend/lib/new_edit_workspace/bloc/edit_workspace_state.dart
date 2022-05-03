part of 'edit_workspace_bloc.dart';

enum EditWorkspaceStatus { initial, loading, success, failure }

extension EditWorkspaceStatusX on EditWorkspaceStatus {
  bool get isLoadingOrSuccess => [
    EditWorkspaceStatus.loading,
    EditWorkspaceStatus.success,
  ].contains(this);
}

class EditWorkspaceState extends Equatable {
  const EditWorkspaceState({
    this.status = EditWorkspaceStatus.initial,
    this.workspaceName,
    this.workspaceId,
    this.officeId,
    this.lastEdited,
  });

  final EditWorkspaceStatus status;
  final String? workspaceName;
  final String? workspaceId;
  final String? officeId;
  final Workspace? lastEdited;

  bool get isNew => workspaceName == null;

  EditWorkspaceState copyWith({
    EditWorkspaceStatus? status,
    String? workspaceName,
    String? workspaceId,
    String? officeId,
    Workspace? lastEdited,
  }) {
    return EditWorkspaceState(
      status: status ?? this.status,
      workspaceName: workspaceName ?? this.workspaceName,
      workspaceId: workspaceId ?? this.workspaceId,
      officeId:  officeId ?? this.officeId,
      lastEdited: lastEdited ?? this.lastEdited,
    );
  }

  @override
  List<Object?> get props => [status, workspaceName, workspaceId, officeId];
}
