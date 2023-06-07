import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travelling/screens/favorites_screen.dart';

import '../components/constants.dart';
import 'city_screen.dart'; // Import CityScreen
import 'package:geolocator/geolocator.dart';

class OrderTrackingPage extends StatefulWidget {
  final LatLng location;
  const OrderTrackingPage({super.key, required this.location});
  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  List<LatLng> polylineCoordinates = [];
  LatLng sourceLocation = const LatLng(0, 0);
  late LatLng destination;

  bool _isLoading = true;

  void getPolyPoints() async {
    final currentLocation = await Geolocator.getCurrentPosition();
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    polylineCoordinates.clear(); // Clear previous points

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CityScreen()),
      );
    } else if (_selectedIndex == 1) {
      //
    } else if (_selectedIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FavoritesScreen()),
      );
    }
  }

  StreamSubscription<Position>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    destination = widget.location;
    _locationSubscription = Geolocator.getPositionStream().listen(
      (position) {
        setState(() {
          sourceLocation = LatLng(position.latitude, position.longitude);
          getPolyPoints();
        });
      },
    );
    Timer(const Duration(seconds: 4), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "MAP",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: sourceLocation, zoom: 14),
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: polylineCoordinates,
                  color: Colors.blue,
                  width: 6,
                ),
              },
              markers: {
                Marker(
                  markerId: const MarkerId("source"),
                  position: sourceLocation,
                ),
                Marker(
                  markerId: const MarkerId("destination"),
                  position: destination,
                ),
              },
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.image_rounded, color: Colors.grey),
              label: 'Cities',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.map_rounded,
                color: Colors.white,
              ),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, color: Colors.grey),
              label: 'Favorites',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onTabSelected,
          backgroundColor: kBottomNavBarColour,
        ),
      ),
    );
  }
}
