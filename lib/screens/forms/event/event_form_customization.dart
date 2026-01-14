import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/event_form_provider.dart';

class EventFormCustomization extends ConsumerStatefulWidget {
  const EventFormCustomization({super.key});

  @override
  ConsumerState<EventFormCustomization> createState() =>
      _EventFormCustomizationState();
}

class _EventFormCustomizationState
    extends ConsumerState<EventFormCustomization> {
  late Color _color;
  final _formKey = GlobalKey<FormState>();

  final _tickets = <Map<String, dynamic>>[
    {"type": "General", "price": 0.0, "description": ""}
  ];

  @override
  void initState() {
    super.initState();
    _color = Color(
      int.tryParse(ref.read(eventThemeColorProvider) ?? '0xFF3366FF') ??
          0xFF3366FF,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header('Customization'),

            // Theme color picker
            const _SectionTitle('Theme color'),
            const Text('Select a color for your event form'),
            Row(
              children: [
                Container(
                  height: 20,
                  width: 180,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _openPicker,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Ticket options
            const _SectionTitle('Ticket options'),
            ..._tickets.map(_ticketCard).toList(),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _tickets.add({
                    "type": "New",
                    "price": 0.0,
                    "description": "",
                  });
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add ticket type'),
            ),
          ],
        ),
      ),
    );
  }

  void _openPicker() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pick a color'),
        content: BlockPicker(
          pickerColor: _color,
          onColorChanged: (c) => setState(() => _color = c),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(eventThemeColorProvider.notifier).state =
                  _color.toHexString();
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _ticketCard(Map<String, dynamic> t) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              initialValue: t['type'],
              decoration: const InputDecoration(labelText: 'Ticket type'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Required';
                }
                return null;
              },
              onChanged: (v) => t['type'] = v,
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: t['price'].toString(),
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Price', prefixText: '\$'),
              validator: (v) {
                final parsed = double.tryParse(v ?? '');
                if (parsed == null || parsed < 0) {
                  return 'Enter valid price';
                }
                return null;
              },
              onChanged: (v) =>
                  t['price'] = double.tryParse(v) ?? t['price'],
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: t['description'],
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 2,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Required';
                }
                return null;
              },
              onChanged: (v) => t['description'] = v,
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- small UI widgets ---------------- */
class _Header extends StatelessWidget {
  final String t;
  const _Header(this.t);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Text(t,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF333366))),
      );
}

class _SectionTitle extends StatelessWidget {
  final String t;
  const _SectionTitle(this.t);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(t,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF333366))),
      );
}
