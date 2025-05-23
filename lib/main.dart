import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:patubig_app/features/farm/view/weather_stats_screen.dart';
import 'package:patubig_app/features/weather/view/planting_calendar_screen.dart';
import 'package:patubig_app/firebase_options.dart';
import 'package:provider/provider.dart';

import 'core/services/firebase_service.dart';
import 'core/utils/constants.dart';
import 'features/farm/view/widgets/map_card.dart';
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
        home: const MainScreen(),
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
    // const PlantingCalendarScreen()
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
          SingleChildScrollView(
            child: const MapCard(),
          ),
            /*CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.1,
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
            ],
          ),*/
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.8,
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
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: NavigationBar(
                        elevation: 0,
                        selectedIndex: _selectedIndex,
                        onDestinationSelected: _onItemTapped,
                        backgroundColor: Colors.white,
                        indicatorColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        height: 80,
                        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                        destinations: const [
                          NavigationDestination(
                            icon: Icon(Icons.dashboard_outlined, size: 28),
                            selectedIcon: Icon(Icons.dashboard_rounded, size: 30),
                            label: 'SENSOR',
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.cloud_queue_outlined, size: 28),
                            selectedIcon: Icon(Icons.cloud_rounded, size: 30),
                            label: 'PANAHON',
                          ),
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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kristan Jay Gabay",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
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