import 'package:flutter/material.dart';
import 'package:frontend/timeslots/view/widgets/status.dart';
import 'package:frontend/timeslots/view/widgets/timeslot_date.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('TimeSlots'),
            TimeSlotDate(initialDate: DateTime.now())
          ],
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(height: 1),
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('8:00'),
            subtitle: const Status(
              isReserved: false,
            ),

            /// Disable onTap when the timeslot is reserved
            onTap: () async {
              /// Show confirmation dialog to book the spot
              final result = await _showMyDialog(context);
              print('Go to timeslots $index');
            },
          );
        },
      ),
    );
  }
}
