import 'package:flutter/material.dart';

import '../../screens/sign_up_dialog.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      decoration: BoxDecoration(
         color: Colors.lightBlue.withOpacity(.2)
      ),
      child: Column(
        children: [
          const Text(
            "Fundraise with ",
            style: TextStyle(
              fontSize: 40,
              color: Colors.black,
              fontWeight: FontWeight.w300,
              height: 1.2,
            ),
          ),
          const Text(
            "zero fees.",
            style: TextStyle(
              fontSize: 44,
              color: Colors.lightBlue,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              "Impact is the only 100% free fundraising platform for nonprofits.\nUsed and loved by thousands.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield, color: Colors.teal.withOpacity(0.7), size: 16),
              const SizedBox(width: 8),
              Text(
                "100% Secure",
                style: TextStyle(color: Colors.black.withOpacity(.6), fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 10,),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) =>AuthDialog(isLogin: false,)
              );
            },
            icon: const Icon(Icons.rocket_launch,color: Colors.black87,),
            label: const Text(
              "Sign up - it's free forever!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),

        ],
      ),
    );
  }
}
