import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend/app/bloc/authentication_bloc.dart';
import 'package:frontend/app/model/workspace.dart';
import 'package:frontend/home/bloc/workspace_bloc.dart';
import 'package:frontend/l10n/l10n.dart';
import 'package:grouped_list/grouped_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<WorkspaceBloc>(context)
        ..add(
          const GetWorkspaces(),
        ),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  Future<void> _optionMenu(BuildContext context) async {
    await showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('My bookings'),
              onTap: () => context.beamToNamed('/home/bookings'),
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Chat Admin'),
              onTap: () => context.beamToNamed('/home/chatAdmin'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: context.read<AuthenticationBloc>().logout,
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
              onTap: () =>
                  context.beamToNamed('/home/newEditOffice?isNew=true&delete=true'),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename office'),
              onTap: () =>
                  context.beamToNamed('/home/newEditOffice?isNew=false&delete=true'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Delete office'),
              onTap: () =>
                  context.beamToNamed('/home/newEditOffice?isNew=false&delete=true'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return Visibility(
            /// Limited functionality to admin user
            visible: state.user.admin,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).bottomAppBarColor,
              onPressed: () =>
                  context.beamToNamed('/home/newEditWorkspace'),
              child: const Icon(
                Icons.add,
              ),
            ),
          );
        },
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
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  return Visibility(
                    /// Limited functionality to admin user
                    visible: state.user.admin,
                    child: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () async {
                        await _settingModalBottomSheet(context);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Desk Booking'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<WorkspaceBloc, WorkspaceState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == WorkspaceStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Something went wrong!'),
                    ),
                  );
              }
            },
          ),
          BlocListener<WorkspaceBloc, WorkspaceState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedWorkspace != current.lastDeletedWorkspace &&
                current.lastDeletedWorkspace != null,
            listener: (context, state) {
              final deletedWorkspace = state.lastDeletedWorkspace!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      deletedWorkspace.name!,
                    ),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<WorkspaceBloc>()
                            .add(const WorkspaceUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<WorkspaceBloc, WorkspaceState>(
          builder: (context, state) {
            if (state.workspaces.isEmpty) {
              if (state.status == WorkspaceStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.status != WorkspaceStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    'There are no Workspaces available',
                    style: Theme.of(context).textTheme.caption,
                  ),
                );
              }
            }
            print(state.workspaces.length);
            return GroupedListView<Workspace, String>(
              elements: state.workspaces,
              groupBy: (element) => element.office!.name,
              groupSeparatorBuilder: (value) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Text(value),
              ),
              useStickyGroupSeparators: true, // optional
              itemBuilder: (context, element) {
                return Card(
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            context
                                .read<WorkspaceBloc>()
                                .add(DeleteWorkspace(element));
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        SlidableAction(
                          onPressed: (BuildContext context) =>
                              context.beamToNamed(
                            '/home/newEditWorkspace?workspace=${element.id}&name=${element.name}',
                          ),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.work),
                      title: Text(element.name!),
                      onTap: () =>
                          context..beamToNamed('/home/timeslots/${element.id}'),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
