import 'package:flutter/foundation.dart';

class FavoritesManager extends ChangeNotifier {
  final Set<String> _favorites = {};

  Set<String> get favorites => _favorites;

  bool isFavorite(String tripName) => _favorites.contains(tripName);

  void toggleFavorite(String tripName) {
    if (_favorites.contains(tripName)) {
      _favorites.remove(tripName);
    } else {
      _favorites.add(tripName);
    }
    notifyListeners();
  }
} 