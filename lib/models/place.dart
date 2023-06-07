import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final int id;
  final String name;
  final String description;
  final String image;
  final LatLng location;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.location,
  });
}
