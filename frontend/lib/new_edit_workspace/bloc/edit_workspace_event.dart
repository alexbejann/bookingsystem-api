part of 'edit_workspace_bloc.dart';

abstract class EditWorkspaceEvent extends Equatable {
  const EditWorkspaceEvent();

  @override
  List<Object> get props => [];
}

class EditWorkspaceSubmitted extends EditWorkspaceEvent {
  const EditWorkspaceSubmitted({
    required this.name,
    this.officeId,
    this.workspaceId,
  });

  final String name;
  final String? officeId;
  final String? workspaceId;
}

class AddWorkspaceValues extends EditWorkspaceEvent {
  const AddWorkspaceValues({
    this.workspaceName,
    this.workspaceId,
  });

  final String? workspaceName;
  final String? workspaceId;
}
