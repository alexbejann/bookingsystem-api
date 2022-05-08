import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app/model/office.dart';
import 'package:frontend/new_edit_office/new_edit_office.dart';
import 'package:frontend/new_edit_office/repositories/office_repository.dart';

class NewEditOfficePage extends StatelessWidget {
  const NewEditOfficePage({
    Key? key,
    this.isNewOffice = false,
    this.deleteOffice = false,
    this.isEditOffice = false,
  }) : super(key: key);
  final bool isNewOffice;
  final bool deleteOffice;
  final bool isEditOffice;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OfficeBloc(
        officeRepository: context.read<OfficeRepository>(),
      )..add(const GetOffices()),
      child: NewEditOfficeView(
        isNewOffice: isNewOffice,
        deleteOffice: deleteOffice,
        isEditOffice: isEditOffice,
      ),
    );
  }
}

class NewEditOfficeView extends StatefulWidget {
  const NewEditOfficeView({
    Key? key,
    this.isNewOffice = false,
    this.deleteOffice = false,
    this.isEditOffice = false,
  }) : super(key: key);
  final bool isNewOffice;
  final bool deleteOffice;
  final bool isEditOffice;

  @override
  State<NewEditOfficeView> createState() => _NewEditOfficeViewState();
}

class _NewEditOfficeViewState extends State<NewEditOfficeView> {
  final _formKey = GlobalKey<FormState>();

  final officeIdController = TextEditingController();

  final officeNameController = TextEditingController();

  String? officeId;

  void saveForm(BuildContext context) {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      if (widget.deleteOffice) {
        context.read<OfficeBloc>().add(
              DeleteOffice(
                officeId: officeId!,
              ),
            );
      } else if (widget.isEditOffice) {
        context.read<OfficeBloc>().add(
              RenameOffice(
                name: officeIdController.text,
                officeId: officeId!,
              ),
            );
      } else {
        context.read<OfficeBloc>().add(
              AddOffice(
                name: officeIdController.text,
              ),
            );
      }
      return;
    }
  }

  @override
  void dispose() {
    officeNameController.dispose();
    officeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode()..requestFocus();
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
              title: Text(
                widget.isNewOffice ? 'Create new office' : 'Edit office',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              trailing: TextButton(
                onPressed: () => saveForm(context),
                child: const Text('Done'),
              ),
            ),
            const Divider(),
            Visibility(
              visible: widget.isNewOffice || widget.isEditOffice,
              child: ListTile(
                title: TextField(
                  controller: officeIdController,
                  focusNode: focusNode,
                  decoration:
                      const InputDecoration(labelText: 'Enter office name'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const Divider(),
            Visibility(
              visible: widget.isNewOffice ||
                  widget.isEditOffice ||
                  widget.deleteOffice,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<OfficeBloc, OfficeState>(
                  builder: (context, state) {
                    if (state.offices.isNotEmpty) {
                      return DropdownButtonFormField<String>(
                        validator: (value) =>
                            value == null ? 'Field required' : null,
                        hint: const Text('Please choose an office'),
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
