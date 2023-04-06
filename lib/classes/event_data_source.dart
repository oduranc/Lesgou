import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'custom_appointment.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<CustomAppointment> source) {
    appointments = source;
  }

  @override
  String getSubject(int index) {
    return appointments![index].subject;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endTime;
  }

  @override
  Color getColor(int index) {
    return appointments![index].color;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getNotes(int index) {
    return appointments![index].notes;
  }

  @override
  String getLocation(int index) {
    return appointments![index].location;
  }

  @override
  String? getRecurrenceRule(int index) {
    return appointments![index].recurrenceRule;
  }
}
