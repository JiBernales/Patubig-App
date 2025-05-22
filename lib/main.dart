import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:patubig_app/firebase_options.dart';
import 'package:provider/provider.dart';

import 'core/services/firebase_service.dart';
import 'core/utils/constants.dart';
import 'features/farm/view/farm_screen.dart';
import 'features/farm/viewmodel/farm_viewmodel.dart';
import 'features/weather/view/weather_calendar_screen.dart';
import 'features/weather/viewmodel/weather_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PatubigApp());
}

class PatubigApp extends StatelessWidget {
  const PatubigApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FarmViewModel()),
        ChangeNotifierProvider(create: (_) => WeatherViewModel()),
      ],
      child: MaterialApp(
        title: 'Patubig',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const FarmScreen(),
          '/weather': (context) => const WeatherCalendarScreen(),
        },
      ),
    );
  }
}