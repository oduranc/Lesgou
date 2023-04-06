import 'package:flutter/material.dart';

class CustomAppointment {
  CustomAppointment({
    required this.id,
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.isAllDay,
    required this.notes,
    required this.location,
    this.recurrenceRule,
    this.done = false,
  });

  String id;
  String subject;
  DateTime startTime;
  DateTime endTime;
  Color color;
  bool isAllDay;
  String notes;
  String location;
  String? recurrenceRule;
  bool done;
}
