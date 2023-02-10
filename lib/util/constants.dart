import 'package:flutter/material.dart';

import 'colors.dart';

const logoTitleStyle = TextStyle(
  fontFamily: 'OrelegaOne',
  fontSize: 40,
  color: quaternary,
);

const titleFormStyle = TextStyle(
  fontFamily: 'Nunito',
  fontSize: 24,
  fontWeight: FontWeight.w700,
);

const grayDisclaimerStyle = TextStyle(
  fontFamily: 'Nunito',
  fontSize: 16,
  color: Colors.grey,
);

const blackDisclaimerStyle = TextStyle(
  fontFamily: 'Nunito',
  fontSize: 16,
);

const textButtonStyle = TextStyle(
  fontFamily: 'Nunito',
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

const textLinkStyle = TextStyle(
  fontFamily: 'Nunito',
  fontSize: 14,
  color: primary,
  decoration: TextDecoration.underline,
);

const nameStyle = TextStyle(
  fontFamily: 'Nunito',
  fontSize: 20,
  color: primary,
  fontWeight: FontWeight.w700,
);

const helloStyle = TextStyle(
  fontFamily: 'Nunito',
  fontSize: 18,
);

ButtonStyle loginButtonStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(40),
  ),
  padding: const EdgeInsets.all(16),
  backgroundColor: primary,
  foregroundColor: quaternary,
  minimumSize: const Size.fromHeight(0),
);

ButtonStyle signupButtonStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(40),
  ),
  padding: const EdgeInsets.all(16),
  backgroundColor: quaternary,
  foregroundColor: primary,
  minimumSize: const Size.fromHeight(0),
);

const BoxDecoration backgroundImage = BoxDecoration(
  color: Colors.black,
  image: DecorationImage(
    fit: BoxFit.cover,
    image: AssetImage('images/background_img.png'),
  ),
);
