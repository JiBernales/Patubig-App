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
// Removed WeatherCalendarScreen import as it's no longer used
// import 'features/weather/view/weather_calendar_screen.dart';
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
            seedColor: const Color(0xFF1976D2), // Blue primary
            brightness: Brightness.light,
            primary: const Color(0xFF1976D2),
            secondary: const Color(0xFF42A5F5),
            surface: Colors.white,
            background: const Color(0xFFE3F2FD),
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.black,
            onBackground: Colors.black,
            error: Colors.red,
            onError: Colors.white,
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
            backgroundColor: Color(0xFF1976D2),
            foregroundColor: Colors.white,
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
  // Removed _selectedIndex as there are no tabs
  // Removed _pages list, we will directly use WeatherStatsScreen

  // Removed _onItemTapped method

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
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
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
                    // Use EdgeInsets.only
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01),
                    children: [
                      const SmartFarmHeader(), // Replaced UserProfileCard
                      // Keep the drag handle
                      Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0), // Added margin for spacing
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      // Removed the NavigationBar
                      // Display only the WeatherStatsScreen (Mga Sensor page)
                      Container(
                        // Adjust height as needed, or let it expand
                        // Using a large height to allow scrolling within the list
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: const WeatherStatsScreen(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ));
  }
}

class SmartFarmHeader extends StatefulWidget {
  const SmartFarmHeader({super.key});

  @override
  _SmartFarmHeaderState createState() => _SmartFarmHeaderState();
}

class _SmartFarmHeaderState extends State<SmartFarmHeader>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    ));

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.elasticOut,
    ));

    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        // Use EdgeInsets.only
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.01,
            left: MediaQuery.of(context).size.width * 0.02,
            right: MediaQuery.of(context).size.width * 0.02),
        child: SlideTransition(
          position: _headerSlideAnimation,
          child: FadeTransition(
            opacity: _headerFadeAnimation,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green.shade600,
                    Colors.blue.shade600,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade200,
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
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
                            final label = (fullName != null &&
                                    fullName.isNotEmpty)
                                ? fullName
                                : 'Bagong Magsasaka'; // or use user?.phoneNumber

                            return Text(
                              label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'PD Monfort North, Dumangas',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ⬇️ put this where the old Wi-Fi icon was
                  GestureDetector(
                    onTap: () async {
                      // read the provider without listening to avoid a rebuild loop
                      await context.read<AuthViewModel>().signOut();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        // red tint + stroke helps users recognise “logout”
                        color: Colors.red.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.redAccent,
                          width: 1.4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
