import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../components/constants.dart';
import '../widgets/place_card.dart';
import '../models/place.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<List<DocumentSnapshot>> _fetchUserFavorites() async {
      final user = FirebaseAuth.instance.currentUser!;
      final favoritesQuerySnapshot = await FirebaseFirestore.instance
          .collection('favorite')
          .where('userId', isEqualTo: user.uid)
          .get();

      return favoritesQuerySnapshot.docs;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColour,
        centerTitle: true,
        title: Text(
          'Favorites',
          style: GoogleFonts.langar(
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: kCardColour,
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: _fetchUserFavorites(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final favorites = snapshot.data!;
              List<PlaceCard> placeWidgets = [];

              for (var element in favorites) {
                var data = element.data() as Map<String, dynamic>?;
                if (data != null) {
                  Place place = Place(
                    id: data['placeId'].toInt(),
                    description: data['placeDescription'].toString(),
                    image: data['placeImage'].toString(),
                    name: data['placeName'].toString(),
                    location: LatLng(
                      double.parse(data['placeLocationLat'].toString()),
                      double.parse(data['placeLocationLng'].toString()),
                    ),
                  );

                  placeWidgets.add(
                    PlaceCard(place: place),
                  );
                }
              }

              return placeWidgets.isEmpty
                  ? const Center(
                      child: Text('No favorites added'),
                    )
                  : Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: SizedBox.shrink(),
                        ),
                        Expanded(
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: GridView.count(
                              primary: false,
                              crossAxisCount: 2,
                              children: placeWidgets,
                            ),
                          ),
                        ),
                      ],
                    );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
