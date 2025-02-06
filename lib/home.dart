import 'package:flutter/material.dart';
import 'package:travel_app/location.dart';
import 'package:travel_app/favorites.dart';
import 'package:travel_app/profile.dart';
import 'package:travel_app/booking_page.dart';
import 'package:travel_app/all_trips_page.dart';
import 'package:travel_app/booking_list_page.dart';


class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  final Set<String> _favorites = {};
  
  // List of pages to display
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pages = [
      const HomePage(),
      const LocationPage(),
      BookingListPage(
        allTrips: _HomePageState.categoryTrips,
        favorites: _favorites,
        onToggleFavorite: _toggleFavorite,
      ),
      FavoritesPage(
        allTrips: _HomePageState.categoryTrips,
        favorites: _favorites,
        onToggleFavorite: _toggleFavorite,
      ),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Location'),
          BottomNavigationBarItem(icon: Icon(Icons.book_online_outlined), label: 'Booking'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _toggleFavorite(String tripName) {
    setState(() {
      if (_favorites.contains(tripName)) {
        _favorites.remove(tripName);
      } else {
        _favorites.add(tripName);
      }
    });
  }
}

// Change HomePage to StatefulWidget
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Add state variables for filters
  String _selectedCategory = 'Lakes';
  double _minPrice = 0;
  double _maxPrice = 1000;
  String _selectedRating = '4+';
  Set<String> _selectedFacilities = {'WiFi'};

  // Add favorites set to track favorite items
  Set<String> _favorites = {};

  // Add location state
  String _currentLocation = 'SAUDI ARABIA';

  // Add lists for different categories
  static final Map<String, List<Map<String, String>>> categoryTrips = {
    'Lakes': [
      {
        'name': 'RIYADH',
        'location': 'JIDDAH',
        'rating': '4',
        'price': '\$40',
        'image': 'images/1.png',
      },
      {
        'name': 'JIDDAH',
        'location': 'KABUOT',
        'rating': '4.5',
        'price': '\$40',
        'image': 'images/4.png',
      },
    ],
    'Sea': [
      {
        'name': 'MAKKA',
        'location': 'MEDINA',
        'rating': '4.8',
        'price': '\$120',
        'image': 'images/2.png',
      },
      {
        'name': 'BALI',
        'location': 'Indonesia',
        'rating': '4.7',
        'price': '\$90',
        'image': 'images/5.png',
      },
       {
        'name': 'KAHIRA',
        'location': 'EGYPT',
        'rating': '4.7',
        'price': '\$90',
        'image': 'images/5.png',
      },
    ],
    'Mountain': [
      {
        'name': 'Mount Everest',
        'location': 'Nepal',
        'rating': '4.9',
        'price': '\$200',
        'image': 'images/3.png',
      },
      {
        'name': 'Alps',
        'location': 'Switzerland',
        'rating': '4.6',
        'price': '\$150',
        'image': 'images/1.png',
      },
      {
        'name': 'Mount Fuji',
        'location': 'Japan',
        'rating': '4.8',
        'price': '\$180',
        'image': 'images/loca.png',
      },
      {
        'name': 'Matterhorn',
        'location': 'Switzerland',
        'rating': '4.7',
        'price': '\$160',
        'image': 'images/loca.png',
      }
    ],
    'Forest': [
      {
        'name': 'Amazon Forest',
        'location': 'Brazil',
        'rating': '4.7',
        'price': '\$180',
        'image': 'images/1.png',
      },
      {
        'name': 'Black Forest',
        'location': 'Germany',
        'rating': '4.5',
        'price': '\$100',
        'image': 'images/1.png',
      },
      {
        'name': 'Daintree Forest',
        'location': 'Australia',
        'rating': '4.8',
        'price': '\$160',
        'image': 'images/4.png',
      },
      // {
      //   'name': 'Redwood Forest',
      //   'location': 'California',
      //   'rating': '4.9',
      //   'price': '\$140',
      //   'image': 'images/forest2.jpg',
      // },
      // {
      //   'name': 'Arashiyama Forest',
      //   'location': 'Japan',
      //   'rating': '4.6',
      //   'price': '\$120',
      //   'image': 'images/3.png',
      // },
      // {
      //   'name': 'Białowieża Forest',
      //   'location': 'Poland',
      //   'rating': '4.7',
      //   'price': '\$110',
      //   'image': 'images/4.png',
      // },
      // {
      //   'name': 'Tongass Forest',
      //   'location': 'Alaska',
      //   'rating': '4.8',
      //   'price': '\$170',
      //   'image': 'images/2.png',
      // },
      // {
      //   'name': 'Sherwood Forest',
      //   'location': 'England',
      //   'rating': '4.4',
      //   'price': '\$90',
      //   'image': 'images/4.png',
      // }
    ],
  };

  // Add search controller and results
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Method to filter trips based on search
  List<Map<String, String>> _getFilteredTrips() {
    if (_searchQuery.isEmpty) {
      return categoryTrips[_selectedCategory] ?? [];
    }
    
    return (categoryTrips[_selectedCategory] ?? []).where((trip) {
      final name = trip['name']?.toLowerCase() ?? '';
      final location = trip['location']?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      
      return name.contains(query) || location.contains(query);
    }).toList();
  }

  // Add method to show location picker
  void _showLocationPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dooro Goobta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('SAUDI ARABIA'),
              onTap: () {
                setState(() => _currentLocation = 'SAUDI ARABIA');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Mogadishu, Somalia'),
              onTap: () {
                setState(() => _currentLocation = 'Mogadishu, Somalia');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Hargeisa, Somalia'),
              onTap: () {
                setState(() => _currentLocation = 'Hargeisa, Somalia');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location and Profile Section
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showLocationPicker(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Location',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 20),
                            Text(
                              _currentLocation,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                // Profile Icon
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(initialIndex: 4),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: '',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _showFilterOptions(context),
                    child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF008080),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white),
                    ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Categories Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All'),
                ),
              ],
            ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                children: [
                  _buildCategoryItem(Icons.water, 'Lakes', true),
                  _buildCategoryItem(Icons.waves, 'Sea', false),
                  _buildCategoryItem(Icons.landscape, 'Mountain', false),
                  _buildCategoryItem(Icons.forest, 'Forest', false),
                ],
              ),
            ),

            // Top Trips Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Trips',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllTripsPage(
                          title: 'Top Trips',
                          trips: _getFilteredTrips(),
                        ),
                      ),
                    );
                  },
                  child: const Text(''),
                ),
              ],
            ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _getFilteredTrips().map((trip) => _buildTripCard(
                    context,
                    trip['name']!,
                    trip['location']!,
                    trip['rating']!,
                    trip['price']!,
                    trip['image']!,
                  )).toList(),
                ),
            ),

            // Group Trips Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Group Trips',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllTripsPage(
                          title: 'Group Trips',
                          trips: categoryTrips[_selectedCategory] ?? [],
                          isGroupTrips: true,
                        ),
                      ),
                    );
                  },
                  child: const Text(''),
                ),
              ],
            ),
            _buildGroupTripCard(),
          ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
      },
      child: Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: _selectedCategory == label ? const Color(0xFF008080) : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
                color: _selectedCategory == label ? Colors.white : Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
        ),
      ),
    );
  }

  void _showMenuOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFF008080)),
              title: const Text('Details'),
              onTap: () {
                Navigator.pop(context);
                // Add navigation to details page here
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Color(0xFF008080)),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                // Add share functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border, color: Color(0xFF008080)),
              title: const Text('Add to Favorites'),
              onTap: () {
                Navigator.pop(context);
                // Add to favorites functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_problem_outlined, color: Color(0xFF008080)),
              title: const Text('Report'),
              onTap: () {
                Navigator.pop(context);
                // Add report functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripCard(
    BuildContext context,
    String name,
    String location,
    String rating,
    String price,
    String imageUrl,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingPage(
              name: name,
              location: location,
              rating: rating,
              price: price,
              imagePath: imageUrl,
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _showMenuOptions(context),
              child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.more_vert, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(rating),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                Text(location, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$price/Visit',
                  style: const TextStyle(
                    color: Color(0xFF008080),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _favorites.contains(name) ? Icons.favorite : Icons.favorite_border,
                    color: _favorites.contains(name) ? Colors.red : null,
                  ),
                  onPressed: () => _toggleFavorite(name),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupTripCard() {
    final groupTrips = {
      'Lakes': [
        {
          'name': 'Lake Group Trip',
          'location': 'Minnesota',
          'rating': '4.8',
          'price': '\$80',
          'image': 'images/1.png',
          'members': '5 members',
        },
        {
          'name': 'Lake Adventure',
          'location': 'Canada',
          'rating': '4.6',
          'price': '\$95',
          'image': 'images/4.png',
          'members': '4 members',
        },
         {
          'name': 'Lake Adventure',
          'location': 'Canada',
          'rating': '4.6',
          'price': '\$95',
          'image': 'images/3.png',
          'members': '4 members',
        },
      ],
      'Sea': [
        {
          'name': 'Island Group Tour',
          'location': 'Maldives',
          'rating': '4.9',
          'price': '\$150',
          'image': 'images/2.png',
          'members': '8 members',
        },
        {
          'name': 'Beach Group Trip',
          'location': 'Bali',
          'rating': '4.7',
          'price': '\$120',
          'image': 'images/5.png',
          'members': '6 members',
        },
         {
          'name': 'Beach Group Trip',
          'location': 'Bali',
          'rating': '4.7',
          'price': '\$120',
          'image': 'images/5.png',
          'members': '6 members',
        },
      ],
      'Mountain': [
        {
          'name': 'Mountain Climbers',
          'location': 'Nepal',
          'rating': '4.9',
          'price': '\$200',
          'image': 'images/1.png',
          'members': '4 members',
        },
        {
          'name': 'Alps Group Tour',
          'location': 'Switzerland',
          'rating': '4.8',
          'price': '\$180',
          'image': 'images/2.png',
          'members': '5 members',
        },
        {
          'name': 'Himalayan Trek',
          'location': 'Tibet',
          'rating': '4.7',
          'price': '\$190',
          'image': 'images/5.png',
          'members': '6 members',
        },
      ],

      'Forest': [
        {
          'name': 'Forest Explorers',
          'location': 'Brazil',
          'rating': '4.7',
          'price': '\$160',
          'image': 'images/3.png',
          'members': '6 members',
        },
         {
          'name': 'Forest Explorers',
          'location': 'Somalia',
          'rating': '4.7',
          'price': '\$160',
          'image': 'images/3.png',
          'members': '6 members',
        },
         {
          'name': 'Forest Explorers',
          'location': 'Mo',
          'rating': '4.7',
          'price': '\$160',
          'image': 'images/3.png',
          'members': '6 members',
        },
      ],
    
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: (groupTrips[_selectedCategory] ?? []).map((trip) => Container(
          width: 200,
          margin: const EdgeInsets.only(right: 16, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
        children: [
          ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      trip['image']!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.people,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            trip['members']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      trip['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(trip['rating']!),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  Text(
                    trip['location']!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${trip['price']!}/Person',
                    style: const TextStyle(
                      color: Color(0xFF008080),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _favorites.contains(trip['name']) ? Icons.favorite : Icons.favorite_border,
                      color: _favorites.contains(trip['name']) ? Colors.red : null,
                    ),
                    onPressed: () => _toggleFavorite(trip['name']!),
                  ),
                ],
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar for dragging
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  'Filter Options',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Price Range
                const Text(
                  'Price Range',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Min',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _minPrice = double.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Max',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _maxPrice = double.tryParse(value) ?? 1000;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Rating Filter
                const Text(
                  'Rating',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildRatingChip('4+', true),
                    _buildRatingChip('3+', false),
                    _buildRatingChip('2+', false),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Facilities
                const Text(
                  'Facilities',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildFacilityChip('WiFi', true),
                    _buildFacilityChip('Parking', false),
                    _buildFacilityChip('Restaurant', false),
                    _buildFacilityChip('Swimming Pool', false),
                    _buildFacilityChip('Gym', false),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Apply Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showSelectedFilters(); // Show selected filters when Apply is clicked
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF008080),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: FilterChip(
        label: Text(label),
        selected: _selectedRating == label,
        onSelected: (bool selected) {
          setState(() {
            _selectedRating = label;
          });
        },
        selectedColor: const Color(0xFF008080),
        labelStyle: TextStyle(
          color: _selectedRating == label ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildFacilityChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: _selectedFacilities.contains(label),
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _selectedFacilities.add(label);
          } else {
            _selectedFacilities.remove(label);
          }
        });
      },
      selectedColor: const Color(0xFF008080),
      labelStyle: TextStyle(
        color: _selectedFacilities.contains(label) ? Colors.white : Colors.black,
      ),
    );
  }

  // Add method to show selected filters
  void _showSelectedFilters() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selected Filters'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price Range: \$${_minPrice.toInt()} - \$${_maxPrice.toInt()}'),
            const SizedBox(height: 10),
            Text('Rating: $_selectedRating'),
            const SizedBox(height: 10),
            Text('Facilities: ${_selectedFacilities.join(", ")}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(String tripName) {
    setState(() {
      if (_favorites.contains(tripName)) {
        _favorites.remove(tripName);
      } else {
        _favorites.add(tripName);
      }
    });
  }
}
