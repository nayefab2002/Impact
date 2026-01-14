import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/online_shop_form_provider.dart';

class ShopFormAdvanced extends ConsumerStatefulWidget {
  const ShopFormAdvanced({super.key});

  @override
  ConsumerState createState() => _ShopFormAdvancedState();
}

class _ShopFormAdvancedState extends ConsumerState<ShopFormAdvanced> {
  bool memoryOption = false;
  bool suggestCheckOption = false;

  Widget _buildCommunicationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDDDBFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB7B3F3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.email, size: 32, color: Color(0xFF6A4CBC)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Set up campaign communications",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333366),
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Send fundraising appeals, automate thank-you messages, and more.",
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9E91E9),
            ),
            child: const Text("Take me there"),
          )
        ],
      ),
    );
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
              fontSize: 16,
              color: Color(0xFF333366),
            ),
          ),
          const SizedBox(height: 16),
          _buildCommunicationCard(),

          const SizedBox(height: 32),
          const Text(
            "Additional form options",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF333366),
            ),
          ),
          CheckboxListTile(
            value: memoryOption,
            onChanged: (val) => setState(() {
              memoryOption = val!;
              ref.read(shopMemoryOptionEnabledProvider.notifier).state=val;
            }),
            title: const Text("Activate 'in honor or in memory of' donation option"),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            value: suggestCheckOption,
            onChanged: (val) => setState(() {
              suggestCheckOption = val!;
              ref.read(shopSuggestCheckOptionProvider.notifier).state=val;
            }),
            title: const Row(
              children: [
                Text("Suggest payment by check above \$1000"),
                SizedBox(width: 6),
                Tooltip(
                  message: "Donors will see an option to pay by check for large donations.",
                  child: Icon(Icons.info_outline, size: 16),
                ),
              ],
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 12),
          const Text(
            "Email addresses to notify when a donation is made (separate emails with commas)",
            style: TextStyle(fontSize: 13, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: ref.read(shopEmailToNotifyControllerProvider),
            decoration: InputDecoration(
              hintText: "Enter emails...",
              filled: true,
              fillColor: const Color(0xFFEAE6FD),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            "Form translation",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF333366),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // translation logic placeholder
            },
            child: const Text("Translate the form"),
          ),

        ],
      ),
    );
  }

}
