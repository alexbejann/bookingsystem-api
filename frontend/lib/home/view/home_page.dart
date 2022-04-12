import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/home/bloc/work_space_bloc.dart';
import 'package:frontend/l10n/l10n.dart';
import 'package:frontend/timeslots/timeslots.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkSpaceBloc(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  void newWorkspace() {
    //todo add a new workspace redirect to creation screen
  }

  void renameWorkspace() {
    //todo rename workspace redirect to renaming screen
  }

  void deleteWorkspace() {
    //todo delete workspace with a popup for confirmation
  }

  Future<void> _settingModalBottomSheet(BuildContext context) async {
    await showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
              title: const Text('Add area'),
              onTap: newWorkspace,
            ),
            ListTile(
              title: const Text('Rename area'),
              onTap: renameWorkspace,
            ),
            ListTile(
              title: const Text('Delete area'),
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
                    await _settingModalBottomSheet(context);
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text('Tabs Demo'),
          bottom: TabBar(
            onTap: (value) {
              print(value);
            },
            tabs: [
              Tab(
                text: 'Floor 1',
              ),
              Tab(
                text: 'Floor 2',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            WorkArea(),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }
}

class WorkArea extends StatelessWidget {
  const WorkArea({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(height: 1),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Workspace $index'),
          onTap: () {
            Navigator.push<MaterialPageRoute>(
              context,
              MaterialPageRoute(builder: (context) => const TimeSlotsPage()),
            );
          },
        );
      },
    );
  }
}
