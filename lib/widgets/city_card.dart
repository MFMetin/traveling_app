import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import '../components/constants.dart';
import '../models/city.dart';
import '../screens/place_screen.dart';

class CityCard extends StatelessWidget {
  final City city;

  const CityCard({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceScreen(
              id: city.id,
              name: city.name,
            ),
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
                      image: NetworkImage(city.image)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  city.name,
                  style: GoogleFonts.langar(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
