import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/constants.dart';
import '../widgets/city_card.dart';
import '../assets/city_list/cities.dart';
import '../models/city.dart';
import 'favorites_screen.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  List<City> cities = Cities.cities;
  List<CityCard> cityWidgets = [];
  int _selectedIndex = 0;
  String _searchQuery = '';

  static const List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.image_rounded),
      label: 'Cities',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Favorites',
    ),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      // Do nothing, stay on the current screen
    } else if (_selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FavoritesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CityCard> cityWidgets = [];
    for (var element in cities) {
      if (_searchQuery.isEmpty ||
          element.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
        cityWidgets.add(
          CityCard(
            city:
                City(id: element.id, name: element.name, image: element.image),
          ),
        );
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kCardColour,
          title: const Center(
            child: Text('Cities'),
          ),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
        backgroundColor: kCardColour,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: GridView.count(
                  primary: false,
                  crossAxisCount: 2,
                  children: cityWidgets,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _bottomNavBarItems,
          currentIndex: _selectedIndex,
          onTap: _onTabSelected,
          backgroundColor: kBottomNavBarColour,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Set the initially selected tab as "Cities" (index 0)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedIndex = 0;
      });
    });
  }
}
