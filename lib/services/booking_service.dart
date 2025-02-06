import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/booking.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create booking
  Future<void> createBooking(String tripName, String location, String price) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final booking = Booking(
      id: '',
      tripName: tripName,
      location: location,
      price: price,
      userId: userId,
      bookingDate: DateTime.now(),
    );

    await _firestore.collection('bookings').add(booking.toMap());
  }

  // Read bookings
  Stream<List<Booking>> getBookings() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Booking.fromMap(doc.id, doc.data()))
            .toList());
  }

  // Update booking
  Future<void> updateBooking(String bookingId, DateTime newDate) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'bookingDate': newDate.toIso8601String(),
    });
  }

  // Delete booking
  Future<void> deleteBooking(String bookingId) async {
    await _firestore.collection('bookings').doc(bookingId).delete();
  }
} 