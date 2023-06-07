import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/constants.dart';
import '../models/place.dart';
import '../screens/place_detail_screen.dart';
import 'package:transparent_image/transparent_image.dart';

bool isFavoriteExisting = false;

class PlaceCard extends StatefulWidget {
  final Place place;

  const PlaceCard({super.key, required this.place});

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  void _addFavorite() async {
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection('favorite').add({
      'placeId': widget.place.id,
      'placeName': widget.place.name,
      'placeDescription': widget.place.description,
      'placeLocationLat': widget.place.location.latitude.toString(),
      'placeLocationLng': widget.place.location.longitude.toString(),
      'placeImage': widget.place.image,
      'userId': user.uid,
    });
    setState(() {
      isFavoriteExisting = true;
    });
    await _checkFavoriteExistence();
  }

  void _deleteFavorite() async {
    final user = FirebaseAuth.instance.currentUser!;
    final favoritesQuerySnapshot = await FirebaseFirestore.instance
        .collection('favorite')
        .where('userId', isEqualTo: user.uid)
        .where('placeName', isEqualTo: widget.place.name)
        .get();

    for (var document in favoritesQuerySnapshot.docs) {
      await document.reference.delete();
    }
    setState(() {
      isFavoriteExisting = false;
    });
    await _checkFavoriteExistence();
  }

  Future<void> _checkFavoriteExistence() async {
    final user = FirebaseAuth.instance.currentUser!;
    final favoritesQuerySnapshot = await FirebaseFirestore.instance
        .collection('favorite')
        .where('userId', isEqualTo: user.uid)
        .where('placeName', isEqualTo: widget.place.name)
        .limit(1)
        .get();

    isFavoriteExisting = favoritesQuerySnapshot.docs.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _checkFavoriteExistence();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailScreen(place: widget.place),
          ),
        );
      },
      child: Card(
        color: kCardColour,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(widget.place.image)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  widget.place.name,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
