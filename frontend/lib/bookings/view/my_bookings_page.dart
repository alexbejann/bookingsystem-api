
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bookings/bloc/booking_bloc.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingBloc(),
      child: MyBookingsView(),
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
    return const Center(child: Text('My Bookings'),);
  }
}

