import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/screens/forms/models/peer_to_peer_form.dart';


class PeerToPeerFormPreviewScreen extends StatelessWidget {
  final PeerToPeerForm peerFormData;

  const PeerToPeerFormPreviewScreen({super.key, required this.peerFormData});

  @override
  Widget build(BuildContext context) {
    final themeColor = hexToColor(peerFormData.themeColor);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _HeaderSection(
              peerFormData: peerFormData, 
              themeColor: themeColor,
            ),
            const SizedBox(height: 24),
            QuillEditor(focusNode: FocusNode(),
              scrollController: ScrollController(),controller: QuillController(document: Document.fromJson(peerFormData.description),
                  selection: TextSelection(baseOffset: 0, extentOffset: 0)),
              configurations: QuillEditorConfigurations(checkBoxReadOnly: true),),
            const SizedBox(height: 24),
            Text("Message From Fundraiser",style: Theme.of(context).textTheme.headlineMedium,),
            QuillEditor(focusNode: FocusNode(),
              scrollController: ScrollController(),controller: QuillController(document: Document.fromJson(peerFormData.fundraiserMessage),
                  selection: TextSelection(baseOffset: 0, extentOffset: 0)),
              configurations: QuillEditorConfigurations(checkBoxReadOnly: true),),
            const SizedBox(height: 24),
            _DonationSection(
              peerFormData: peerFormData,
              themeColor: themeColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final PeerToPeerForm peerFormData;
  final Color themeColor;

  const _HeaderSection({
    required this.peerFormData,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:Image.asset("assets/images/banner_placeholder.jpg",height: 250,width: double.infinity,)
        ),
        const SizedBox(height: 16),
        Text(
          peerFormData.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.flag, color: themeColor),
            const SizedBox(width: 8),
            Text(
              'Goal: \$${peerFormData.goalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                color: themeColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final String text;
  final Color themeColor;

  const _DescriptionSection({
    required this.text,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About this campaign',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _FundraiserSection extends StatelessWidget {
  final String text;
  final Color themeColor;

  const _FundraiserSection({
    required this.text,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Message to fundraisers',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _DonationSection extends ConsumerWidget {
  final PeerToPeerForm peerFormData;
  final Color themeColor;

  const _DonationSection({
    required this.peerFormData,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frequencyProvider = StateProvider<String>((_) => 'One-Time');
    final amountProvider = StateProvider<double?>((_) => null);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _FrequencySelector(
              peerFormData: peerFormData,
              themeColor: themeColor,
              frequencyProvider: frequencyProvider,
              amountProvider: amountProvider,
            ),
            const SizedBox(height: 16),
            _AmountSelector(
              peerFormData: peerFormData,
              themeColor: themeColor,
              frequencyProvider: frequencyProvider,
              amountProvider: amountProvider,
            ),
            const SizedBox(height: 16),
            if (peerFormData.generateTaxReceipt)
              _TaxReceiptNotice(themeColor: themeColor),
            const SizedBox(height: 24),
            _DonateButton(
              themeColor: themeColor,
              amountProvider: amountProvider,
            ),
          ],
        ),
      ),
    );
  }
}

class _FrequencySelector extends ConsumerWidget {
  final PeerToPeerForm peerFormData;
  final Color themeColor;
  final StateProvider<String> frequencyProvider;
  final StateProvider<double?> amountProvider;

  const _FrequencySelector({
    required this.peerFormData,
    required this.themeColor,
    required this.frequencyProvider,
    required this.amountProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frequency = ref.watch(frequencyProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Donation Frequency',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: peerFormData.suggestedAmounts.keys.map((type) {
            return ChoiceChip(
              label: Text(type),
              selected: frequency == type,
              onSelected: (selected) {
                if (selected) {
                  ref.read(frequencyProvider.notifier).state = type;
                  ref.read(amountProvider.notifier).state = null;
                }
              },
              selectedColor: themeColor.withOpacity(0.2),
              labelStyle: TextStyle(
                color: frequency == type ? themeColor : Colors.grey.shade700,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _AmountSelector extends ConsumerWidget {
  final PeerToPeerForm peerFormData;
  final Color themeColor;
  final StateProvider<String> frequencyProvider;
  final StateProvider<double?> amountProvider;

  const _AmountSelector({
    required this.peerFormData,
    required this.themeColor,
    required this.frequencyProvider,
    required this.amountProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frequency = ref.watch(frequencyProvider);
    final amounts = peerFormData.suggestedAmounts[frequency] ?? [];
    final selectedAmount = ref.watch(amountProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Amount',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (amounts.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: amounts.map((amount) {
              return ChoiceChip(
                label: Text('\$${amount.toStringAsFixed(2)}'),
                selected: selectedAmount == amount,
                onSelected: (_) => ref.read(amountProvider.notifier).state = amount,
                selectedColor: themeColor.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: selectedAmount == amount ? themeColor : Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            prefixText: '\$',
            hintText: 'Enter custom amount',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final amount = double.tryParse(value);
            ref.read(amountProvider.notifier).state = amount;
          },
        ),
      ],
    );
  }
}

class _TaxReceiptNotice extends StatelessWidget {
  final Color themeColor;

  const _TaxReceiptNotice({required this.themeColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.receipt, size: 20, color: themeColor),
        const SizedBox(width: 8),
        const Flexible(
          child: Text(
            'Tax receipt will be provided for your donation',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class _DonateButton extends ConsumerWidget {
  final Color themeColor;
  final StateProvider<double?> amountProvider;

  const _DonateButton({
    required this.themeColor,
    required this.amountProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = ref.watch(amountProvider);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: amount != null ? () {
          // Handle donation submission
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Donating \$${amount!.toStringAsFixed(2)}')),
          );
        } : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          amount != null 
              ? 'Donate \$${amount.toStringAsFixed(2)}'
              : 'Select amount to donate',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}