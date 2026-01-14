import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/donation_form_provider.dart';
import '../../../widgets/step_progress_indicator.dart';

class DonationFormGeneral extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;

  const DonationFormGeneral({super.key, required this.formKey});

  @override
  ConsumerState createState() => _DonationFormGeneralState();
}

class _DonationFormGeneralState extends ConsumerState<DonationFormGeneral> {
  String language = 'En';
  bool _sendReceipt = true;
  bool _showThermometer = false;

  final quill.QuillController _quillController = quill.QuillController.basic();

  @override
  void initState() {
    super.initState();
    language = ref.read(donationFormLanguageProvider);
  }

  void _showPreviewDialog() {
    final title = ref.read(donationTitleControllerProvider).text;
    final selectedLanguage = ref.read(donationFormLanguageProvider);
    final description = ref.read(donationDescriptionQuillController).document.toPlainText();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Preview"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Title: $title", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Language: $selectedLanguage"),
              const SizedBox(height: 8),
              const Text("Description:"),
              const SizedBox(height: 4),
              Text(description),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    language = ref.watch(donationFormLanguageProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "General campaign info",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF333366),
                  ),
                ),
                const SizedBox(height: 16),

                _labeledField(
                  label: "Title of the form*",
                  tooltip: "The title will be visible to donors",
                  child: TextFormField(
                    controller: ref.read(donationTitleControllerProvider),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                ),

                const SizedBox(height: 16),
                _labeledField(
                  label: "Language*",
                  child: DropdownButtonFormField<String>(
                    value: language,
                    items: const [
                      DropdownMenuItem(value: 'En', child: Text("En")),
                      DropdownMenuItem(value: 'Ar', child: Text("Ar")),
                      DropdownMenuItem(value: 'Sp', child: Text("Sp")),
                    ],
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    onChanged: (val) {
                      ref.read(donationFormLanguageProvider.notifier).state = val!;
                    },
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _sendReceipt,
                      onChanged: (val) {
                        setState(() => _sendReceipt = val!);
                        ref.read(toGenerateTaxReceiptProvider.notifier).state = val!;
                      },
                    ),
                    const Text("Automatically generate and send tax receipts"),
                    const SizedBox(width: 8),
                    const Tooltip(
                      message: "This sends donors a receipt for tax purposes",
                      child: Icon(Icons.info_outline, size: 18),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.visibility),
                      label: const Text("Preview"),
                      onPressed: _showPreviewDialog,
                    ),
                  ],
                ),

                Row(
                  children: [
                    Checkbox(
                      value: _showThermometer,
                      onChanged: (val) {
                        setState(() => _showThermometer = val!);
                        ref.read(toAddThermometerProvider.notifier).state = val!;
                      },
                    ),
                    const Text("Add a campaign target thermometer"),
                    const SizedBox(width: 8),
                    const Tooltip(
                      message: "Displays a progress bar to show donation goals",
                      child: Icon(Icons.info_outline, size: 18),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAE6FD),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, color: Color(0xFF6A4CBC)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "It is important to explain what you will do with the donation. "
                          "It is proven that donations increase by 120% if the donor knows the exact purpose of their donation.",
                          style: TextStyle(color: Color(0xFF6A4CBC)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333366))),
                const SizedBox(height: 8),

                quill.QuillToolbar.simple(
                  controller: ref.read(donationDescriptionQuillController),
                ),

                const SizedBox(height: 8),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: quill.QuillEditor.basic(
                    controller: ref.read(donationDescriptionQuillController),
                    configurations: quill.QuillEditorConfigurations(
                      enableInteractiveSelection: true,
                      sharedConfigurations: const quill.QuillSharedConfigurations(
                        locale: Locale('en'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _labeledField({required String label, String? tooltip, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333366))),
            if (tooltip != null) ...[
              const SizedBox(width: 4),
              Tooltip(
                message: tooltip,
                child: const Icon(Icons.info_outline, size: 16),
              ),
            ]
          ],
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}
