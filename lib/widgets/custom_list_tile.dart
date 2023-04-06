import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesgou/util/colors.dart';
import 'package:lesgou/util/constants.dart';

import '../classes/custom_appointment.dart';

class CustomListTile extends StatefulWidget {
  const CustomListTile({
    super.key,
    required this.item,
    required this.database,
    required this.auth,
    required this.onChange,
  });

  final CustomAppointment item;
  final FirebaseFirestore database;
  final FirebaseAuth auth;
  final void Function(bool?) onChange;

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: GestureDetector(
        onTap: () {
          widget.onChange(!widget.item.done);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Checkbox(
                  activeColor: primary,
                  value: widget.item.done,
                  onChanged: widget.onChange,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.item.subject,
                          style: helloStyle,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '📅    ${widget.item.endTime.toString().substring(0, 16)}',
                          style: grayDisclaimerStyle,
                        ),
                        widget.item.notes != ''
                            ? Text(
                                '📝    ${widget.item.notes}',
                                style: grayDisclaimerStyle,
                              )
                            : const SizedBox(),
                        widget.item.location != ''
                            ? Text(
                                '📌    ${widget.item.location}',
                                style: grayDisclaimerStyle,
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: widget.item.color,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(20),
                    ),
                  ),
                  width: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
