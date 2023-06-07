import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/constants.dart';
import '../widgets/place_card.dart';
import '../assets/city_list/places.dart';
import '../models/place.dart';

class PlaceScreen extends StatelessWidget {
  final int id;
  final String name;

  const PlaceScreen({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context) {
    List<Place> places = Places.placeMap[id]!;
    List<PlaceCard> placeWidgets = [];

    for (var element in places) {
      placeWidgets.add(
        PlaceCard(
          place: Place(
              id: element.id,
              description: element.description,
              image: element.image,
              name: element.name,
              location: element.location),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColour,
        centerTitle: true,
        title: Text(
          name,
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
        child: Column(
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
        ),
      ),
    );
  }
}
