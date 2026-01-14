import 'package:flutter/material.dart';

class MidSection extends StatelessWidget {
  const MidSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue.shade50,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          const Text(
            "Zero credit card fees.",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            constraints: BoxConstraints(maxWidth: 700),
            decoration: BoxDecoration(
              color: Colors.lightBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _featureItem(context, Icons.credit_card_off, "No processing fees"),
                _featureItem(context, Icons.security, "Secure transactions"),
                _featureItem(context, Icons.bolt, "Fast withdrawals"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureItem(BuildContext context, IconData icon, String text) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle( fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}