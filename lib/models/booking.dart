class Booking {
  final String id;
  final String tripName;
  final String location;
  final String price;
  final String userId;
  final DateTime bookingDate;

  Booking({
    required this.id,
    required this.tripName,
    required this.location,
    required this.price,
    required this.userId,
    required this.bookingDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'tripName': tripName,
      'location': location,
      'price': price,
      'userId': userId,
      'bookingDate': bookingDate.toIso8601String(),
    };
  }

  factory Booking.fromMap(String id, Map<String, dynamic> map) {
    return Booking(
      id: id,
      tripName: map['tripName'] ?? '',
      location: map['location'] ?? '',
      price: map['price'] ?? '',
      userId: map['userId'] ?? '',
      bookingDate: DateTime.parse(map['bookingDate']),
    );
  }
} 