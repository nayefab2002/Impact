import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/widgets/step_progress_indicator.dart';
import 'package:intl/intl.dart';

import '../../../providers/raffle_form_provider.dart';

class RaffleFormGeneral extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  const RaffleFormGeneral({super.key, required this.formKey});

  @override
  ConsumerState createState() => _RaffleFormGeneralState();
}

class _RaffleFormGeneralState extends ConsumerState<RaffleFormGeneral> {
  String _language = 'En';
  final List<DateTime> _raffleDates = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle("General Raffle Info"),
                const SizedBox(height: 16),

                _labeledField(
                  label: "Title of the form*",
                  child: TextFormField(
                    controller: ref.read(raffleTitleControllerProvider),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Summer Raffle 2025",
                    ),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                ),

                const SizedBox(height: 16),
                _labeledField(
                  label: "Language*",
                  child: DropdownButtonFormField<String>(
                    value: _language,
                    items: const [
                      DropdownMenuItem(value: 'En', child: Text("English")),
                      DropdownMenuItem(value: 'Sp', child: Text("Spanish")),
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setState(() => _language = val!);
                      ref.read(raffleFormLanguageProvider.notifier).state = val!;
                    },
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  ),
                ),

                const SizedBox(height: 24),
                _sectionTitle("Description"),
                const SizedBox(height: 8),
                quill.QuillToolbar.simple(
                  configurations: quill.QuillSimpleToolbarConfigurations(
                    controller: ref.read(raffleDescriptionQuillController),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: quill.QuillEditor.basic(
                    configurations: quill.QuillEditorConfigurations(
                      controller: ref.read(raffleDescriptionQuillController),
                      placeholder: 'Describe your raffle and prizes...',
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                _sectionTitle("Raffle Dates"),
                const Text("Set date(s) for your raffle drawing"),
                const SizedBox(height: 8),
                ..._raffleDates.map((date) => _buildDateItem(date)).toList(),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Add raffle date"),
                  onPressed: _addRaffleDate,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Color(0xFF333366),
        ),
      );

  Widget _labeledField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        child,
      ],
    );
  }

  Widget _buildDateItem(DateTime date) {
    return ListTile(
      title: Text(DateFormat('MMMM d, y').format(date)),
      trailing: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => _removeRaffleDate(date),
      ),
    );
  }

  void _addRaffleDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (date != null) {
      setState(() => _raffleDates.add(date));
      ref.read(raffleDatesProvider.notifier).state = _raffleDates;
    }
  }

  void _removeRaffleDate(DateTime date) {
    setState(() => _raffleDates.remove(date));
    ref.read(raffleDatesProvider.notifier).state = _raffleDates;
  }
}
