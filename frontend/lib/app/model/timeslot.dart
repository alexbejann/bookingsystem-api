
import 'package:flutter/material.dart';

class Timeslot {

  Timeslot({
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
