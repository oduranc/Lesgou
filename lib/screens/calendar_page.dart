import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lesgou/util/constants.dart';
import 'package:lesgou/widgets/custom_calendar.dart';
import 'package:lesgou/widgets/custom_date_picker.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../util/colors.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  EventDataSource? events;
  final _auth = FirebaseAuth.instance;
  final database = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getDataFromFirestore().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController startTimeController = TextEditingController();
    TextEditingController endTimeController = TextEditingController();

    return Scaffold(
      body: Column(
        children: <Widget>[
          Text('Calendar', style: nameStyle.copyWith(color: Colors.black)),
          Expanded(child: CustomCalendar(events: events)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                titleTextStyle: nameStyle.copyWith(color: Colors.black),
                scrollable: true,
                title: const Text('Add appointment'),
                content: Form(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Subject',
                        ),
                        keyboardType: TextInputType.name,
                      ),
                      CustomDatePicker(
                          text: 'Start Time', controller: startTimeController),
                      CustomDatePicker(
                          text: 'End Time', controller: endTimeController),
                    ],
                  ),
                ),
              );
            },
          );
        },
        backgroundColor: primary,
        foregroundColor: quaternary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> getDataFromFirestore() async {
    var snapshotsValue = await database
        .collection("Users")
        .doc(_auth.currentUser!.email)
        .collection('Appointments')
        .get();

    List<Appointment> list = snapshotsValue.docs
        .map((e) => Appointment(
              subject: e.data()['Subject'],
              startTime: e.data()['StartTime'].toDate(),
              endTime: e.data()['EndTime'].toDate(),
              color: Color(e.data()['Color']),
              isAllDay: e.data()['IsAllDay'],
              notes: e.data()['Notes'],
              location: e.data()['Location'],
              recurrenceRule: e.data()['RecurrenceRule'],
            ))
        .toList();
    setState(() {
      events = EventDataSource(list);
    });
  }

  void addAppointment() {
    database
        .collection("Users")
        .doc(_auth.currentUser!.email)
        .collection('Appointments')
        .doc()
        .set({
      'Subject': 'Math class',
      'StartTime': DateTime.now(),
      'EndTime': DateTime.now().add(const Duration(hours: 2)),
      'Color': Colors.blue.value,
      'IsAllDay': false,
      'Notes': 'GC205',
      'Location': 'INTEC',
      'RecurrenceRule': null,
    });
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> source) {
    appointments = source;
  }
}
