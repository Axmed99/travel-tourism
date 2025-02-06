import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';

class FavoritesPage extends StatelessWidget {
  final Map<String, List<Map<String, String>>> allTrips;
  final Set<String> favorites;
  final Function(String) onToggleFavorite;

  const FavoritesPage({
    super.key,
    required this.allTrips,
    required this.favorites,
    required this.onToggleFavorite,
  });

  List<Map<String, String>> getFavoriteTrips() {
    List<Map<String, String>> favoriteTrips = [];
    for (var category in allTrips.values) {
      for (var trip in category) {
        if (favorites.contains(trip['name'])) {
          favoriteTrips.add(trip);
        }
      }
    }
    return favoriteTrips;
  }

  @override
  Widget build(BuildContext context) {
    final favoriteTrips = getFavoriteTrips();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/location.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Favorites'),
            backgroundColor: const Color(0xFF008080),
            foregroundColor: Colors.white,
          ),
          body: favoriteTrips.isEmpty
              ? const Center(
                  child: Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favoriteTrips.length,
                  itemBuilder: (context, index) {
                    final trip = favoriteTrips[index];
                    return _buildTripCard(
                      trip['name']!,
                      trip['location']!,
                      trip['rating']!,
                      trip['price']!,
                      trip['image']!,
                      context,
                      onToggleFavorite,
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildTripCard(
    String name,
    String location,
    String rating,
    String price,
    String imagePath,
    BuildContext context,
    Function(String) onToggleFavorite,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        Text(
                          rating,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        color: Color(0xFF008080),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        favorites.contains(name) ? Icons.favorite : Icons.favorite_border,
                        color: favorites.contains(name) ? Colors.red : null,
                      ),
                      onPressed: () => onToggleFavorite(name),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
