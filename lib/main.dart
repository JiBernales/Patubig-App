import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:patubig_app/core/services/auth_service.dart';
import 'package:patubig_app/features/auth/view/login_screen.dart';
import 'package:patubig_app/features/farm/view/weather_stats_screen.dart';
import 'package:patubig_app/firebase_options.dart';
import 'package:provider/provider.dart';

import 'core/services/firebase_service.dart';
import 'core/utils/constants.dart';
import 'features/farm/view/widgets/map_card.dart';
import 'features/farm/viewmodel/farm_viewmodel.dart';
import 'features/weather/view/weather_calendar_screen.dart';
import 'features/weather/viewmodel/weather_viewmodel.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (_, authVm, __) {
        // Show the dashboard when already authenticated.
        if (authVm.user != null) return const MainScreen();
        // Otherwise fall back to Login.
        return const LoginScreen();
        // return const MainScreen();
      },
    );
  }
}

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
        ChangeNotifierProvider(create: (_) => AuthViewModel(AuthService())),
        ChangeNotifierProvider(create: (_) => FarmWeatherViewModel()),
        ChangeNotifierProvider(create: (_) => WeatherViewModel()),
      ],
      child: MaterialApp(
        title: 'Patubig',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32),
            brightness: Brightness.light,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthGate(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const WeatherStatsScreen(),
    const WeatherCalendarScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: Stack(
        children: [
          const MapCard(),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.2,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsetsGeometry.only(top: MediaQuery.of(context).size.height*0.025),
                  children: [
                    UserProfileCard(),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.15,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                        ),
                        padding: EdgeInsetsGeometry.all(0),
                        child: NavigationBar(
                          elevation: 0,
                          selectedIndex: _selectedIndex,
                          onDestinationSelected: _onItemTapped,
                          backgroundColor: Colors.white,
                          shadowColor: Colors.white,
                          indicatorColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                          destinations: const [
                            NavigationDestination(
                              icon: Icon(Icons.sensors_outlined),
                              selectedIcon: Icon(Icons.sensors_rounded),
                              label: 'MGA SENSOR',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.cloud_queue_outlined),
                              selectedIcon: Icon(Icons.cloud_rounded),
                              label: 'PANAHON',
                            ),
                            /*NavigationDestination(
                            icon: Icon(Icons.eco_outlined),
                            selectedIcon: Icon(Icons.eco_rounded),
                            label: 'Pagtanum',
                          ),*/
                          ],
                        )
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: _pages[_selectedIndex],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      )

    );
  }
}

class UserProfileCard extends StatefulWidget {
  const UserProfileCard({super.key});

  @override
  _UserProfileCardState createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsetsGeometry.only(bottom: MediaQuery.of(context).size.height*0.015, left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<AuthViewModel>(
                    builder: (_, authVm, __) {
                      final user = authVm.user;

                      // Prefer the saved full name.  Fallbacks only if nothing was stored.
                      final fullName = user?.displayName?.trim();
                      final label = (fullName != null && fullName.isNotEmpty)
                          ? fullName
                          : 'Bagong Magsasaka'; // or use user?.phoneNumber

                      return Text(
                        label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.0025),
                  const Text(
                    "PD Monfort North, Dumangas",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 28,
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
