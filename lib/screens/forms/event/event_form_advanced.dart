import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/event_form_provider.dart';

class EventFormAdvanced extends ConsumerStatefulWidget {
  const EventFormAdvanced({super.key});

  @override
  ConsumerState<EventFormAdvanced> createState() => EventFormAdvancedState();
}

class EventFormAdvancedState extends ConsumerState<EventFormAdvanced> {
  final _formKey = GlobalKey<FormState>();

  bool _reqWaiver = false;
  bool _grpDiscount = false;

  bool _needName = true;
  bool _needEmail = true;
  bool _needPhone = false;

  final _emailsCtrl = TextEditingController();

  /// Expose validator to parent
  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header('Advanced settings'),

            _Section('Collect attendee info', children: [
              _checkbox('First & last name', _needName,
                  (v) => setState(() => _needName = v)),
              _checkbox('Email address', _needEmail,
                  (v) => setState(() => _needEmail = v)),
              _checkbox('Phone number', _needPhone,
                  (v) => setState(() => _needPhone = v)),
            ]),

            _Section('Notifications', children: [
              TextFormField(
                controller: _emailsCtrl,
                decoration: const InputDecoration(
                  labelText: 'Emails to notify (comma separated)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  final emails = value.split(',').map((e) => e.trim());
                  final emailRegex =
                      RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                  for (final email in emails) {
                    if (!emailRegex.hasMatch(email)) {
                      return 'Invalid email: $email';
                    }
                  }
                  return null;
                },
              ),
            ]),

            _Section('Additional options', children: [
              _checkbox('Require waiver acceptance', _reqWaiver,
                  (v) => setState(() => _reqWaiver = v)),
              _checkbox('Allow group discount (5+)', _grpDiscount,
                  (v) => setState(() => _grpDiscount = v)),
            ]),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────
  Widget _checkbox(String lbl, bool val, ValueChanged<bool> cb) =>
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(lbl),
        value: val,
        onChanged: (v) => cb(v ?? false),
      );
}

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

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section(this.title, {required this.children});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF333366))),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      );
}
