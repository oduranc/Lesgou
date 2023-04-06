import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lesgou/util/constants.dart';

import '../util/colors.dart';

class CustomColorPicker extends StatefulWidget {
  CustomColorPicker({Key? key, required this.text, required this.controller})
      : super(key: key);
  final TextEditingController controller;
  final String text;

  @override
  State<CustomColorPicker> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  late Color selectedColor;

  void changeColor(Color color) {
    setState(() => selectedColor = color);
    widget.controller.text = selectedColor.value.toString();
  }

  @override
  void initState() {
    changeColor(primary);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.text,
        suffixIcon: const Icon(Icons.square),
        suffixIconColor: selectedColor,
      ),
      controller: widget.controller,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(
                'Pick a color!',
                style: nameStyle.copyWith(color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'DONE',
                    style: textButtonStyle.copyWith(color: primary),
                  ),
                )
              ],
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: selectedColor,
                  onColorChanged: changeColor,
                  enableAlpha: false,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
