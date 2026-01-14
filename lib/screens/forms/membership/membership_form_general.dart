import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/widgets/step_progress_indicator.dart';

import '../../../providers/membership_form_provider.dart';

class MembershipFormGeneral extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;

  const MembershipFormGeneral({super.key, required this.formKey});

  @override
  ConsumerState createState() => _MembershipFormGeneralState();
}

class _MembershipFormGeneralState extends ConsumerState<MembershipFormGeneral> {
  String _language = 'En';

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
                _sectionTitle("General Membership Info"),
                const SizedBox(height: 16),

                _labeledField(
                  label: "Title of the form*",
                  child: TextFormField(
                    controller: ref.read(membershipTitleControllerProvider),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "2025 Membership Drive",
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
                      setState(() {
                        _language = val!;
                        ref.read(membershipFormLanguageProvider.notifier).state = val;
                      });
                    },
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  ),
                ),

                const SizedBox(height: 24),
                _sectionTitle("Description"),
                const SizedBox(height: 8),
                quill.QuillToolbar.simple(
                  configurations: quill.QuillSimpleToolbarConfigurations(
                    controller: ref.read(membershipDescriptionQuillController),
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
                      controller: ref.read(membershipDescriptionQuillController),
                      placeholder: 'Explain the benefits of joining your membership program...',
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
}
