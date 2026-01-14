import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../providers/raffle_form_provider.dart';
import '../step_progress_indicator.dart';
import 'package:intl/intl.dart'; // Add this line
import 'package:impact/widgets/step_progress_indicator.dart';

class RaffleFormAdvanced extends ConsumerStatefulWidget {
  const RaffleFormAdvanced({super.key});

  @override
  ConsumerState createState() => _RaffleFormAdvancedState();
}

class _RaffleFormAdvancedState extends ConsumerState<RaffleFormAdvanced> {

  bool _addSalesTarget = false;
  bool _suggestCheckPayment = false;
  bool _enableDiscountCodes = false;
  final List<Map<String, dynamic>> _tickets = [
    {"title": "General", "price": 0.0, "description": ""},
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addSalesTarget=ref.read(raffleSalesTargetProvider);
    _suggestCheckPayment=ref.read(raffleSuggestCheckPaymentProvider);
    _enableDiscountCodes=ref.read(raffleEnableDiscountCodesProvider);

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _sectionTitle("Advanced Settings"),
          const SizedBox(height: 16),

          _sectionTitle("Communication"),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF6A4CBC)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Set up raffle communication",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A4CBC),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Send smart invites, schedule reminder emails, automate thank-you messages, and more",
                  style: TextStyle(
                    color: Color(0xFF6A4CBC),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _sectionTitle("Additional Form Options"),
          const SizedBox(height: 8),
          CheckboxListTile(
            title: const Text("Add a sales target"),
            value: false,
            onChanged: (val) {
              setState(() {
                _addSalesTarget=val!;
              });
              ref.read(raffleSalesTargetProvider.notifier).state=val!;
            },
          ),
          CheckboxListTile(
            title: const Text("Suggest payment by check above \$1000"),
            value: _suggestCheckPayment,
            onChanged: (val) {
              setState(() => _suggestCheckPayment = val!);
              ref.read(raffleSuggestCheckPaymentProvider.notifier).state=val!;
            },
          ),
          CheckboxListTile(
            title: const Text("Add discount codes"),
            value: _enableDiscountCodes,
            onChanged: (val) {
              setState(() => _enableDiscountCodes = val!);
              ref.read(raffleEnableDiscountCodesProvider.notifier).state=val!;
            },
          ),

          const SizedBox(height: 24),
          _sectionTitle("Ticket Options"),
          const SizedBox(height: 8),
          // ..._tickets.map((ticket) => _buildTicketCard(ticket)).toList(),
          _buildTicketCard(_tickets[0]),
          // ElevatedButton(
          //   onPressed: _addTicket,
          //   child: const Text("Add Ticket Type"),
          // ),

          const SizedBox(height: 24),
          _sectionTitle("Email Notifications"),
          const SizedBox(height: 8),
          const Text("EMAIL ADDRESSES TO NOTIFY WHEN A PAYMENT IS MADE (SEPARATE EMAILS WITH COMMAS)"),
          const SizedBox(height: 8),
          TextField(
            controller: ref.read(raffleNotificationEmailsControllerProvider),
            decoration: const InputDecoration(
              hintText: "email@example.com",
              border: OutlineInputBorder(),
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

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextFormField(
              initialValue: ticket["title"],
              decoration: const InputDecoration(labelText: "Ticket Title"),
              onChanged: (value) {
                setState(() {
                  ticket["title"] = value;
                });
                ref.read(raffleTicketOptionsProvider.notifier).state=ticket;
              },
            ),
            TextFormField(
              initialValue: ticket["price"].toString(),
              decoration: const InputDecoration(labelText: "Price (\$)"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  ticket["price"] = double.tryParse(value) ?? 0.0;
                });
                ref.read(raffleTicketOptionsProvider.notifier).state=ticket;
              }
            ),
            TextFormField(
              initialValue: ticket["description"],
              decoration: const InputDecoration(labelText: "Description"),
              onChanged: (value) {
                setState(() {
                  ticket["description"] = value;
                });
                ref.read(raffleTicketOptionsProvider.notifier).state=ticket;
              }
            ),
          ],
        ),
      ),
    );
  }

  void _addTicket() {
    setState(() {
      _tickets.add({
        "title": "New Ticket",
        "price": 0.0,
        "description": "",
      });
    });
  }
}
