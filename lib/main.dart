import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:patubig_app/core/services/auth_service.dart';
import 'package:patubig_app/features/auth/view/login_screen.dart';
import 'package:patubig_app/features/farm/view/weather_stats_screen.dart';
import 'package:patubig_app/firebase_options.dart';
import 'package:provider/provider.dart';

import 'core/services/firebase_service.dart';
import 'core/utils/constants.dart';
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

            // Explicitly set scaffold background to white for consistency
            scaffoldBackgroundColor: Colors.white,

            // Customize AppBarTheme for the green and white look
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor:
                  Color(0xFF2E7D32), // Your strong agricultural green
              foregroundColor:
                  Colors.white, // White text and icons on the AppBar
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Customize CardTheme as you already have, ensure it works with the scheme
            cardTheme: CardTheme(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white, // Ensure cards are white
              surfaceTintColor: Colors
                  .transparent, // To prevent Material 3 tinting if not desired
            ),

            // Customize ElevatedButtonTheme for green buttons with white text
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                    0xFF4CAF50), // A slightly brighter green for buttons
                foregroundColor: Colors.white, // White text on the green button
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Customize TextButtonTheme for green text links
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    const Color(0xFF1B5E20), // Darker green for text buttons
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Customize InputDecorationTheme for text form fields
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors
                  .grey.shade50, // A very light grey background for text fields
              labelStyle:
                  const TextStyle(color: Color(0xFF2E7D32)), // Green label
              hintStyle:
                  TextStyle(color: Colors.grey.shade600), // Grey hint text
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: Color(0xFF2E7D32),
                    width: 2), // Green border when focused
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.red.shade700, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.red.shade700, width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),

            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const AuthGate(),
        ));
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "Patubig Farm Monitor",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),
                const UserProfileCard(),
                const SizedBox(height: 8),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey.shade600,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                activeIcon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cloud_queue_rounded),
                activeIcon: Icon(Icons.cloud_queue_rounded),
                label: 'Weather',
              ),
            ],
          ),
        ),
      ),
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
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
              const SizedBox(width: 16),
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
                    const SizedBox(height: 4),
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
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.notifications_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
