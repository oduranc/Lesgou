import 'package:flutter/material.dart';
import 'package:lesgou/util/constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../util/colors.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text('Calendar', style: nameStyle.copyWith(color: Colors.black)),
          Expanded(
            child: SfCalendar(
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
              dataSource: EventDataSource(getAppointments()),
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
            ),
          ),
        ],
      ),
    );
  }
}

List<Appointment> getAppointments() {
  List<Appointment> events = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));

  events.add(Appointment(
    startTime: startTime,
    endTime: endTime,
    subject: 'Conference',
    color: Colors.green,
  ));

  events.add(Appointment(
    startTime: startTime.add(const Duration(hours: 1)),
    endTime: endTime,
    location: 'Here',
    notes: 'Notas',
    subject: 'Conference',
    color: Colors.blue,
    recurrenceRule: 'FREQ=DAILY;COUNT=10',
    isAllDay: true,
  ));

  return events;
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> source) {
    appointments = source;
  }
}
