import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/widgets/step_progress_indicator.dart';

import '../../../providers/peer_to_peer_form_provider.dart';

class PeerFormGeneral extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey; // 👈 Accept formKey from parent

  const PeerFormGeneral({super.key, required this.formKey});

  @override
  ConsumerState createState() => _PeerFormGeneralState();
}

class _PeerFormGeneralState extends ConsumerState<PeerFormGeneral> {
  String _language = 'En';
  bool _sendReceipt = true;

  @override
  void initState() {
    super.initState();
    _sendReceipt = ref.read(peerToPeerGenerateTaxReceiptProvider);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: widget.formKey, // 👈 Use passed formKey
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("General Campaign Info"),
            const SizedBox(height: 8),

            _labeledField(
              "Title of the form*",
              child: TextFormField(
                controller: ref.read(peerToPeerTitleControllerProvider),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter a campaign title",
                ),
                validator: (value) =>
                    value!.isEmpty ? "Title is required" : null,
              ),
            ),
            const SizedBox(height: 16),

            _labeledField(
              "Language*",
              child: DropdownButtonFormField<String>(
                value: _language,
                items: const [
                  DropdownMenuItem(value: 'En', child: Text("English")),
                  DropdownMenuItem(value: 'Ar', child: Text("Arabic")),
                  DropdownMenuItem(value: 'Sp', child: Text("Spanish")),
                ],
                onChanged: (val) {
                  setState(() => _language = val!);
                  ref.read(peerToPeerFormLanguageProvider.notifier).state =
                      val!;
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 16),

            CheckboxListTile(
              value: _sendReceipt,
              onChanged: (val) {
                setState(() => _sendReceipt = val!);
                ref
                    .read(peerToPeerGenerateTaxReceiptProvider.notifier)
                    .state = val!;
              },
              activeColor: const Color(0xFF6A4CBC),
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text(
                  "Automatically generate and send tax receipts"),
              secondary: const Tooltip(
                message: "This sends donors a receipt for tax purposes",
                child: Icon(Icons.info_outline),
              ),
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller:
                        ref.read(peerToPeerGoalAmountControllerProvider),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "100",
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text("\$", style: TextStyle(fontSize: 18)),
              ],
            ),

            const SizedBox(height: 16),
            _infoBox(
              "It is important to explain what you will do with the donation. "
              "It is proven that donations increase by 120% if the donor knows the exact purpose of their donation.",
            ),

            const SizedBox(height: 12),
            _sectionTitle("Description"),
            quill.QuillToolbar.simple(
              configurations: quill.QuillSimpleToolbarConfigurations(
                controller: ref.read(peerToPeerDescriptionQuillController),
              ),
            ),
            const SizedBox(height: 8),
            _editorBox(ref.read(peerToPeerDescriptionQuillController)),

            const SizedBox(height: 32),
            _sectionTitle("Message to your fundraisers"),
            const Text(
              "This message is included in the confirmation email sent to your fundraisers.",
              style: TextStyle(color: Color(0xFF333366)),
            ),
            const SizedBox(height: 8),
            quill.QuillToolbar.simple(
              configurations: quill.QuillSimpleToolbarConfigurations(
                controller:
                    ref.read(peerToPeerFundraiserMessageQuillController),
              ),
            ),
            const SizedBox(height: 8),
            _editorBox(ref.read(peerToPeerFundraiserMessageQuillController)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xFF333366),
        ),
      );

  Widget _labeledField(String label, {required Widget child}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333366))),
              const SizedBox(width: 4),
              const Tooltip(
                message: "Required",
                child: Icon(Icons.info_outline, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 4),
          child,
        ],
      );

  Widget _infoBox(String message) => Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFEAE6FD),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: Color(0xFF6A4CBC)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Color(0xFF6A4CBC)),
              ),
            ),
          ],
        ),
      );

  Widget _editorBox(quill.QuillController controller) => Container(
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: quill.QuillEditor.basic(
          configurations: quill.QuillEditorConfigurations(
            controller: controller,
            enableInteractiveSelection: true,
            sharedConfigurations: const quill.QuillSharedConfigurations(
              locale: Locale('en'),
            ),
          ),
        ),
      );
}
