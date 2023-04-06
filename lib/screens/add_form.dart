import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lesgou/util/colors.dart';
import 'package:lesgou/util/constants.dart';

import '../classes/event_data_source.dart';
import '../widgets/custom_check_box.dart';
import '../widgets/custom_color_picker.dart';
import '../widgets/custom_date_picker.dart';

class AddForm extends StatefulWidget {
  const AddForm(
      {required this.database, required this.auth, required this.onDispose});

  final FirebaseFirestore database;
  final FirebaseAuth auth;
  final VoidCallback onDispose;

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();
  late EventDataSource? events;

  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController isAllDayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
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
            validator: (value) {
              if (int.parse(isAllDayController.text) == 1) {
                startTimeController.text = startTimeController.text
                    .replaceFirst(RegExp(r'\d\d:\d\d:00\.000'), '00:00:00.000');
                endTimeController.text = endTimeController.text
                    .replaceFirst(RegExp(r'\d\d:\d\d:00\.000'), '23:59:00.000');
              }
              return null;
            },
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
              if (DateTime.parse(value.toString())
                      .compareTo(DateTime.parse(startTimeController.text)) <
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
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                addAppointment();
                widget.onDispose();
              }
            },
            child: Text('ADD', style: textButtonStyle.copyWith(color: primary)),
          )
        ],
      ),
    );
  }

  void addAppointment() {
    try {
      String key = UniqueKey().toString();
      widget.database
          .collection('Users')
          .doc(widget.auth.currentUser!.email)
          .collection('Appointments')
          .doc(key)
          .set({
        'Key': key,
        'Subject': subjectController.text,
        'StartTime': DateTime.parse(startTimeController.text),
        'EndTime': DateTime.parse(endTimeController.text),
        'Color': int.parse(colorController.text),
        'IsAllDay': int.parse(isAllDayController.text) == 1 ? true : false,
        'Notes': notesController.text,
        'Location': locationController.text,
        'RecurrenceRule': null,
        'Done': false,
      });
      Navigator.pop(context);
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
