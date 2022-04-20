import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app/model/office.dart';
import 'package:frontend/app/model/workspace.dart';
import 'package:frontend/home/home.dart';
import 'package:frontend/new_edit_office/new_edit_office.dart';
class NewEditWorkspacePage extends StatelessWidget {
  const NewEditWorkspacePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OfficeBloc(),
      child: NewEditWorkspaceView(),
    );
  }
}

class NewEditWorkspaceView extends StatefulWidget {
  NewEditWorkspaceView({
    Key? key,
    this.editWorkspace,
  }) : super(key: key);

  final Workspace? editWorkspace;

  @override
  State<NewEditWorkspaceView> createState() => _NewEditWorkspaceViewState();
}

class _NewEditWorkspaceViewState extends State<NewEditWorkspaceView> {
  late TextEditingController _oldListTitleController;
  String newWorkspaceName = '';
  
  @override
  void initState() {
    super.initState();
    if (widget.editWorkspace != null) {
      context.read<OfficeBloc>().add(const GetOffices());
    }
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode()..requestFocus();
    if (widget.editWorkspace != null) {
      final oldListTitle = widget.editWorkspace?.name;
      _oldListTitleController = TextEditingController(text: oldListTitle);
    } else {
      _oldListTitleController =
          TextEditingController(text: 'Create a new Workspace');
    }
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
            title: TextField(
              onChanged: (newName) => newWorkspaceName = newName,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.editWorkspace == null
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
                if (newWorkspaceName != '') {
                  context.read<WorkspaceBloc>().add(
                        RenameWorkspace(newWorkspaceName),
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
              decoration:
                  const InputDecoration(labelText: 'Enter workspace name'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const Divider(),
          Visibility(
            visible: widget.editWorkspace == null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<OfficeBloc, OfficeState>(
                builder: (context, state) {
                  if (state is OfficeLoaded) {
                    return DropdownButton<String>(
                      hint: const Text('Please choose an office'),
                      items: state.offices.map((Office office) {
                        return DropdownMenuItem<String>(
                          /// todo replace this with office id
                          value: office.name,
                          child: Text(office.name),
                        );
                      }).toList(),
                      onChanged: (_) {},
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
