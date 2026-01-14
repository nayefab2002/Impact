import 'package:flutter/material.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2471BD), // blue background
      body: Stack(
        children: [
          // White blobs
          ..._buildBlobs(),
          // Centered login card
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Log in to Impact",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF2471BD),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "The 100% free fundraising platform for nonprofits",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.grey),
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                    icon: Image.network(
                      'https://img.icons8.com/color/48/000000/google-logo.png',
                      height: 20,
                    ),
                    label: const Text("Log in with Google"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBlobs() {
    final List<Offset> positions = [
      const Offset(30, 50),
      const Offset(100, 10),
      const Offset(250, 40),
      const Offset(40, 200),
      const Offset(200, 300),
      const Offset(50, 400),
    ];
    return positions
        .map((pos) => Positioned(
      top: pos.dy,
      left: pos.dx,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
      ),
    ))
        .toList();
  }
}