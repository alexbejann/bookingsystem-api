import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:frontend/add_timeslot/add_timeslot.dart';
import 'package:frontend/bookings/bookings.dart';
import 'package:frontend/chat_admin/chat_admin.dart';
import 'package:frontend/home/home.dart';
import 'package:frontend/login/login.dart';
import 'package:frontend/new_edit_office/new_edit_office.dart';
import 'package:frontend/new_edit_workspace/new_edit_workspace.dart';
import 'package:frontend/timeslots/timeslots.dart';

class BeamerLocations extends BeamLocation<BeamState> {
  BeamerLocations(RouteInformation routeInformation) : super(routeInformation);

  @override
  List<String> get pathPatterns => [
    '/login',
    '/home',
    '/timeslots',
    '/addTimeslots',
    '/bookings',
    '/chatAdmin',
    '/newEditOffice',
    '/newEditWorkspace',
  ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      if (state.uri.pathSegments.contains('login'))
        const BeamPage(
          key: ValueKey('login'),
          child: LoginPage(),
        ),
      if (state.uri.pathSegments.contains('home'))
        const BeamPage(
          key: ValueKey('home'),
          child: HomePage(),
        ),
      if (state.uri.pathSegments.contains('timeslots'))
        const BeamPage(
          key: ValueKey('timeslots'),
          child: TimeslotsPage(),
        ),
      // if (state.uri.pathSegments.contains('addTimeslots'))
      //   const BeamPage(
      //     key: ValueKey('addTimeslots'),
      //     child: AddTimeSlotPage(calendarTapDetails: ),
      //   ),
      if (state.uri.pathSegments.contains('bookings'))
        const BeamPage(
          key: ValueKey('bookings'),
          child: MyBookingsPage(),
        ),
      if (state.uri.pathSegments.contains('chatAdmin'))
        const BeamPage(
          key: ValueKey('chatAdmin'),
          child: ChatAdmin(),
        ),
      // if (state.uri.pathSegments.contains('newEditOffice'))
      //   const BeamPage(
      //     key: ValueKey('newEditOffice'),
      //     child: NewEditOfficePage(isNewOffice: (state.queryParameters['isNewOffice'] as bool),),
      //   ),
      if (state.uri.pathSegments.contains('newEditWorkspace'))
        const BeamPage(
          key: ValueKey('newEditWorkspace'),
          child: NewEditWorkspacePage(),
        ),

    ];
  }
}
