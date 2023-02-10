import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lesgou/screens/welcome_page.dart';
import 'package:lesgou/util/colors.dart';
import 'package:lesgou/widgets/common_hud.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(Lesgou()));
}

class Lesgou extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primary,
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: quaternary,
      ),
      title: 'Lesgou',
      home: FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong.');
          } else if (snapshot.hasData) {
            if (FirebaseAuth.instance.currentUser != null) {
              return const CommonHUD();
            } else {
              return const WelcomePage();
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      routes: {
        CommonHUD.route: (context) => const CommonHUD(),
        WelcomePage.route: (context) => const WelcomePage(),
      },
    );
  }
}
