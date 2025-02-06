import 'package:flutter/material.dart';
import 'dart:ui';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Explore',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: Color(0xFF008080),
                              ),
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: Colors.grey,
                              ),
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: Colors.grey,
                              ),
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: Colors.grey,
                              ),
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: const Icon(Icons.notifications_none, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      // City Image Card
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: double.infinity,
                          height: 240,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: AssetImage('images/location.png'),
                              fit: BoxFit.cover,
                            ),

                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                Text(
                                  'Toronto, Canada',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '12.5 km',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Map Section
                      Positioned(
                        top: 280,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                          ),
                          child: Stack(
                            children: [
                              // Map markers
                              Positioned(
                                top: 40,
                                left: 30,
                                child: _buildMapMarker('Toronto', true),
                              ),
                              Positioned(
                                top: 100,
                                right: 40,
                                child: _buildMapMarker('Russia', false),
                              ),
                              Positioned(
                                bottom: 120,
                                left: 60,
                                child: _buildMapMarker('New York', false),
                              ),
                              // Flight path
                              CustomPaint(
                                size: const Size(double.infinity, double.infinity),
                                painter: FlightPathPainter(),
                              ),
                              // Start Button
                              Positioned(
                                bottom: 100,
                                left: 20,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.send),
                                  label: const Text('Start'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF008080),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildMapMarker(String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(height: 4),
        Icon(
          Icons.location_on,
          color: isSelected ? const Color(0xFF008080) : Colors.grey,
          size: 24,
        ),
      ],
    );
  }
}

class FlightPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF008080)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.5,
        size.width * 0.8,
        size.height * 0.4,
      );

    // Draw dashed line
    final dashPath = Path();
    const dashWidth = 8.0;
    const dashSpace = 4.0;
    var distance = 0.0;
    
    for (final PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);

    // Draw airplane icon
    final planePaint = Paint()
      ..color = const Color(0xFF008080)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(size.width * 0.8, size.height * 0.4);
    canvas.rotate(-0.4);
    
    final planeIcon = Path()
      ..moveTo(0, 0)
      ..lineTo(-10, 5)
      ..lineTo(-10, -5)
      ..close();

    canvas.drawPath(planeIcon, planePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 