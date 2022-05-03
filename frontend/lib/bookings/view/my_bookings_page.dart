import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend/bookings/bloc/booking_bloc.dart';
import 'package:frontend/timeslots/repositories/timeslot_repository.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TimeslotRepository(),
      child: BlocProvider(
        create: (context) => BookingBloc(
          timeslotRepository: context.read<TimeslotRepository>(),
        )..add(const GetBookings()),
        child: const MyBookingsView(),
      ),
    );
  }
}

class MyBookingsView extends StatefulWidget {
  const MyBookingsView({Key? key}) : super(key: key);

  @override
  State<MyBookingsView> createState() => _MyBookingsViewState();
}

class _MyBookingsViewState extends State<MyBookingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<BookingBloc, BookingState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == BookingStatus.failure) {
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
          BlocListener<BookingBloc, BookingState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedTimeslot != current.lastDeletedTimeslot &&
                current.lastDeletedTimeslot != null,
            listener: (context, state) {
              final deletedWorkspace = state.lastDeletedTimeslot!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      deletedWorkspace.title,
                    ),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<BookingBloc>()
                            .add(const BookingUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state.bookings.isEmpty) {
              if (state.status == BookingStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.status != BookingStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    'There are no bookings available for you!',
                    style: Theme.of(context).textTheme.caption,
                  ),
                );
              }
            }
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                color: Colors.grey,
              ),
              shrinkWrap: true,
              itemCount: state.bookings.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (BuildContext context) =>
                            context.read<BookingBloc>().add(
                                  DeleteBooking(
                                    state.bookings[index],
                                  ),
                                ),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.work),
                    title: Text(
                        'From ${state.bookings[index].from} -> To ${state.bookings[index].to}'),
                    subtitle: Text(state.bookings[index].workspaceID!.name!),
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
