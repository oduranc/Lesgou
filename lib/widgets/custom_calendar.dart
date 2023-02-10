import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../classes/event_data_source.dart';
import '../util/colors.dart';
import '../util/constants.dart';

class CustomCalendar extends StatelessWidget {
  const CustomCalendar({Key? key, required this.events}) : super(key: key);
  final EventDataSource? events;

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      viewHeaderStyle: ViewHeaderStyle(
        dayTextStyle: grayDisclaimerStyle.copyWith(
            fontWeight: FontWeight.w700, fontSize: 15),
        dateTextStyle: grayDisclaimerStyle.copyWith(
            fontWeight: FontWeight.w700, fontSize: 15),
      ),
      timeSlotViewSettings: const TimeSlotViewSettings(
        allDayPanelColor: tertiary,
        timeTextStyle: TextStyle(
          fontSize: 14,
          fontFamily: 'Nunito',
          color: secondary,
          fontWeight: FontWeight.w700,
        ),
      ),
      allowViewNavigation: true,
      allowedViews: const [
        CalendarView.day,
        CalendarView.week,
        CalendarView.month,
        CalendarView.timelineDay,
        CalendarView.timelineMonth,
        CalendarView.timelineWeek,
        CalendarView.schedule,
      ],
      selectionDecoration: BoxDecoration(
        border: Border.all(color: primary),
      ),
      headerStyle: CalendarHeaderStyle(
        textStyle: nameStyle.copyWith(color: Colors.black),
      ),
      headerHeight: 75,
      todayTextStyle: nameStyle.copyWith(color: quaternary),
      todayHighlightColor: primary,
      showNavigationArrow: true,
      showDatePickerButton: true,
      allowDragAndDrop: true,
      dragAndDropSettings: DragAndDropSettings(
        allowNavigation: true,
        allowScroll: true,
        autoNavigateDelay: const Duration(seconds: 1),
        indicatorTimeFormat: 'HH:mm a',
        showTimeIndicator: true,
        timeIndicatorStyle: grayDisclaimerStyle.copyWith(fontSize: 10),
      ),
      dataSource: events,
      appointmentTextStyle: const TextStyle(
        fontSize: 14,
        fontFamily: 'Nunito',
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      monthViewSettings: const MonthViewSettings(
        showAgenda: true,
        agendaStyle: AgendaStyle(
          appointmentTextStyle: TextStyle(
            fontSize: 14,
            fontFamily: 'Nunito',
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          dayTextStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'Nunito',
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
          dateTextStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'Nunito',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
