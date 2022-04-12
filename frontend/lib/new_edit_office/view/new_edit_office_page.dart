import 'package:flutter/material.dart';

class NewEditOfficePage extends StatelessWidget {
  const NewEditOfficePage({Key? key, this.isNewOffice = false})
      : super(key: key);
  final bool isNewOffice;

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode()..requestFocus();
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
            title: Text(
              isNewOffice ? 'Create new office' : 'Edit office',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            trailing: TextButton(
              onPressed: () {
                // bloc office add/edit
              },
              child: const Text('Done'),
            ),
          ),
          const Divider(),
          ListTile(
            title: TextField(
              focusNode: focusNode,
              decoration: const InputDecoration(labelText: 'Enter office name'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
