import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/event_form_provider.dart';

class EventFormGeneral extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  const EventFormGeneral({super.key, required this.formKey});

  @override
  ConsumerState<EventFormGeneral> createState() => _EventFormGeneralState();
}

class _EventFormGeneralState extends ConsumerState<EventFormGeneral> {
  final _dateCtrl = TextEditingController();

  @override
  void dispose() {
    _dateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header('General Information'),

            _Field(
              label: 'Event Title*',
              child: TextFormField(
                controller: ref.read(titleControllerProvider),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ),

            _Field(
              label: 'Date & Time*',
              child: TextFormField(
                controller: _dateCtrl,
                readOnly: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (_) {
                  final date = ref.read(eventFormDateTimeProvider);
                  return (date == null || date.trim().isEmpty)
                      ? 'Required'
                      : null;
                },
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    _dateCtrl.text =
                        '${picked.day}/${picked.month}/${picked.year}';
                    ref.read(eventFormDateTimeProvider.notifier).state =
                        picked.toIso8601String();
                  }
                },
              ),
            ),

            _Field(
              label: 'Address*',
              child: TextFormField(
                controller: ref.read(addressControllerProvider),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ),

            const SizedBox(height: 16),
            const Text('Description',
                style: TextStyle(fontWeight: FontWeight.bold)),
            quill.QuillToolbar.simple(
              controller: ref.read(descriptionQuillController),
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              child: quill.QuillEditor.basic(
                controller: ref.read(descriptionQuillController),
                configurations: const quill.QuillEditorConfigurations(),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/* ── Tiny helpers for section layout ───────────────────────── */
class _Header extends StatelessWidget {
  final String text;
  const _Header(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF333366),
          ),
        ),
      );
}

class _Field extends StatelessWidget {
  final String label;
  final Widget child;
  const _Field({required this.label, required this.child});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF333366),
              ),
            ),
            const SizedBox(height: 6),
            child,
          ],
        ),
      );
}
