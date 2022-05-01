import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app/model/office.dart';
import 'package:frontend/app/model/workspace.dart';
import 'package:frontend/home/home.dart';
import 'package:frontend/new_edit_office/new_edit_office.dart';
import 'package:frontend/new_edit_office/repositories/office_repository.dart';

class NewEditWorkspacePage extends StatelessWidget {
  const NewEditWorkspacePage({Key? key, this.workspaceName, this.workspaceId})
      : super(key: key);

  final String? workspaceName;
  final String? workspaceId;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => OfficeRepository(),
      child: BlocProvider(
        create: (context) => OfficeBloc(
          officeRepository: context.read<OfficeRepository>(),
        ),
        child: NewEditWorkspaceView(
          workspaceId: workspaceId,
          workspaceName: workspaceName,
        ),
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
  final workspaceNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<OfficeBloc>().add(const GetOffices());
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode()..requestFocus();
    _oldListTitleController = TextEditingController(
        text: widget.workspaceName ?? 'Create a new Workspace',);
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
            title: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.workspaceId == null
                    ? 'Create new workspace'
                    : 'Edit workspace',
              ),
              autofocus: true,
              enabled: true,
              controller: _oldListTitleController,
            ),
            trailing: TextButton(
              onPressed: () {
                // bloc office add/edit
                if (workspaceNameController.text.isNotEmpty) {
                  context.read<WorkspaceBloc>().add(
                        RenameWorkspace(workspaceNameController.text),
                      );
                }
              },
              child: const Text('Done'),
            ),
          ),
          const Divider(),
          ListTile(
            title: TextField(
              focusNode: focusNode,
              controller: workspaceNameController,
              decoration:
                  const InputDecoration(labelText: 'Enter workspace name'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const Divider(),
          Visibility(
            visible: widget.workspaceId == null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<OfficeBloc, OfficeState>(
                builder: (context, state) {
                  if (state is OfficeLoaded) {
                    return DropdownButton<String>(
                      hint: const Text('Please choose an office'),
                      items: state.offices.map((Office office) {
                        return DropdownMenuItem<String>(
                          value: office.id,
                          child: Text(office.name),
                        );
                      }).toList(),
                      onChanged: (value) {},
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
    );
  }
}
