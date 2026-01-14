import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/widgets/step_progress_indicator.dart';

import '../../../providers/peer_to_peer_form_provider.dart';

class PeerFormAdvanced extends ConsumerStatefulWidget {
  const PeerFormAdvanced({super.key});

  @override
  ConsumerState createState() => _PeerFormAdvancedState();
}

class _PeerFormAdvancedState extends ConsumerState<PeerFormAdvanced> {
  late bool? _addSalesTarget;
  late bool? _suggestCheck;
  late bool? _addDiscountCodes;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addSalesTarget=ref.read(peerToPeerAddSalesTargetProvider);
    _suggestCheck=ref.read(peerToPeerSuggestCheckPaymentProvider);
    _addDiscountCodes=ref.read(peerToPeerAddDiscountCodesProvider);
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Advanced settings",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF333366),
            ),
          ),
          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.email, color: Colors.green),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Set up event communication",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333366),
                        ),
                      ),
                      Text(
                        "Send smart invites, schedule reminder emails, automate thank-you messages, and more",
                        style: TextStyle(fontSize: 13, color: Color(0xFF333366)),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Redirecting to communication setup...")),
                    );

                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF6A4CBC),
                  ),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text("Take me there"),
                )
              ],
            ),
          ),

          const SizedBox(height: 32),
          const Text(
            "Additional form options",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF333366),
            ),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              CheckboxListTile(
                value: _addSalesTarget,
                onChanged: (val) {
                  setState(() => _addSalesTarget = val!);
                  ref.read(peerToPeerAddSalesTargetProvider.notifier).state=val!;
                },
                activeColor: const Color(0xFF6A4CBC),
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text("Add a sales target"),
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                value: _suggestCheck,
                onChanged: (val) {
                  setState(() => _suggestCheck = val!);
                  ref.read(peerToPeerSuggestCheckPaymentProvider.notifier).state=val!;
                },
                activeColor: const Color(0xFF6A4CBC),
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text("Suggest payment by check above \$1000"),
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                value: _addDiscountCodes,
                onChanged: (val) {
                  setState(() => _addDiscountCodes = val!);
                  ref.read(peerToPeerAddDiscountCodesProvider.notifier).state=val!;
                },
                activeColor: const Color(0xFF6A4CBC),
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text("Add discount codes"),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Text(
            "Email addresses to notify when a payment is made (separate emails with commas)",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Color(0xFF333366),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: ref.read(peerToPeerNotificationEmailsControllerProvider),
            decoration: InputDecoration(
              hintText: "Johndoe@gmail.com",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }
}
