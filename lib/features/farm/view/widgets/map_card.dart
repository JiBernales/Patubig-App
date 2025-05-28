import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/farm_viewmodel.dart';
import 'package:patubig_app/core/services/firebase_farm_service.dart';

class MapCard extends StatefulWidget {
  const MapCard({super.key});

  @override
  _MapCardState createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Instantiate FirebaseService
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmWeatherViewModel>(
      builder: (context, viewModel, child) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  margin: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.grey.shade50,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        blurRadius: 10,
                        spreadRadius: -5,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: viewModel.currentLocation == null
                      ? _buildLoadingState()
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              IgnorePointer(
                                child: FlutterMap(
                                  mapController: viewModel.mapController,
                                  options: MapOptions(
                                    initialCenter:
                                        viewModel.currentLocation!.latLng,
                                    initialRotation: 50,
                                    initialZoom: 14.7,
                                    maxZoom: 20.5,
                                    minZoom: 11.0,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                                      subdomains: const ['a', 'b', 'c', 'd'],
                                    ),
                                    MarkerLayer(
                                      rotate: false,
                                      markers: [
                                        // Marker(
                                        //   point: LatLng(_currentPosition.latitude,
                                        //       _currentPosition.longitude),
                                        //   width: 60,
                                        //   height: 60,
                                        //   child: Column(
                                        //     mainAxisSize: MainAxisSize.min,
                                        //     children: const [
                                        //       Icon(
                                        //         Icons.location_pin,
                                        //         color: Colors.red,
                                        //         size: 40,
                                        //       ),
                                        //       Text(
                                        //         "You",
                                        //         style: TextStyle(
                                        //             fontSize: 12,
                                        //             fontWeight: FontWeight.bold),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        Marker(
                                          point: const LatLng(
                                              10.865162, 122.738167),
                                          width: 60,
                                          height: 60,
                                          child: Transform.rotate(
                                            angle:
                                                -0.85, // in radians, e.g. 0.5 ~ 28.6°
                                            child: const Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.sensors,
                                                    color: Colors.green,
                                                    size: 40),
                                                Text(
                                                  "Farm 002",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Marker(
                                          point: const LatLng(
                                              10.857623, 122.731182),
                                          width: 60,
                                          height: 60,
                                          child: Transform.rotate(
                                            angle:
                                                -0.85, // in radians, e.g. 0.5 ~ 28.6°
                                            child: const Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.sensors,
                                                    color: Colors.blue,
                                                    size: 40),
                                                Text(
                                                  "Farm 001",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Marker(
                                          point: const LatLng(
                                              10.855813, 122.741552),
                                          width: 60,
                                          height: 60,
                                          child: Transform.rotate(
                                            angle:
                                                -0.85, // in radians, e.g. 0.5 ~ 28.6°
                                            child: const Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.sensors,
                                                    color: Colors.orange,
                                                    size: 40),
                                                Text(
                                                  "Farm 003",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // _buildMapOverlay(),
                              _buildIrrigationQueueOverlay(),
                            ],
                          ),
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade50,
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading Map...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedMarker(IconData icon, Color color,
      {double size = 28, bool isPrimary = false}) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (isPrimary ? 200 : 0)),
      curve: Curves.bounceOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Transform.rotate(
            // ADD THIS Transform.rotate
            angle:
                0, // No rotation since MapController does not have a rotation property
            child: Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: color,
                size: size,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapOverlay() {
    return Positioned(
      top: 16,
      left: 16, // Changed to left to make space for the queue on the right
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.map,
              size: 16,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              'Farm Location',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NEW: Widget to display the irrigation queue
// TOP-RIGHT overlay – queue + virtual-reservoir --------------------------------
  Widget _buildIrrigationQueueOverlay() {
    // We nest two StreamBuilders so each piece (queue / reservoir) can refresh
    // independently without writing extra boilerplate.  The outer one listens
    // to the reservoir, the inner one to the queue.
    return Positioned(
      top: 38,
      right: 2,
      child: StreamBuilder<double?>(
        stream: _firebaseService.getVirtualReservoirStream(),
        builder: (context, reservoirSnap) {
          final reservoir = reservoirSnap.data; // may be null while loading

          return StreamBuilder<Map<String, dynamic>?>(
            stream: _firebaseService.getIrrigationQueueStream(),
            builder: (context, queueSnap) {
              // ---------- UI helpers ----------
              Widget buildQueueItem(IconData icon, String text, Color color) =>
                  _buildQueueItem(icon, text, color);

              Widget buildContainer(List<Widget> children) =>
                  _buildQueueContainer(children: children);

              // ---------- Error / loading handling ----------
              if (queueSnap.connectionState == ConnectionState.waiting) {
                return buildContainer([
                  buildQueueItem(
                      Icons.pending, 'Loading Queue...', Colors.grey),
                ]);
              }
              if (queueSnap.hasError) {
                return buildContainer([
                  buildQueueItem(
                      Icons.error, 'Error: ${queueSnap.error}', Colors.red),
                ]);
              }

              // ---------- Extract & sort the queue ----------
              final Map<String, dynamic> queue = queueSnap.data ?? {};
              final farmsInQueue = queue.keys.toList()
                ..sort((a, b) => (queue[b]['score'] as num)
                    .compareTo(queue[a]['score'] as num));

              // Calculate total CWR
              double totalCWR = 0.0;
              for (var farmId in farmsInQueue) {
                if (queue[farmId] is Map) {
                  final farm = queue[farmId] as Map;
                  totalCWR += (farm['liters'] as num?)?.toDouble() ?? 0.0;
                }
              }

              // Check if total CWR is less than virtual reservoir and show warning
              if (reservoir != null && totalCWR > reservoir) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showInsufficientWaterWarning(
                      context, farmsInQueue, totalCWR, reservoir);
                });
              }

              // ---------- Build the overlay content ----------
              return buildContainer([
                // ••• virtual-reservoir line •••
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_drink, size: 14, color: Colors.teal),
                    const SizedBox(width: 6),
                    Text(
                      reservoir == null
                          ? 'Virtual Reservoir: …'
                          : 'Virtual Reservoir: ${reservoir.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 10, thickness: .5),
                // Header
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    'Irrigation Queue',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
                const Divider(height: 8, thickness: .5),
                // Queue items (or placeholder when empty)
                if (queue.isEmpty)
                  buildQueueItem(Icons.check_circle_outline, 'Farm Queue Empty',
                      Colors.green)
                else
                  ...farmsInQueue.where((id) => queue[id] is Map).map((farmId) {
                    final farm = queue[farmId] as Map;
                    final liters = farm['liters'] ?? '?';
                    return buildQueueItem(Icons.water_drop,
                        '$farmId | CWR: $liters L', Colors.blue);
                  }),
              ]);
            },
          );
        },
      ),
    );
  }

  Widget _buildQueueContainer({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildQueueItem(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  // New method to show the warning pop-up in Hiligaynon
  void _showInsufficientWaterWarning(BuildContext context,
      List<String> farmsInQueue, double totalCWR, double virtualReservoir) {
    // Construct the list of farm names for the message
    String farmNames = farmsInQueue.map((farmId) => '`$farmId`').join(', ');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: const [
              Icon(Icons.warning, color: Colors.red, size: 20),
              SizedBox(width: 5),
              Text(
                'Paandam sa Tubig!', // "Water Warning!" in Hiligaynon
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Ang mga uma nga ${farmNames} posible nga indi maka-angkon sang bastante ukon wala gid sang tubig bangud kulang ang reserbasyon.', // "These farms (`farmNames`) might not get enough or no water because the reservoir is not enough."
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 10),
                Text(
                  'Kabilugan nga kinahanglanon nga tubig (CWR): ${totalCWR.toStringAsFixed(2)} L',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Available nga reservoir: ${virtualReservoir.toStringAsFixed(2)} L',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Huo', // "Okay" in Hiligaynon
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
