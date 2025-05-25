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
                  margin: const EdgeInsets.all(16),
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
                                          'https://tile-{s}.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          point:
                                              viewModel.currentLocation!.latLng,
                                          child: _buildAnimatedMarker(
                                            Icons.location_pin,
                                            Colors.red,
                                            size: 32,
                                            isPrimary: true,
                                          ),
                                        ),
                                        Marker(
                                          point: const LatLng(
                                              10.865162, 122.738167),
                                          child: _buildAnimatedMarker(
                                            Icons.sensors,
                                            Colors.green,
                                          ),
                                        ),
                                        Marker(
                                          point: const LatLng(
                                              10.857623, 122.731182),
                                          child: _buildAnimatedMarker(
                                            Icons.sensors,
                                            Colors.blue,
                                          ),
                                        ),
                                        Marker(
                                          point: const LatLng(
                                              10.855813, 122.741552),
                                          child: _buildAnimatedMarker(
                                            Icons.sensors,
                                            Colors.orange,
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
  Widget _buildIrrigationQueueOverlay() {
    return Positioned(
      top: 16,
      right: 16,
      child: StreamBuilder<Map<String, dynamic>?>(
        stream: _firebaseService.getIrrigationQueueStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildQueueContainer(
              children: [
                _buildQueueItem(Icons.pending, 'Loading Queue...', Colors.grey),
              ],
            );
          }
          if (snapshot.hasError) {
            return _buildQueueContainer(
              children: [
                _buildQueueItem(Icons.error_outline, 'Error: ${snapshot.error}',
                    Colors.red),
              ],
            );
          }
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return _buildQueueContainer(
              children: [
                _buildQueueItem(Icons.check_circle_outline, 'Farm Queue Empty',
                    Colors.green),
              ],
            );
          }

          final queue = snapshot.data!;
          final farmsInQueue = queue.keys.toList()
            ..sort((a, b) =>
                (queue[b]['score'] as num).compareTo(queue[a]['score'] as num));

          return _buildQueueContainer(
            children: [
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
              const Divider(height: 8, thickness: 0.5),
              ...farmsInQueue
                  .where((id) => queue[id] is Map) // keep only real farm nodes
                  .map((farmId) {
                final farm = queue[farmId] as Map; // now it’s safe
                final liters = farm['liters'] ?? '?';
                return _buildQueueItem(
                  Icons.water_drop,
                  '$farmId : $liters L',
                  Colors.blue.shade600,
                );
              }),
            ],
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
}
