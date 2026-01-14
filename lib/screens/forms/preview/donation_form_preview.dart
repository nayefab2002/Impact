import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/donation_form.dart';

class DonationFormPreviewScreen extends ConsumerWidget {
  final DonationForm donationData;

  const DonationFormPreviewScreen({super.key, required this.donationData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color themeColor = hexToColor(donationData.themeColor);
    final donationAmount = ref.watch(donationAmountProvider);

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
                    child:SingleChildScrollView(
                      child:  DonationDetailsSection(
                        donationData: donationData,
                        themeColor: themeColor,
                      ),
                    )
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: DonationAmountSection(
                      donationData: donationData,
                      themeColor: themeColor,
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
                    DonationDetailsSection(
                      donationData: donationData,
                      themeColor: themeColor,
                    ),
                    const SizedBox(height: 24),
                    DonationAmountSection(
                      donationData: donationData,
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

/// Widget for displaying donation form details
class DonationDetailsSection extends StatelessWidget {
  final DonationForm donationData;
  final Color themeColor;

  const DonationDetailsSection({
    super.key,
    required this.donationData,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Banner Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child:Image.asset('assets/images/banner_placeholder.jpg',height: 400,width: double.infinity,)
        ),
        const SizedBox(height: 24),
        
        // Title
        Text(
          donationData.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF21005D)),
        ),
        const SizedBox(height: 16),
        
        // Thermometer (if enabled)
        if (donationData.toAddThermometer) ...[
          _buildThermometer(themeColor),
          const SizedBox(height: 16),
        ],
        
        // Description
        QuillEditor(focusNode: FocusNode(),
            scrollController: ScrollController(),controller: QuillController(document: Document.fromJson(donationData.description),
              selection: TextSelection(baseOffset: 0, extentOffset: 0)),
          configurations: QuillEditorConfigurations(checkBoxReadOnly: true),),
        
        // Tax Receipt Info
        if (donationData.isGenerateTaxReceipt) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.receipt, color: themeColor),
              const SizedBox(width: 8),
              Text(
                'Tax receipt will be issued for this donation',
                style: TextStyle(color: themeColor),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildThermometer(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Campaign Progress',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: 0.65, // Example progress - replace with actual data
          minHeight: 12,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$1,250 raised',
              style: TextStyle(
                fontSize: 14,
                color: color,
              ),
            ),
            Text(
              'of \$2,000 goal',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Widget for donation amount selection
class DonationAmountSection extends ConsumerWidget {
  final DonationForm donationData;
  final Color themeColor;

  const DonationAmountSection({
    super.key,
    required this.donationData,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final donationAmount = ref.watch(donationAmountProvider);
    final suggestedAmounts = _getSuggestedAmounts(donationData);

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
                const Text(
                  'Donation Amount',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Suggested amounts
                if (suggestedAmounts.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: suggestedAmounts.map((amount) {
                      return ChoiceChip(
                        label: Text('\$$amount'),
                        selected: donationAmount.amount == amount,
                        onSelected: (selected) {
                          ref.read(donationAmountProvider.notifier).setAmount(amount);
                        },
                        selectedColor: themeColor,
                        labelStyle: TextStyle(
                          color: donationAmount.amount == amount 
                            ? Colors.white 
                            : themeColor,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Custom amount
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Or enter custom amount',
                    prefixText: '\$',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      final amount = double.tryParse(value) ?? 0;
                      ref.read(donationAmountProvider.notifier).setAmount(amount);
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Donor info
                if (donationData.donorQuestions['Email'] == true) ...[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                
                if (donationData.donorQuestions['First name'] == true) ...[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                
                if (donationData.donorQuestions['Last name'] == true) ...[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Donate button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Handle donation submission
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Donate Now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<double> _getSuggestedAmounts(DonationForm donationData) {
    final amounts = <double>[];
    if (donationData.suggestedDonationAmount['lessThan100'] == true) {
      amounts.addAll([25, 50, 75]);
    }
    if (donationData.suggestedDonationAmount['between100_300'] == true) {
      amounts.addAll([100, 150, 250]);
    }
    if (donationData.suggestedDonationAmount['moreThan300'] == true) {
      amounts.addAll([500, 1000]);
    }
    return amounts;
  }
}

// Riverpod provider for donation amount
class DonationAmountState {
  final double amount;

  DonationAmountState({required this.amount});
}

class DonationAmountNotifier extends StateNotifier<DonationAmountState> {
  DonationAmountNotifier() : super(DonationAmountState(amount: 25.0));

  void setAmount(double newAmount) {
    state = DonationAmountState(amount: newAmount);
  }
}

final donationAmountProvider = StateNotifierProvider<DonationAmountNotifier, DonationAmountState>((ref) {
  return DonationAmountNotifier();
});