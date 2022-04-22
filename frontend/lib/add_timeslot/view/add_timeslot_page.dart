import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/add_timeslot/add_timeslot.dart';
import 'package:frontend/timeslots/bloc/timeslot_bloc.dart';
import 'package:frontend/utils/utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AddTimeSlotPage extends StatelessWidget {
  const AddTimeSlotPage({Key? key, required this.calendarTapDetails})
      : super(key: key);

  final CalendarTapDetails calendarTapDetails;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimeslotBloc(),
      child: AddTimeslotView(
        calendarTapDetails: calendarTapDetails,
      ),
    );
  }
}

class AddTimeslotView extends StatefulWidget {
  const AddTimeslotView({Key? key, required this.calendarTapDetails})
      : super(key: key);

  final CalendarTapDetails calendarTapDetails;

  @override
  State<AddTimeslotView> createState() => _AddTimeslotViewState();
}

class _AddTimeslotViewState extends State<AddTimeslotView> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;

  List<Widget> buildEditingActions() => [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: saveForm,
          child: const Text('SAVE'),
        ),
      ];

  Widget buildDateTimePickers() => Column(
        children: [
          buildForm(),
          buildTo(),
        ],
      );

  Widget buildForm() => buildHeader(
        header: 'FROM',
        child: Row(
          children: [
            // Expanded(
            //   flex: 2,
            //   child: buildDropdownField(
            //     text: Utils.toDate(fromDate),
            //     onClicked: () => pickFromDateTime(pickDate: true),
            //   ),
            // ),
            Expanded(
              child: buildDropdownField(
                text: Utils.toTime(fromDate),
                onClicked: () => pickFromDateTime(pickDate: false),
              ),
            ),
          ],
        ),
      );

  Widget buildTo() => buildHeader(
        header: 'TO',
        child: Row(
          children: [
            // Expanded(
            //   flex: 2,
            //   child: buildDropdownField(
            //     text: Utils.toDate(toDate),
            //     onClicked: () {},
            //   ),
            // ),
            Expanded(
              child: buildDropdownField(
                text: Utils.toTime(toDate),
                onClicked: () => pickFromDateTime(pickDate: false),
              ),
            ),
          ],
        ),
      );

  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          child,
        ],
      );

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) {
      return;
    }

    /// If is after toDate hour keep it the same so that you won't have shuffled hours
    if (date.isAfter(toDate)) {
      toDate = DateTime(
        fromDate.year,
        fromDate.month,
        fromDate.day,
        date.hour,
        date.minute,
      );
    }

    setState(() => fromDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      //final date = await showDatePicker(context: context, initialDate: initialDate, firstDate: firstDate, lastDate: lastDate)
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
        // builder: (BuildContext context, Widget? child) {
        //   return MediaQuery(
        //       data: MediaQuery.of(context)
        //           .copyWith(alwaysUse24HourFormat: true),
        //       child: child!);
        // }
      );

      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);

      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }
  
  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      ///todo call bloc timeslot bloc to add timeslot
    }
  }

  @override
  void dispose() {
    titleController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    fromDate = widget.calendarTapDetails.date!;
    toDate = widget.calendarTapDetails.date!.add(
      const Duration(hours: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: buildEditingActions(),
        title: Text(Utils.toDate(fromDate)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildDateTimePickers(),
            ],
          ),
        ),
      ),
    );
  }
}
