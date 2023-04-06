import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lesgou/classes/custom_appointment.dart';
import 'package:lesgou/screens/add_form.dart';
import 'package:lesgou/util/constants.dart';
import 'package:lesgou/widgets/custom_calendar.dart';

import '../classes/event_data_source.dart';
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
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text('Calendar', style: nameStyle.copyWith(color: Colors.black)),
          Expanded(child: CustomCalendar(events: events)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddForm(context);
        },
        backgroundColor: primary,
        foregroundColor: quaternary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void showAddForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: quaternary,
          titleTextStyle: nameStyle.copyWith(color: Colors.black),
          scrollable: true,
          title: const Text('Add appointment'),
          content: AddForm(
            auth: _auth,
            database: database,
            onDispose: getData,
          ),
        );
      },
    );
  }

  void getData() {
    getDataFromFirestore().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
  }

  Future<void> getDataFromFirestore() async {
    var snapshotsValue = await database
        .collection('Users')
        .doc(_auth.currentUser!.email)
        .collection('Appointments')
        .get();

    List<CustomAppointment> list = snapshotsValue.docs
        .map((e) => CustomAppointment(
              id: e.data()['Key'],
              subject: e.data()['Subject'],
              startTime: e.data()['StartTime'].toDate(),
              endTime: e.data()['EndTime'].toDate(),
              color: Color(e.data()['Color']).withOpacity(1),
              isAllDay: e.data()['IsAllDay'],
              notes: e.data()['Notes'],
              location: e.data()['Location'],
              recurrenceRule: e.data()['RecurrenceRule'],
              done: e.data()['Done'],
            ))
        .toList();
    setState(() {
      events = EventDataSource(list);
    });
  }
}
