import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../screens/sign_up_dialog.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Colors.blueGrey.shade50,
            Colors.lightBlue.shade200,
            Colors.blueGrey.shade600,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/icons/impact-logo-v5.svg", height: 45),
              //Icon(Icons.volunteer_activism, color: const Color(0xFF7B8BFF), size: 28),
              const SizedBox(width: 8),
              // const Text(
              //   "impact",
              //   style: TextStyle(
              //     fontSize: 28,
              //     color: Colors.white,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: 1.2,
              //   ),
              // ),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AuthDialog(isLogin: true),
                  );
                },
                child: const Text(
                  "Login",
                  style: TextStyle(

                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AuthDialog(isLogin: false),
                  );
                },
                child: const Text(
                  "Sign up for free",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
