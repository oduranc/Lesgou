import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  CustomCheckBox({Key? key, required this.text, required this.controller})
      : super(key: key);
  final String text;
  final TextEditingController controller;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool isAllDay = false;

  void changeValue(bool? value) {
    setState(() => isAllDay = value!);
    widget.controller.text = value! ? "1" : "0";
  }

  @override
  void initState() {
    changeValue(isAllDay);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.text,
        suffixIcon: Checkbox(
          value: isAllDay,
          onChanged: changeValue,
        ),
      ),
      readOnly: true,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }
}
