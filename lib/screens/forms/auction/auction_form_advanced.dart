import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/auction_form_provider.dart';

class AuctionFormAdvanced extends ConsumerStatefulWidget {
  const AuctionFormAdvanced({super.key});

  @override
  ConsumerState createState() => _AuctionFormAdvancedState();
}

class _AuctionFormAdvancedState extends ConsumerState<AuctionFormAdvanced> {
  bool enableNotifications = true;
  bool requireApproval = false;
  bool allowDiscountCodes = false;
  String emailToNotify = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Advanced Settings",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          SwitchListTile(
            title: const Text("Enable bid notifications"),
            subtitle: const Text("Notify participants when they are outbid or win an auction."),
            value: enableNotifications,
            onChanged: (val) => setState(() {
              enableNotifications = val;
              ref.read(auctionEnableNotificationsProvider.notifier).state=val;
            }),
          ),

          SwitchListTile(
            title: const Text("Require approval for auction items"),
            subtitle: const Text("Manually approve all submitted auction items before they go live."),
            value: requireApproval,
            onChanged: (val) => setState(() {
              requireApproval = val;
              ref.read(auctionRequireApprovalProvider.notifier).state=val;
            }),
          ),

          SwitchListTile(
            title: const Text("Allow discount codes"),
            subtitle: const Text("Enable discount codes for registration or items."),
            value: allowDiscountCodes,
            onChanged: (val) => setState(() {
              allowDiscountCodes = val;
              ref.read(auctionAllowDiscountCodesProvider.notifier).state=val;
            }),
          ),

          const SizedBox(height: 30),
          const Text(
            "Notification Email",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: ref.read(auctionNotificationEmailControllerProvider),
            decoration: const InputDecoration(
              hintText: 'Enter email to notify on each bid or payment',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => setState(() {
              emailToNotify = val;
              ref.read(auctionNotificationEmailProvider.notifier).state=val;
            }),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
