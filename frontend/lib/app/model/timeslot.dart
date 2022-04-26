
import 'package:flutter/material.dart';

class Timeslot {

  Timeslot({
    this.title = '',
    required this.from,
    required this.to,
    required this.userID,
    required this.officeID,
  });

  String title;
  DateTime from;
  DateTime to;
  String userID;
  String officeID;
}
