import 'package:flutter/material.dart';
import 'dart:ui';
import '../services/booking_service.dart';
import '../pages/booking_details_page.dart';

class BookingPage extends StatefulWidget {
  final String imagePath;
  final String name;
  final String location;
  final String rating;
  final String description;
  final String price;

  const BookingPage({
    super.key,
    this.imagePath = 'images/4.png',
    this.name = 'RedFish Lake',
    this.location = 'Idaho',
    this.rating = '4.5',
    this.price = '\$40',
    this.description = 'Redfish Lake is the final stop on the longest Pacific salmon run in North America, which requires long-distance swimmers, such as Sockeye and Chinook Salmon, to travel over 900 miles upstream to return to their spawning grounds.\n\nRedfish Lake is an alpine lake in Custer County, Idaho, just south of Stanley. It is the largest lake within the Sawtooth National Recreation Area.',
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final BookingService _bookingService = BookingService();
  bool _isBooked = false;
  DateTime? _bookingDate;

  // Variables for editing booking
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  // New variables to store the updated values
  late String _currentName;
  late String _currentPrice;

  @override
  void initState() {
    super.initState();
    // Initialize the current values with the widget values
    _currentName = widget.name;
    _currentPrice = widget.price;
  }

  void _handleBooking(BuildContext context) async {
    try {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Xaqiijinta Booking-ka'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Goobta: ${_currentName}'),
              Text('Location: ${widget.location}'),
              Text('Qiimaha: ${_currentPrice}'),
              const SizedBox(height: 16),
              const Text('Ma hubtaa inaad booking-gan sameyneyso?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Maya'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _bookingService.createBooking(_currentName, widget.location, _currentPrice);
                
                // Update the booking status
                setState(() {
                  _isBooked = true;
                  _bookingDate = DateTime.now();
                });
                
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Waad ku guuleysatay booking-ka!'),
                    backgroundColor: Color(0xFF008080),
                  ),
                );
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailsPage(
                      name: _currentName,
                      location: widget.location,
                      price: _currentPrice,
                      imagePath: widget.imagePath,
                      bookingDate: _bookingDate!,
                    ),
                  ),
                );
              },
              child: const Text('Haa'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Khalad: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Edit the booking
  void _editBooking() {
    _nameController.text = _currentName;
    _priceController.text = _currentPrice;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Goobta',
                ),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Qiimaha',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // Update the current values
                  _currentName = _nameController.text;
                  _currentPrice = _priceController.text;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking-ka waa la cusboonaysiiyay'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Delete the booking
  void _deleteBooking() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tirtir Booking-ka'),
          content: const Text('Ma hubtaa inaad tirtirto booking-kan?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isBooked = false;
                  _bookingDate = null;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking-ka waa la tirtiray'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Tirtir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Image and Navigation
                Stack(
                  children: [
                    // Main Image
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(30),
                        ),
                        image: DecorationImage(
                          image: AssetImage(widget.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Back Button
                    Positioned(
                      top: 40,
                      left: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _currentName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              Text(
                                widget.rating,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Location
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.location,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Description Title
                      const Text(
                        'What is Redfish Lake known for?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Description Text
                      Text(
                        widget.description,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Booking Button and Favorite
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _handleBooking(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF008080),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Book Now | $_currentPrice',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Display Booking Information after success
                      if (_isBooked) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Booking Details:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Goobta: $_currentName',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Qiimaha: $_currentPrice',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Taariikhda Booking: ${_bookingDate?.toLocal()}',
                          style: TextStyle(fontSize: 16),
                        ),
                        // Edit and Delete Buttons
                        Row(
                          children: [
                            TextButton(
                              onPressed: _editBooking,
                              child: const Text('Edit'),
                            ),
                            TextButton(
                              onPressed: _deleteBooking,
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
