import 'package:flutter/material.dart';

class NewWorkspacePage extends StatelessWidget {
  const NewWorkspacePage({Key? key}) : super(key: key);

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
              'Create new workspace',
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
              decoration:
                  const InputDecoration(labelText: 'Enter workspace name'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            /// todo add here the office spaces
            child: DropdownButton<String>(
              hint: const Text('Please choose an office'),
              items: <String>['A', 'B', 'C', 'D'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}
