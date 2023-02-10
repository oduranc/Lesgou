import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesgou/screens/welcome_page.dart';
import 'package:lesgou/util/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
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
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 30,
          backgroundImage: NetworkImage(loggedInUser.photoURL ?? defaultImage),
        ),
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
        ElevatedButton(
          onPressed: () {
            _auth.signOut();
            Navigator.pushNamed(context, WelcomePage.route);
          },
          child: Text('Log Out'),
        ),
      ],
    );
  }
}