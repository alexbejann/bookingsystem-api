import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend/app/model/workspace.dart';
import 'package:frontend/bookings/bookings.dart';
import 'package:frontend/chat_admin/chat_admin.dart';
import 'package:frontend/home/bloc/workspace_bloc.dart';
import 'package:frontend/home/repositories/workspace_repository.dart';
import 'package:frontend/l10n/l10n.dart';
import 'package:frontend/new_edit_office/new_edit_office.dart';
import 'package:frontend/new_edit_workspace/new_edit_workspace.dart';
import 'package:frontend/timeslots/timeslots.dart';
import 'package:grouped_list/grouped_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WorkspaceRepository(),
      child: BlocProvider(
        create: (context) => WorkspaceBloc(
            workspaceRepository: context.read<WorkspaceRepository>(),),
        child: const HomeView(),
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void pushPage(BuildContext context, Widget nextPage) {
    Navigator.push<MaterialPageRoute>(
      context,
      MaterialPageRoute(
        builder: (context) => nextPage,
      ),
    );
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
                pushPage(context, const MyBookingsPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Chat Admin'),
              onTap: () {
                //todo go to admin chat with socket io
                pushPage(context, const ChatAdmin());
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
              onTap: () => pushPage(
                context,
                const NewEditOfficePage(
                  isNewOffice: true,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename office'),
              onTap: () => pushPage(context, const NewEditOfficePage()),
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
  void initState() {
    super.initState();
    context.read<WorkspaceBloc>().add(const GetWorkspaces());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        onPressed: () => pushPage(
          context,
          NewEditWorkspacePage(),
        ),
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
                          onPressed: (BuildContext context) => pushPage(
                            context,
                            NewEditWorkspaceView(
                              editWorkspace: element,
                            ),
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
                      title: Text(element.name),
                      onTap: () => context
                        ..beamToNamed('/home/timeslots/${element.id}'),
                    ),
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
    );
  }
}
