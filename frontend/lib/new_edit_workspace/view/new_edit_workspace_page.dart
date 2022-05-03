import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app/model/office.dart';
import 'package:frontend/home/home.dart';
import 'package:frontend/home/repositories/workspace_repository.dart';
import 'package:frontend/new_edit_office/new_edit_office.dart';
import 'package:frontend/new_edit_office/repositories/office_repository.dart';
import 'package:frontend/new_edit_workspace/bloc/edit_workspace_bloc.dart';

class NewEditWorkspacePage extends StatelessWidget {
  const NewEditWorkspacePage({Key? key, this.workspaceName, this.workspaceId})
      : super(key: key);

  final String? workspaceName;
  final String? workspaceId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EditWorkspaceBloc>(
          create: (BuildContext context) => EditWorkspaceBloc(
            workspaceRepository: context.read<WorkspaceRepository>(),
            workspaceName: workspaceName,
            workspaceId: workspaceId,
          ),
        ),
        BlocProvider<OfficeBloc>(
          create: (BuildContext context) => OfficeBloc(
            officeRepository: context.read<OfficeRepository>(),
          )..add(const GetOffices()),
        ),
      ],
      child: BlocListener<EditWorkspaceBloc, EditWorkspaceState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == EditWorkspaceStatus.success,
        listener: (context, state) {
          if (state.lastEdited != null) {
            BlocProvider.of<WorkspaceBloc>(context)
                .add(RecentlyEditedWorkspace(state.lastEdited!));
          }
          Navigator.of(context).pop();
        },
        child: const NewEditWorkspaceView(),
      ),
    );
  }
}

class NewEditWorkspaceView extends StatefulWidget {
  const NewEditWorkspaceView({
    Key? key,
    this.workspaceName,
    this.workspaceId,
  }) : super(key: key);

  final String? workspaceName;
  final String? workspaceId;

  @override
  State<NewEditWorkspaceView> createState() => _NewEditWorkspaceViewState();
}

class _NewEditWorkspaceViewState extends State<NewEditWorkspaceView> {
  late TextEditingController _oldListTitleController;
  final _formKey = GlobalKey<FormState>();
  final workspaceNameController = TextEditingController();

  String? officeId;

  void saveForm(BuildContext context, String? workspaceId) {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      context.read<EditWorkspaceBloc>().add(
            EditWorkspaceSubmitted(
              name: workspaceNameController.text,
              workspaceId: workspaceId,
              officeId: officeId,
            ),
          );
    }
  }

  @override
  void dispose() {
    workspaceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode()..requestFocus();
    final state = context.watch<EditWorkspaceBloc>().state;
    _oldListTitleController = TextEditingController(
      text: state.workspaceName ?? 'Create a new Workspace',
    );
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            ListTile(
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
              title: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: state.workspaceId == null
                      ? 'Create new workspace'
                      : 'Edit workspace',
                ),
                autofocus: true,
                enabled: true,
                controller: _oldListTitleController,
              ),
              trailing: TextButton(
                onPressed: () => saveForm(context, state.workspaceId),
                child: const Text('Done'),
              ),
            ),
            const Divider(),
            ListTile(
              title: TextFormField(
                validator: (value) => value == null ? 'Field required' : null,
                focusNode: focusNode,
                controller: workspaceNameController,
                decoration:
                    const InputDecoration(labelText: 'Enter workspace name'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Divider(),
            Visibility(
              visible: state.workspaceId == null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<OfficeBloc, OfficeState>(
                  builder: (context, state) {
                    if (state.offices.isNotEmpty) {
                      return DropdownButtonFormField<String>(
                        validator: (value) =>
                            value == null ? 'Field required' : null,
                        hint: const Text('Please choose an office'),
                        value: officeId,
                        items: state.offices.map((Office office) {
                          return DropdownMenuItem<String>(
                            value: office.id,
                            child: Text(office.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            officeId = value;
                          });
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
