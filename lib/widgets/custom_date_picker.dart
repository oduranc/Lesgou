import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../util/colors.dart';
import '../util/constants.dart';

class CustomDatePicker extends StatelessWidget {
  CustomDatePicker(
      {Key? key, required this.controller, required this.text, this.validator})
      : super(key: key);
  final TextEditingController controller;
  final String text;
  final String? Function(String?)? validator;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: text,
      ),
      validator: validator,
      controller: controller,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        DatePicker.showDateTimePicker(
          context,
          showTitleActions: true,
          onConfirm: (date) {
            selectedDate = date;
            controller.text = selectedDate.toString();
          },
          currentTime: selectedDate ?? DateTime.now(),
          locale: LocaleType.en,
          theme: DatePickerTheme(
            backgroundColor: quaternary,
            itemStyle: helloStyle,
            cancelStyle: helloStyle.copyWith(
              color: Colors.black,
            ),
            doneStyle: nameStyle,
          ),
        );
      },
    );
  }
}
