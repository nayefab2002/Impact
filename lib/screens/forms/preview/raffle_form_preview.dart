import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/raffle_form.dart';



class RaffleFormPreviewScreen extends ConsumerWidget {
  final RaffleForm raffleData;

  const RaffleFormPreviewScreen({super.key, required this.raffleData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColor = hexToColor(raffleData.themeColor);
    final dateFormat = DateFormat('MMM d, y');
    final timeFormat = DateFormat('h:mm a');

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
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            // Desktop layout
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(child: RaffleDetailsSection(
                      raffleData: raffleData,
                      themeColor: themeColor,
                      dateFormat: dateFormat,
                      timeFormat: timeFormat,
                    ),)
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: TicketPurchaseSection(
                      raffleData: raffleData,
                      themeColor: themeColor,
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Mobile layout
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RaffleDetailsSection(
                      raffleData: raffleData,
                      themeColor: themeColor,
                      dateFormat: dateFormat,
                      timeFormat: timeFormat,
                    ),
                    const SizedBox(height: 24),
                    TicketPurchaseSection(
                      raffleData: raffleData,
                      themeColor: themeColor,
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
}

/// Displays raffle details (image, title, dates, description)
class RaffleDetailsSection extends StatelessWidget {
  final RaffleForm raffleData;
  final Color themeColor;
  final DateFormat dateFormat;
  final DateFormat timeFormat;

  const RaffleDetailsSection({
    super.key,
    required this.raffleData,
    required this.themeColor,
    required this.dateFormat,
    required this.timeFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Banner Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[200],
            child:Image.asset('assets/images/banner_placeholder.jpg',height: 200,width: double.infinity,)
          ),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          raffleData.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Logo and Organization Info
        if (raffleData.logoUrl.isNotEmpty) ...[
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(raffleData.logoUrl),
          ),
          const SizedBox(height: 8),
        ],

        // Drawing Dates
        _buildDateSection(),
        const SizedBox(height: 16),

        // Description
        QuillEditor(focusNode: FocusNode(),
          scrollController: ScrollController(),controller: QuillController(document: Document.fromJson(raffleData.description),
              selection: TextSelection(baseOffset: 0, extentOffset: 0)),
          configurations: QuillEditorConfigurations(checkBoxReadOnly: true),),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Drawing Dates:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        if (raffleData.raffleDates.isEmpty)
          const Text('No dates specified', style: TextStyle(color: Colors.grey)),
        ...raffleData.raffleDates.map((date) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: themeColor),
              const SizedBox(width: 8),
              Text(dateFormat.format(date)),
              const SizedBox(width: 16),
              Icon(Icons.access_time, size: 16, color: themeColor),
              const SizedBox(width: 8),
              Text(timeFormat.format(date)),
            ],
          ),
        )),
      ],
    );
  }
}

/// Handles ticket purchase
class TicketPurchaseSection extends ConsumerWidget {
  final RaffleForm raffleData;
  final Color themeColor;

  const TicketPurchaseSection({
    super.key,
    required this.raffleData,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticket = raffleData.ticketOptions;
    final ticketPrice = (ticket['price'] as num?)?.toDouble() ?? 0.0;
    final quantity = ref.watch(raffleTicketQuantityProvider);
    final total = quantity * ticketPrice;

    return Column(
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ticket Info
                Text(
                  ticket['title'] ?? 'Raffle Ticket',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (ticket['description']?.isNotEmpty ?? false)
                  Text(
                    ticket['description']!,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                const SizedBox(height: 16),

                // Price
                Text(
                  '\$${ticketPrice.toStringAsFixed(2)} each',
                  style: TextStyle(
                    fontSize: 24,
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Quantity Selector
                Row(
                  children: [
                    const Text('Quantity:', style: TextStyle(fontSize: 16)),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.remove, color: themeColor),
                      onPressed: quantity > 1 
                          ? () => ref.read(raffleTicketQuantityProvider.notifier).state--
                          : null,
                    ),
                    Text(
                      quantity.toString(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: themeColor),
                      onPressed: () => ref.read(raffleTicketQuantityProvider.notifier).state++,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Total
                Row(
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 16)),
                    const Spacer(),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Purchase Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _handlePurchase(context),
                    child: const Text(
                      'Purchase Tickets',
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

        // Terms
        Text(
          'By purchasing tickets, you agree to our terms and conditions. Winners will be notified after the drawing.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _handlePurchase(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ticket purchase completed!')),
    );
    // In real app: Process payment and record purchase
  }
}

// Provider for ticket quantity
final raffleTicketQuantityProvider = StateProvider<int>((ref) => 1);