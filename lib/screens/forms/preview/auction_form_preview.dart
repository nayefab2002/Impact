import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/auction_form.dart';


class AuctionFormPreviewScreen extends ConsumerWidget {
  final AuctionForm auctionData;

  const AuctionFormPreviewScreen({super.key, required this.auctionData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color themeColor = hexToColor(auctionData.themeColor);
    final currentBidState = ref.watch(auctionBidProvider);
    final currentBid = currentBidState.currentBid; // Extract the double value
    final timeLeft = _calculateTimeLeft(auctionData.endDateTime);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.grey[700]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 800) {
            // Wide screen layout
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(child: AuctionDetailsSection(
                      auctionData: auctionData,
                      themeColor: themeColor,
                      timeLeft: timeLeft,
                    ),)
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: AuctionBidSection(
                      auctionData: auctionData,
                      themeColor: themeColor,
                      currentBid: currentBid,
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Narrow screen layout
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuctionDetailsSection(
                      auctionData: auctionData,
                      themeColor: themeColor,
                      timeLeft: timeLeft,
                    ),
                    const SizedBox(height: 24),
                    AuctionBidSection(
                      auctionData: auctionData,
                      themeColor: themeColor,
                      currentBid: currentBid,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  String _calculateTimeLeft(DateTime endDateTime) {
    final now = DateTime.now();
    if (now.isAfter(endDateTime)) {
      return "Auction ended";
    }

    final difference = endDateTime.difference(now);
    if (difference.inDays > 0) {
      return "${difference.inDays} days ${difference.inHours % 24} hours left";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hours ${difference.inMinutes % 60} minutes left";
    } else {
      return "${difference.inMinutes} minutes left";
    }
  }
}

/// Widget for displaying auction details
class AuctionDetailsSection extends StatelessWidget {
  final AuctionForm auctionData;
  final Color themeColor;
  final String timeLeft;

  const AuctionDetailsSection({
    super.key,
    required this.auctionData,
    required this.themeColor,
    required this.timeLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Auction Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            height: 300,
            width: double.infinity,
            color: Colors.grey[200],
            child: Center(
              child: Icon(Icons.gavel, size: 100, color: themeColor),
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Title
        Text(
          auctionData.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF21005D)),
        ),
        const SizedBox(height: 16),
        
        // Time Left
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: themeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.access_time, color: themeColor),
              const SizedBox(width: 8),
              Text(
                timeLeft,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: themeColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Auction Dates
        Row(
          children: [
            _buildDateInfo(
              icon: Icons.calendar_today,
              label: "Starts",
              date: DateFormat('MMM dd, yyyy').format(auctionData.startDateTime),
              time: DateFormat('h:mm a').format(auctionData.startDateTime),
              color: themeColor,
            ),
            const SizedBox(width: 16),
            _buildDateInfo(
              icon: Icons.calendar_today,
              label: "Ends",
              date: DateFormat('MMM dd, yyyy').format(auctionData.endDateTime),
              time: DateFormat('h:mm a').format(auctionData.endDateTime),
              color: themeColor,
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Description
        Text(
          auctionData.description,
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Colors.grey[800],
          ),
        ),
        
        // Bid Increment Info
        if (auctionData.enableBidIncrements) ...[
          const SizedBox(height: 16),
          Text(
            'Bid Increment: \$${auctionData.bidIncrement.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDateInfo({
    required IconData icon,
    required String label,
    required String date,
    required String time,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(date, style: const TextStyle(fontSize: 14)),
            Text(time, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

/// Widget for bid placement
class AuctionBidSection extends ConsumerWidget {
  final AuctionForm auctionData;
  final Color themeColor;
  final double currentBid;

  const AuctionBidSection({
    super.key,
    required this.auctionData,
    required this.themeColor,
    required this.currentBid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bidController = TextEditingController();
    final minBid = currentBid + (auctionData.enableBidIncrements ? auctionData.bidIncrement : 1);

    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey[300]!),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Bid
                const Text(
                  'Current Bid',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '\$${currentBid.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Starting Bid
                const Text(
                  'Starting Bid',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '\$${auctionData.startingBid.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Bid Input
                TextFormField(
                  controller: bidController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Your Bid (Minimum \$${minBid.toStringAsFixed(2)})',
                    prefixText: '\$',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter your bid';
                    final bid = double.tryParse(value) ?? 0;
                    if (bid < minBid) return 'Bid must be at least \$${minBid.toStringAsFixed(2)}';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Bid Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      final bid = double.tryParse(bidController.text) ?? 0;
                      if (bid >= minBid) {
                        ref.read(auctionBidProvider.notifier).placeBid(bid);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Bid of \$$bid placed successfully!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Place Bid',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Terms and Conditions
        Text(
          'By placing a bid, you agree to our terms and conditions. Winning bidders will be notified after the auction closes.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Riverpod provider for auction bids
class AuctionBidState {
  final double currentBid;

  AuctionBidState({required this.currentBid});
}

class AuctionBidNotifier extends StateNotifier<AuctionBidState> {
  AuctionBidNotifier(double startingBid) : super(AuctionBidState(currentBid: startingBid));

  void placeBid(double bid) {
    state = AuctionBidState(currentBid: bid);
  }
}

final auctionBidProvider = StateNotifierProvider<AuctionBidNotifier, AuctionBidState>((ref) {
  // In a real app, you would get the actual current bid from your database
  return AuctionBidNotifier(0.0); // Initialize with starting bid
});