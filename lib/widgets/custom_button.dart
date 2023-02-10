import 'package:flutter/material.dart';
import 'package:lesgou/util/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.buttonStyle,
      required this.text,
      required this.action});

  final ButtonStyle buttonStyle;
  final String text;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buttonStyle,
      onPressed: action,
      child: Text(text, style: textButtonStyle),
    );
  }
}
