import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../classes/event_data_source.dart';
import '../widgets/custom_check_box.dart';
import '../widgets/custom_color_picker.dart';
import '../widgets/custom_date_picker.dart';

class AddForm extends StatefulWidget {
  const AddForm(
      {required this.subjectController,
      required this.isAllDayController,
      required this.startTimeController,
      required this.endTimeController,
      required this.notesController,
      required this.locationController,
      required this.colorController,
      required this.database,
      required this.auth});

  final TextEditingController subjectController,
      isAllDayController,
      startTimeController,
      endTimeController,
      colorController,
      notesController,
      locationController;
  final FirebaseFirestore database;
  final FirebaseAuth auth;

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();
  late EventDataSource? events;

  @override
  void initState() {
    cleanAddForm();
    super.initState();
  }

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
            controller: widget.subjectController,
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
            controller: widget.isAllDayController,
          ),
          CustomDatePicker(
            text: 'Start Time',
            controller: widget.startTimeController,
            validator: (value) {
              if (widget.startTimeController.text.isEmpty) {
                return 'Set a start time';
              }
              return null;
            },
          ),
          CustomDatePicker(
            text: 'End Time',
            controller: widget.endTimeController,
            validator: (value) {
              if (widget.startTimeController.text.isEmpty) {
                return 'Set a start time first';
              }
              if (widget.endTimeController.text.isEmpty) {
                return 'Set an end time';
              }
              if (DateTime.parse(value.toString()).compareTo(
                      DateTime.parse(widget.startTimeController.text)) <
                  0) {
                return 'End Time must be later than start time';
              }
              return null;
            },
          ),
          CustomColorPicker(
            text: 'Color',
            controller: widget.colorController,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Notes',
            ),
            controller: widget.notesController,
            minLines: 1,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Location',
            ),
            controller: widget.locationController,
            minLines: 1,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                addAppointment();
              }
            },
            child: const Text('ADD'),
          )
        ],
      ),
    );
  }

  void cleanAddForm() {
    widget.startTimeController.clear();
    widget.endTimeController.clear();
    widget.colorController.clear();
    widget.subjectController.clear();
    widget.notesController.clear();
    widget.locationController.clear();
    widget.isAllDayController.clear();
  }

  void addAppointment() {
    try {
      widget.database
          .collection("Users")
          .doc(widget.auth.currentUser!.email)
          .collection('Appointments')
          .doc()
          .set({
        'Subject': widget.subjectController.text,
        'StartTime': DateTime.parse(widget.startTimeController.text),
        'EndTime': DateTime.parse(widget.endTimeController.text),
        'Color': int.parse(widget.colorController.text),
        'IsAllDay':
            int.parse(widget.isAllDayController.text) == 1 ? true : false,
        'Notes': widget.notesController.text,
        'Location': widget.locationController.text,
        'RecurrenceRule': null,
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
