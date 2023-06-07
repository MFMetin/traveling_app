import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelling/models/place.dart';

class FavoritePlacesNotifier extends StateNotifier<List<Place>> {
  FavoritePlacesNotifier() : super([]);

  void togglePlaceFavoriteStatus(Place place) {
    final placeIsFavorite = state.contains(place);

    if (placeIsFavorite) {
      state = state.where((p) => p.name != place.name).toList();
    } else {
      state = [...state, place];
    }
  }
}

final favoritePlacesProvider = StateNotifierProvider((ref) {
  return FavoritePlacesNotifier();
});
