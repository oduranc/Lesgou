import 'package:flutter/material.dart';
import 'package:lesgou/util/constants.dart';

import '../util/colors.dart';
import '../widgets/custom_button.dart';
import 'login_form.dart';
import 'register_form.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  static const String route = 'welcome';

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundImage,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 41),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            DefaultTextStyle(style: logoTitleStyle, child: Text('LESGOU')),
            Column(
              children: <Widget>[
                CustomButton(
                  text: 'Log In',
                  buttonStyle: loginButtonStyle,
                  action: () => _buildBottomSheet(context, loginButtonStyle),
                ),
                const SizedBox(height: 31),
                CustomButton(
                  text: 'Sign Up',
                  buttonStyle: signupButtonStyle,
                  action: () => _buildBottomSheet(context, signupButtonStyle),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _buildBottomSheet(
      BuildContext context, ButtonStyle buttonStyle) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: quaternary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(40),
        ),
      ),
      context: context,
      builder: (context) {
        if (buttonStyle == loginButtonStyle) {
          return LoginForm();
        } else {
          return RegisterForm();
        }
      },
    );
  }
}
