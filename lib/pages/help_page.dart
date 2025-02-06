import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caawimaad'),
        backgroundColor: const Color(0xFF008080),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFAQItem(
            'Sidee booking loo sameeyaa?',
            'Riix goobta aad rabto, kadib riix "Book Now" si aad u sameyso booking.',
          ),
          _buildFAQItem(
            'Sidee baan u bedeli karaa booking-ga?',
            'Tag bookingyadaada, kadib riix "Wax ka bedel" si aad u beddesho taariikhda.',
          ),
          _buildFAQItem(
            'Sidee baan ula xidhiidhi karaa support-ka?',
            'Email: support@example.com\nTel: +252 61 1234567',
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(answer),
          ),
        ],
      ),
    );
  }
} 