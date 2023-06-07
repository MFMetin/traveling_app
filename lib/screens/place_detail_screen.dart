import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travelling/screens/city_screen.dart';
import '../components/constants.dart';
import '../models/place.dart';
import '../screens/map_screen.dart';

class PlaceDetailScreen extends StatefulWidget {
  final Place place;
  const PlaceDetailScreen({super.key, required this.place});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  bool isFavoriteExisting = false;
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
    _checkFavoriteExistence().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCardColour,
      appBar: AppBar(
        actions: [
          isFavoriteExisting
              ? IconButton(
                  onPressed: () {
                    _deleteFavorite();
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Place removed from favorites'),
                      ),
                    );
                    _checkFavoriteExistence();
                  },
                  icon: const Icon(Icons.favorite, size: 28),
                )
              : IconButton(
                  onPressed: () {
                    _addFavorite();
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Place added to favorites'),
                      ),
                    );
                    _checkFavoriteExistence();
                  },
                  icon: const Icon(Icons.favorite_border, size: 32),
                ),
          IconButton(
            icon: const Icon(Icons.location_on),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OrderTrackingPage(location: widget.place.location),
                ),
              );
            },
          ),
        ],
        title: Text(widget.place.name),
        backgroundColor: kCardColour,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.place.image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Image.network(
                widget.place.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.43,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.place.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kButtonColour,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
          const SizedBox(
            height: 1,
          )
        ],
      ),
    );
  }
}
