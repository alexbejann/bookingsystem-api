import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app/model/workspace.dart';
import 'package:frontend/home/bloc/workspace_bloc.dart';
import 'package:frontend/l10n/l10n.dart';
import 'package:frontend/new_edit_office/new_edit_office.dart';
import 'package:frontend/timeslots/timeslots.dart';
import 'package:grouped_list/grouped_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkspaceBloc(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  void newWorkspace() {
    //todo add a new workspace redirect to creation screen
  }

  void deleteWorkspace() {
    //todo delete workspace with a popup for confirmation
  }

  Future<void> _optionMenu(BuildContext context) async {
    await showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('My bookings'),
              onTap: () {
                //todo go to my bookings
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Chat Admin'),
              onTap: () {
                //todo go to admin chat with socket io
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _settingModalBottomSheet(BuildContext context) async {
    await showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add office'),
              onTap: () {
                Navigator.push<MaterialPageRoute>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewEditOfficePage(
                      isNewOffice: true,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename office'),
              onTap: () {
                Navigator.push<MaterialPageRoute>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewEditOfficePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Delete office'),
              onTap: deleteWorkspace,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).bottomAppBarColor,
          onPressed: newWorkspace,
          child: const Icon(
            Icons.add,
          ),
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        bottomNavigationBar: BottomAppBar(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () async {
                    await _optionMenu(context);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () async {
                    await _settingModalBottomSheet(context);
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text('Desk Booking'),
        ),
        body: BlocConsumer<WorkspaceBloc, WorkspaceState>(
          listener: (context, state) {
            if (state is WorkspaceError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            if (state is WorkspaceLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WorkspaceLoaded) {
              return GroupedListView<Workspace, String>(
                elements: state.workspaces,
                groupBy: (element) => element.office.name,
                groupSeparatorBuilder: (value) => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Text(value),
                ),
                useStickyGroupSeparators: true, // optional
                itemBuilder: (context, element) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.work),
                      title: Text(element.name),
                      onTap: () {
                        Navigator.push<MaterialPageRoute>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TimeSlotsPage(),
                          ),
                        );
                      },
                    ),
                  );
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
    );
  }
}
