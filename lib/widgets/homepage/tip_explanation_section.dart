import 'package:flutter/material.dart';


class TipExplanationSection extends StatelessWidget {
  const TipExplanationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFE4F8F5),
      ),
      margin: EdgeInsets.only(top: 15,bottom: 25),
      child: Column(
        children: [
          const Text(
            "Impact makes money exclusively from optional tips from your donors",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "No hidden fees, no subscriptions, no surprises",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.teal.shade700,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            runSpacing: 16,
            spacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _faqTile(
                context,
                "Will I ever have to pay to use Impact?",
                "No, Impact is completely free for nonprofits. We make money through optional donor tips.",
              ),
              _faqTile(
                context,
                "How does Impact make money?",
                "We rely on optional tips that donors can leave during the checkout process.",
              ),
              _faqTile(
                context,
                "What if my donors don't leave a tip?",
                "That's perfectly fine! Tips are completely optional and you still get to use our platform for free.",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _faqTile(BuildContext context, String title, String content) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFFE4F8F5),
            title: Text(title, style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
            content: Text(content, style: TextStyle(color: Colors.teal.shade700)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.teal,
                ),
                child: const Text("Got it"),
              ),
            ],
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width > 600 ? 300 : double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.help_outline, color: Colors.teal.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.teal.shade800,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.teal, size: 16),
          ],
        ),
      ),
    );
  }
}
