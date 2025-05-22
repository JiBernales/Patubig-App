import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/farm_viewmodel.dart';

class MapCard extends StatefulWidget {
  const MapCard({super.key});

  @override
  _MapCardState createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FarmWeatherViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)
              ],
            ),
            child: viewModel.currentLocation == null
                ? const Center(child: CircularProgressIndicator())
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        IgnorePointer(
                          child: FlutterMap(
                            mapController: viewModel.mapController,
                            options: MapOptions(
                              initialCenter: viewModel.currentLocation!.latLng,
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
                                    point: viewModel.currentLocation!.latLng,
                                    child: const Icon(
                                      Icons.location_pin,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const Marker(
                                    point: LatLng(10.865162, 122.738167),
                                    child: Icon(Icons.sensors, color: Colors.red),
                                  ),
                                  const Marker(
                                    point: LatLng(10.857623, 122.731182),
                                    child: Icon(Icons.sensors, color: Colors.red),
                                  ),
                                  const Marker(
                                    point: LatLng(10.855813, 122.741552),
                                    child: Icon(Icons.sensors, color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
          ),
        );
      },
    );
  }
}