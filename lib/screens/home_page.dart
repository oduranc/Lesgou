import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lesgou/classes/auth_class.dart';
import 'package:lesgou/classes/custom_appointment.dart';
import 'package:lesgou/util/colors.dart';
import 'package:lesgou/util/constants.dart';

import '../widgets/custom_list_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  final _authService = AuthClass();
  final database = FirebaseFirestore.instance;
  late User loggedInUser;
  String defaultImage =
      'https://cdn-icons-png.flaticon.com/512/1077/1077114.png';

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      _authService.logOut(_auth, context);
    }
  }

  Future<List<CustomAppointment>> getDataFromFirestore() async {
    var snapshotsValue = await database
        .collection('Users')
        .doc(_auth.currentUser!.email)
        .collection('Appointments')
        .where(
          'EndTime',
          isLessThanOrEqualTo: DateTime(DateTime.now().year,
              DateTime.now().month, DateTime.now().day, 23, 59, 59, 59, 59),
          isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
              DateTime.now().month, DateTime.now().day, 00, 00, 00, 00, 00),
        )
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
    return list;
  }

  void changeDone(newValue, item) async {
    try {
      await database
          .collection('Users')
          .doc(_auth.currentUser!.email)
          .collection('Appointments')
          .doc(item.id)
          .update({'Done': newValue});
      setState(() {
        item.done = newValue!;
      });
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(
        msg: e.message.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error changing status.',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 30,
              backgroundImage:
                  NetworkImage(loggedInUser.photoURL ?? defaultImage),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Hello there,', style: helloStyle),
                Text(
                  loggedInUser.displayName!.split(' ').sublist(0, 1).join(),
                  style: nameStyle,
                ),
              ],
            ),
          ],
        ),
        FutureBuilder(
          future: getDataFromFirestore(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                Fluttertoast.showToast(msg: 'Error on loading data');
              }
              return Expanded(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 30),
                    RichText(
                      text: TextSpan(
                        text: 'You have ',
                        style: titleFormStyle.copyWith(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  '${snapshot.data!.where((element) => element.done == false).length} tasks',
                              style: const TextStyle(color: primary)),
                          const TextSpan(text: ' for today.'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemBuilder: (context, index) {
                          CustomAppointment item = snapshot.data![index];
                          return CustomListTile(
                            item: item,
                            database: database,
                            auth: _auth,
                            onChange: (newValue) {
                              changeDone(newValue, item);
                            },
                          );
                        },
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );
  }
}
