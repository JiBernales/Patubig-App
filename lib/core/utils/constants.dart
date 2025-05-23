import 'package:flutter/material.dart';

class AppColors {
  static const primary = Colors.blue;
  static const secondary = Colors.green;
  static const background = Colors.white;
  static const text = Colors.black;
}

class AppText {
  static const appName = 'Patubig';
  static const farmTitle = 'Farm Overview';
  static const weatherTitle = 'Weather Calendar';
}

class AppRoutes {
  static const farm = '/';
  static const weather = '/weather';
}

/// Internal suffix so `0917…` becomes a valid e-mail for Firebase.
const String kPhoneEmailDomain = '@patubig.app';