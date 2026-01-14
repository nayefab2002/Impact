import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/custom_form_provider.dart';

class CustomFormGeneral extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  const CustomFormGeneral({super.key, required this.formKey});

  @override
  ConsumerState createState() => _CustomFormGeneralState();
}

class _CustomFormGeneralState extends ConsumerState<CustomFormGeneral> {
  String _selectedLanguage = 'En';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text("General info", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            const LabelText("Title of form*"),
            TextFormField(
              controller: ref.read(customFormTitleControllerProvider),
              decoration: const InputDecoration(border: OutlineInputBorder()),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 20),

            const LabelText("Language*"),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: "En", child: Text("English")),
                DropdownMenuItem(value: "Fr", child: Text("French")),
              ],
              onChanged: (val) {
                setState(() {
                  _selectedLanguage = val!;
                  ref.read(customFormLanguageProvider.notifier).state = val;
                });
              },
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 20),

            const LabelText("Description"),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.grey[200],
                    child: Row(
                      children: const [
                        Icon(Icons.format_bold),
                        SizedBox(width: 8),
                        Icon(Icons.format_italic),
                        SizedBox(width: 8),
                        Icon(Icons.format_underlined),
                        SizedBox(width: 8),
                        Icon(Icons.format_align_left),
                        SizedBox(width: 8),
                        Icon(Icons.image),
                        SizedBox(width: 8),
                        Icon(Icons.link),
                        SizedBox(width: 8),
                        Icon(Icons.add),
                        Spacer(),
                        Text("Pre-fill text", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  TextField(
                    controller: ref.read(customFormDescriptionControllerProvider),
                    maxLines: 6,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      border: InputBorder.none,
                      hintText: "Add a description here to explain your custom fundraising initiative.",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LabelText extends StatelessWidget {
  final String text;
  const LabelText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}
