import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lesgou/util/constants.dart';
import 'package:lesgou/widgets/custom_calendar.dart';
import 'package:lesgou/widgets/custom_check_box.dart';
import 'package:lesgou/widgets/custom_date_picker.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../classes/event_data_source.dart';
import '../util/colors.dart';
import '../widgets/custom_color_picker.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  EventDataSource? events;
  final _auth = FirebaseAuth.instance;
  final database = FirebaseFirestore.instance;

  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController isAllDayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Column(
        children: <Widget>[
          Text('Calendar', style: nameStyle.copyWith(color: Colors.black)),
          Expanded(child: CustomCalendar(events: events)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cleanAddForm();
          showAddForm(context, _formKey);
        },
        backgroundColor: primary,
        foregroundColor: quaternary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void showAddForm(BuildContext context, GlobalKey<FormState> _formKey) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: quaternary,
          titleTextStyle: nameStyle.copyWith(color: Colors.black),
          scrollable: true,
          title: const Text('Add appointment'),
          content: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                  ),
                  controller: subjectController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                CustomCheckBox(
                  text: 'Is all day?',
                  controller: isAllDayController,
                ),
                CustomDatePicker(
                  text: 'Start Time',
                  controller: startTimeController,
                  validator: (value) {
                    if (startTimeController.text.isEmpty) {
                      return 'Set a start time';
                    }
                    return null;
                  },
                ),
                CustomDatePicker(
                  text: 'End Time',
                  controller: endTimeController,
                  validator: (value) {
                    if (startTimeController.text.isEmpty) {
                      return 'Set a start time first';
                    }
                    if (endTimeController.text.isEmpty) {
                      return 'Set an end time';
                    }
                    if (DateTime.parse(value.toString()).compareTo(
                            DateTime.parse(startTimeController.text)) <
                        0) {
                      return 'End Time must be later than start time';
                    }
                    return null;
                  },
                ),
                CustomColorPicker(
                  text: 'Color',
                  controller: colorController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                  ),
                  controller: notesController,
                  minLines: 1,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Location',
                  ),
                  controller: locationController,
                  minLines: 1,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  addAppointment();
                }
              },
              child: const Text('ADD'),
            ),
          ],
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
        .collection("Users")
        .doc(_auth.currentUser!.email)
        .collection('Appointments')
        .get();

    List<Appointment> list = snapshotsValue.docs
        .map((e) => Appointment(
              subject: e.data()['Subject'],
              startTime: e.data()['StartTime'].toDate(),
              endTime: e.data()['EndTime'].toDate(),
              color: Color(e.data()['Color']).withOpacity(1),
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

  void cleanAddForm() {
    startTimeController.clear();
    endTimeController.clear();
    colorController.clear();
    subjectController.clear();
    notesController.clear();
    locationController.clear();
    isAllDayController.clear();
  }

  void addAppointment() {
    try {
      database
          .collection("Users")
          .doc(_auth.currentUser!.email)
          .collection('Appointments')
          .doc()
          .set({
        'Subject': subjectController.text,
        'StartTime': DateTime.parse(startTimeController.text),
        'EndTime': DateTime.parse(endTimeController.text),
        'Color': int.parse(colorController.text),
        'IsAllDay': int.parse(isAllDayController.text) == 1 ? true : false,
        'Notes': notesController.text,
        'Location': locationController.text,
        'RecurrenceRule': null,
      });
      Navigator.pop(context);
      getData();
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(
        msg: e.message.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error on loading data. Try again later.',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }
}
