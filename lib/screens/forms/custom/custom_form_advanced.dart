import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/custom_form_provider.dart';

class CustomFormAdvanced extends ConsumerStatefulWidget {
  const CustomFormAdvanced({super.key});

  @override
  ConsumerState createState() => _CustomFormAdvancedState();
}

class _CustomFormAdvancedState extends ConsumerState<CustomFormAdvanced> {
  bool enableRecurringDonation=true;
  bool allowCommentsFromDonor=true;
  String language="English";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 32),

          const Text(
            'Advanced Settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          CheckboxListTile(
            title: const Text('Enable recurring donations'),
            value: enableRecurringDonation,
            onChanged: (val) {
              setState(() {
                enableRecurringDonation=val!;
                ref.read(customFormEnableRecurringDonationsProvider.notifier).state=val;

              });
            },
          ),

          CheckboxListTile(
            title: const Text('Allow donors to leave a comment'),
            value: allowCommentsFromDonor,
            onChanged: (val) {
              setState(() {
                allowCommentsFromDonor=val!;
                ref.read(customFormAllowDonorCommentsProvider.notifier).state=val;
              });
            },
          ),
          const Divider(height: 40),
          const Text(
            'Email Receipt Customization',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: ref.read(customFormEmailReceiptMessageControllerProvider),
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Customize the message included in the email receipt...',
              border: OutlineInputBorder(),
            ),
          ),

          const Divider(height: 40),

          const Text(
            'Form Language',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: language,
            items: const [
              DropdownMenuItem(value: 'English', child: Text('English')),
              DropdownMenuItem(value: 'French', child: Text('French')),
            ],
            onChanged: (value) {
              setState(() {
                language=value!;
                ref.read(customFormLanguageProvider.notifier).state=value;
              });
            },
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
