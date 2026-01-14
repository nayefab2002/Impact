import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/membership_form.dart';

class MembershipFormPreviewScreen extends ConsumerWidget {
  final MembershipForm membershipData;

  const MembershipFormPreviewScreen({super.key, required this.membershipData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLevel = ref.watch(selectedMembershipLevelProvider);
    final showDonationField = ref.watch(showDonationFieldProvider);
    final donationAmount = ref.watch(donationAmountProvider);
    final requireAddress = membershipData.requireAddress;

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
                    child: SingleChildScrollView(
                      child: MembershipDetailsSection(membershipData: membershipData),
                    )
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: MembershipSignupSection(
                      membershipData: membershipData,
                      selectedLevel: selectedLevel,
                      showDonationField: showDonationField,
                      donationAmount: donationAmount,
                      requireAddress: requireAddress,
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
                    MembershipDetailsSection(membershipData: membershipData),
                    const SizedBox(height: 24),
                    MembershipSignupSection(
                      membershipData: membershipData,
                      selectedLevel: selectedLevel,
                      showDonationField: showDonationField,
                      donationAmount: donationAmount,
                      requireAddress: requireAddress,
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

/// Displays membership program details
class MembershipDetailsSection extends StatelessWidget {
  final MembershipForm membershipData;

  const MembershipDetailsSection({super.key, required this.membershipData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and description
        Text(
          membershipData.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Description
        if (membershipData.description.isNotEmpty)
          QuillEditor(focusNode: FocusNode(),
            scrollController: ScrollController(),controller: QuillController(document: Document.fromJson(membershipData.description),
                selection: TextSelection(baseOffset: 0, extentOffset: 0)),
            configurations: QuillEditorConfigurations(checkBoxReadOnly: true),),
        
        const SizedBox(height: 24),
        const Text(
          'Membership Levels',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Membership levels list
        ...membershipData.membershipLevels.map((level) => 
          _buildMembershipLevelCard(level)
        ).toList(),
        
        // Progress indicator if enabled
        if (membershipData.showProgress) ...[
          const SizedBox(height: 24),
          const LinearProgressIndicator(
            value: 0.65, // Example value
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          const SizedBox(height: 8),
          const Text(
            '65% of our goal reached!',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ],
    );
  }

  Widget _buildMembershipLevelCard(Map<String, dynamic> level) {
    final price = double.tryParse(level['price']?.toString() ?? '0') ?? 0;
    final validity = level['validity']?.toString() ?? 'none';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              level['name']?.toString() ?? 'Membership',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  _getValidityText(validity),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            if (level['description']?.toString().isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              Text(
                level['description']!.toString(),
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getValidityText(String validity) {
    switch (validity) {
      case 'monthly': return '/ month';
      case 'yearly': return '/ year';
      default: return 'one-time';
    }
  }
}

/// Handles membership signup process
class MembershipSignupSection extends ConsumerWidget {
  final MembershipForm membershipData;
  final Map<String, dynamic>? selectedLevel;
  final bool showDonationField;
  final double donationAmount;
  final bool requireAddress;

  const MembershipSignupSection({
    super.key,
    required this.membershipData,
    required this.selectedLevel,
    required this.showDonationField,
    required this.donationAmount,
    required this.requireAddress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final price = selectedLevel != null 
        ? double.tryParse(selectedLevel!['price']?.toString() ?? '0') ?? 0 
        : 0;
    final total = price + donationAmount;

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
            const Text(
              'Join Now',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Membership level selection
            const Text('Select Membership Level:'),
            const SizedBox(height: 8),
            DropdownButtonFormField<Map<String, dynamic>>(
              value: selectedLevel,
              items: membershipData.membershipLevels.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level['name']?.toString() ?? 'Membership'),
                );
              }).toList(),
              onChanged: (level) => 
                  ref.read(selectedMembershipLevelProvider.notifier).state = level,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            
            // Donation field if enabled
            if (membershipData.allowDonation) ...[
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Add a donation'),
                value: showDonationField,
                onChanged: (value) => 
                    ref.read(showDonationFieldProvider.notifier).state = value ?? false,
              ),
              if (showDonationField) ...[
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: donationAmount.toStringAsFixed(2),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Donation Amount',
                    prefixText: '\$',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    final amount = double.tryParse(value) ?? 0;
                    ref.read(donationAmountProvider.notifier).state = amount;
                  },
                ),
              ],
            ],
            
            // Address fields if required
            if (requireAddress) ...[
              const SizedBox(height: 16),
               TextFormField(
                decoration: InputDecoration(
                  labelText: 'Street Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'ZIP Code',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            
            // Total and submit button
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _submitMembership(context, total),
                child: const Text(
                  'Complete Membership',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'By joining, you agree to our terms and conditions',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _submitMembership(BuildContext context, double total) {
    if (selectedLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a membership level')),
      );
      return;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Membership submitted! Total: \$${total.toStringAsFixed(2)}')),
    );
    // In real app: Process payment and create membership
  }
}

// Providers for membership selection state
final selectedMembershipLevelProvider = StateProvider<Map<String, dynamic>?>((ref) => null);
final showDonationFieldProvider = StateProvider<bool>((ref) => false);
final donationAmountProvider = StateProvider<double>((ref) => 0.0);