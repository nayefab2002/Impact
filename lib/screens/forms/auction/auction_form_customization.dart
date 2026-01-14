import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auction_form_provider.dart';

class AuctionFormCustomization extends ConsumerStatefulWidget {
  const AuctionFormCustomization({super.key});

  @override
  ConsumerState createState() => _AuctionFormCustomizationState();
}

class _AuctionFormCustomizationState extends ConsumerState<AuctionFormCustomization> {
  bool enableBidIncrements = true;
  double startingBid = 0;
  double bidIncrement = 5;
  Color selectedColor = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Auction Settings",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          const Text("Starting Bid"),
          const SizedBox(height: 6),
          TextFormField(
            controller: ref.read(auctionStartingBidControllerProvider),
            decoration: const InputDecoration(
              prefixText: "\$",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                startingBid = double.tryParse(value) ?? 0;
                ref.read(auctionStartingBidProvider.notifier).state=startingBid;
              });
            },
          ),

          const SizedBox(height: 20),
          SwitchListTile(
            value: enableBidIncrements,
            onChanged: (val) => setState(() {
              enableBidIncrements = val;
              ref.read(auctionEnableBidIncrementsProvider.notifier).state=val;
            }),
            title: const Text("Enable bid increments"),
          ),

          if (enableBidIncrements) ...[
            const SizedBox(height: 10),
            const Text("Bid Increment"),
            const SizedBox(height: 6),
            TextFormField(
              initialValue: bidIncrement.toString(),
              decoration: const InputDecoration(
                prefixText: "\$",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  bidIncrement = double.tryParse(value) ?? 5;
                  ref.read(auctionBidIncrementProvider.notifier).state=bidIncrement;
                });
              },
            ),
          ],

          const SizedBox(height: 32),
          const Divider(),
          const Text(
            "Auction Theme",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text("Select a primary color for the form"),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _pickColor(context),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: selectedColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Tap to change',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.color_lens, color: Colors.grey),
            ],
          ),

          const SizedBox(height: 32),

        ],
      ),
    );
  }

  void _pickColor(BuildContext context) async {
    final picked = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select a Color"),
        content: SingleChildScrollView(
          child: Wrap(
            spacing: 10,
            children: Colors.primaries
                .map((color) => GestureDetector(
              onTap: () => Navigator.of(context).pop(color),
              child: CircleAvatar(backgroundColor: color),
            ))
                .toList(),
          ),
        ),
      ),
    );
    if (picked != null) {
      setState(() {
        selectedColor = picked;
      });
      ref.read(auctionThemeColorProvider.notifier).state=selectedColor.toHexString();
    }
  }
}
