import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/custom_form.dart';


class CustomFormPreviewScreen extends ConsumerWidget {
  final CustomForm formData;

  const CustomFormPreviewScreen({super.key, required this.formData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColor = hexToColor(formData.themeColor);
    final donationAmount = ref.watch(customFormDonationAmountProvider);
    final isRecurring = ref.watch(customFormIsRecurringProvider);
    final donorComment = ref.watch(customFormDonorCommentProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
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
                    child: CustomFormDetailsSection(
                      formData: formData,
                      themeColor: themeColor,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: DonationSection(
                      formData: formData,
                      themeColor: themeColor,
                      donationAmount: donationAmount,
                      isRecurring: isRecurring,
                      donorComment: donorComment,
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
                  children: [
                    CustomFormDetailsSection(
                      formData: formData,
                      themeColor: themeColor,
                    ),
                    const SizedBox(height: 24),
                    DonationSection(
                      formData: formData,
                      themeColor: themeColor,
                      donationAmount: donationAmount,
                      isRecurring: isRecurring,
                      donorComment: donorComment,
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

/// Displays form details (logo, title, description)
class CustomFormDetailsSection extends StatelessWidget {
  final CustomForm formData;
  final Color themeColor;

  const CustomFormDetailsSection({
    super.key,
    required this.formData,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo and header
        if (formData.formLogoUrl.isNotEmpty) ...[
          Center(
            child: Image.asset('assets/images/logo_placeholder.jpg',height: 300,width: 300,)
          ),
          const SizedBox(height: 24),
        ],
        
        // Welcome message
        if (formData.welcomeMessage.isNotEmpty) ...[
          Text(
            formData.welcomeMessage,
            style: TextStyle(
              fontSize: 20,
              color: themeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        // Title
        Text(
          formData.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Description
        Text(
          formData.description,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
            height: 1.5,
          ),
        ),
        
        // Progress bar if enabled
        if (formData.showProgressBar) ...[
          const SizedBox(height: 24),
          const LinearProgressIndicator(
            value: 0.75, // Example progress
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          const SizedBox(height: 8),
          const Text(
            '75% of our goal reached!',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ],
    );
  }
}

/// Handles donation input and submission
class DonationSection extends ConsumerWidget {
  final CustomForm formData;
  final Color themeColor;
  final double donationAmount;
  final bool isRecurring;
  final String donorComment;

  const DonationSection({
    super.key,
    required this.formData,
    required this.themeColor,
    required this.donationAmount,
    required this.isRecurring,
    required this.donorComment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Donation amount
            const Text(
              'Donation Amount',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: donationAmount.toStringAsFixed(2),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                final amount = double.tryParse(value) ?? 0;
                ref.read(customFormDonationAmountProvider.notifier).state = amount;
              },
            ),
            
            // Recurring donation option
            if (formData.enableRecurringDonations) ...[
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Make this a recurring monthly donation'),
                value: isRecurring,
                onChanged: (value) => ref.read(customFormIsRecurringProvider.notifier).state = value ?? false,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
            
            // Donor comment if enabled
            if (formData.allowDonorComments) ...[
              const SizedBox(height: 16),
              const Text(
                'Leave a comment (optional)',
                style: TextStyle(fontSize: 14),
              ),
              TextFormField(
                maxLines: 3,
                onChanged: (value) => ref.read(customFormDonorCommentProvider.notifier).state = value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            
            // Fee coverage option
            if (formData.askToCoverFees) ...[
              const SizedBox(height: 16),
              const Text(
                'Payment Processing Fees',
                style: TextStyle(fontSize: 14),
              ),
              const Text(
                '\$2.50 (3.5%)',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              CheckboxListTile(
                title: const Text('Cover processing fees so we receive 100%'),
                value: true, // Default checked
                onChanged: (value) {},
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
            
            // Submit button
            const SizedBox(height: 24),
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
                onPressed: () => _submitDonation(context, donationAmount),
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
            
            // Security info
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.lock, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Secure payment processing',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitDonation(BuildContext context, double amount) {
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a donation amount')),
      );
      return;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thank you for your donation of \$${amount.toStringAsFixed(2)}!'),
      ),
    );
    // In real app: Process payment
  }
}

// Providers for donation state
final customFormDonationAmountProvider = StateProvider<double>((ref) => 25.0);
final customFormIsRecurringProvider = StateProvider<bool>((ref) => false);
final customFormDonorCommentProvider = StateProvider<String>((ref) => '');