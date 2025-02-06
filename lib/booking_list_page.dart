import 'package:flutter/material.dart';
import 'booking_page.dart';

class BookingListPage extends StatelessWidget {
  final Map<String, List<Map<String, String>>> allTrips;
  final Set<String> favorites;
  final Function(String) onToggleFavorite;

  const BookingListPage({
    super.key,
    required this.allTrips,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Available Bookings'),
          backgroundColor: const Color(0xFF008080),
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Regular Trips'),
              Tab(text: 'Group Trips'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            _buildTripsList(context, false),
            _buildTripsList(context, true),
          ],
        ),
      ),
    );
  }

  Widget _buildTripsList(BuildContext context, bool isGroupTrips) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allTrips.length,
      itemBuilder: (context, index) {
        final category = allTrips.keys.elementAt(index);
        final trips = allTrips[category]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...trips.map((trip) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    trip['image']!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(trip['name']!),
                subtitle: Text(trip['location']!),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      trip['price']!,
                      style: const TextStyle(
                        color: Color(0xFF008080),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        favorites.contains(trip['name'])
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: favorites.contains(trip['name']) ? Colors.red : null,
                      ),
                      onPressed: () => onToggleFavorite(trip['name']!),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingPage(
                        name: trip['name']!,
                        location: trip['location']!,
                        rating: trip['rating']!,
                        price: trip['price']!,
                        imagePath: trip['image']!,
                      ),
                    ),
                  );
                },
              ),
            )).toList(),
          ],
        );
      },
    );
  }
} 