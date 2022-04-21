import 'package:flutter/material.dart';
import 'package:frontend/add_timeslot/add_timeslot.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// This page should contain all the timeslots from 9 to 17.00
/// onTap on a timeslot should display either if the user wants to reserve
/// the desk at that time. If the timeslot is reserved a warning should be
/// displayed. The warning would be a popup with an ok button.
/// If the timeslot is available the popup would have to ask the user if
/// he is sure that he wants to book the tapped time
/// The system would support only one hour of booking
class TimeslotsPage extends StatefulWidget {
  const TimeslotsPage({Key? key}) : super(key: key);

  static const String routeName = '/timeslots';

  @override
  State<TimeslotsPage> createState() => _TimeslotsPageState();
}

class _TimeslotsPageState extends State<TimeslotsPage> {
  Future<bool?> _showMyDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: const [Icon(Icons.warning), Text(' Are you sure?')],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text('Would you like to book this timeslot?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  Future<void> addBooking(CalendarTapDetails calendarTapDetails) async {
    if (calendarTapDetails.appointments == null) {
      ///todo navigate to add timeslot page
      ///todo with the initial datetime from calendar tap details
      await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.warning),
              Text('Would you like to book?'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.push<MaterialPageRoute>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTimeSlotPage(
                      calendarTapDetails: calendarTapDetails,
                    ),
                  ),
                ).then((value) {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        ),
      );
      return;
    } else if (calendarTapDetails.appointments!.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('There is already a reservation!')),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TimeSlots'),
      ),
      body: SfCalendar(
        onTap: addBooking,
        view: CalendarView.workWeek,
        firstDayOfWeek: 1,
        dataSource: _getCalendarDataSource(),
        timeSlotViewSettings: const TimeSlotViewSettings(
          timeIntervalHeight: 100,
          startHour: 9,
          endHour: 17,
        ),
      ),
    );
  }
}

BookingDataSource _getCalendarDataSource() {
  List<Booking> meetings = <Booking>[];
  meetings.add(Booking(
      bookingTitle: 'Workspace',
      from: DateTime(2022, 4, 21, 10),
      to: DateTime(2022, 4, 21, 12)));

  return BookingDataSource(meetings);
}

class BookingDataSource extends CalendarDataSource {
  BookingDataSource(List<Booking> source) {
    appointments = source;
  }

  Booking getBooking(int index) => appointments![index] as Booking;

  @override
  DateTime getStartTime(int index) {
    return getBooking(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return getBooking(index).to;
  }

  @override
  String getSubject(int index) {
    return getBooking(index).bookingTitle;
  }
}

class Booking {
  Booking({
    this.bookingTitle = '',
    required this.from,
    required this.to,
    this.background = Colors.red,
  });

  String bookingTitle;
  DateTime from;
  DateTime to;
  Color background;
}
