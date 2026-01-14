import 'package:flutter/material.dart';

class AuctionFormConfirmation extends StatelessWidget {
  const AuctionFormConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirmation")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 16),
            const Text(
              "Auction Form Created!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Your auction fundraising form has been successfully created. You can now preview, share, or start accepting bids.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            const Divider(),

            const SizedBox(height: 24),
            const Text(
              "Next Steps:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _NextStepTile(
              icon: Icons.visibility,
              title: "Preview Form",
              onTap: () {
                // TODO: Implement preview
              },
            ),
            _NextStepTile(
              icon: Icons.share,
              title: "Share Form Link",
              onTap: () {
                // TODO: Implement share
              },
            ),
            _NextStepTile(
              icon: Icons.dashboard_customize,
              title: "Manage Auctions",
              onTap: () {
                // TODO: Navigate to dashboard or management
              },
            ),

            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text("Return to Dashboard"),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/forms'));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _NextStepTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _NextStepTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: onTap,
    );
  }
}
