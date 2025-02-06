import 'package:flutter/material.dart';
import '../services/booking_service.dart';
import '../models/booking.dart';

class MyBookingsPage extends StatelessWidget {
  final BookingService _bookingService = BookingService();

  MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookingyadeyda'),
        backgroundColor: const Color(0xFF008080),
      ),
      body: StreamBuilder<List<Booking>>(
        stream: _bookingService.getBookings(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Khalad: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF008080),
              ),
            );
          }

          final bookings = snapshot.data!;
          
          if (bookings.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book_online,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Weli booking malihid',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              booking.tripName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF008080),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              booking.price,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            booking.location,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(booking.bookingDate),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => _showDeleteDialog(context, booking.id),
                            child: const Text(
                              'Tirtir',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _showUpdateDialog(context, booking),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF008080),
                            ),
                            child: const Text('Wax ka bedel'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showUpdateDialog(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dooro Taariikhda Cusub'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Fadlan dooro taariikhda cusub ee bookingga'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final newDate = await showDatePicker(
                  context: context,
                  initialDate: booking.bookingDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (newDate != null) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  await _bookingService.updateBooking(booking.id, newDate);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Waa la bedelay taariikhda'),
                      backgroundColor: Color(0xFF008080),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008080),
              ),
              child: const Text('Dooro Taariikhda'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Jooji'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tir Bookingga'),
        content: const Text('Ma hubtaa inaad tirtireyso bookinggan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maya'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _bookingService.deleteBooking(bookingId);
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Waa la tiray bookingga'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Haa, Tir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
} 