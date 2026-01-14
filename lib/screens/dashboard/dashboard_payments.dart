// lib/screens/dashboard/dashboard_payments.dart
import 'dart:convert' show utf8;
import 'dart:html' as html; // ← for CSV download on web
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// ─────────────────────────────────────────────────────────────
/// Tiny VO that keeps the filter state local to the widget
/// ─────────────────────────────────────────────────────────────
class _PaymentsFilter {
  const _PaymentsFilter({
    this.query = '',
    this.status = 'all',
    this.dateFrom,
    this.dateTo,
  });

  final String query; // search text
  final String status; // all | completed | pending | failed
  final DateTime? dateFrom; // inclusive
  final DateTime? dateTo; // inclusive

  bool match(Map<String, dynamic> p) {
    /* text search */
    final q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      final hay =
          '${p['contact'] ?? ''} ${p['details'] ?? ''} '
                  '${p['formType'] ?? ''}'
              .toLowerCase();
      if (!hay.contains(q)) return false;
    }

    /* status */
    if (status != 'all' &&
        (p['status'] ?? '').toString().toLowerCase() != status) {
      return false;
    }

    /* date range */
    if (dateFrom != null || dateTo != null) {
      final ts = (p['date'] as Timestamp?)?.toDate();
      if (ts == null) return false;
      if (dateFrom != null && ts.isBefore(dateFrom!)) return false;
      if (dateTo != null && ts.isAfter(dateTo!)) return false;
    }
    return true;
  }

  _PaymentsFilter copyWith({
    String? query,
    String? status,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) => _PaymentsFilter(
    query: query ?? this.query,
    status: status ?? this.status,
    dateFrom: dateFrom ?? this.dateFrom,
    dateTo: dateTo ?? this.dateTo,
  );
}

/// ─────────────────────────────────────────────────────────────
/// Payments page  (stateful because it owns the filter)
/// ─────────────────────────────────────────────────────────────
class DashboardPayments extends StatefulWidget {
  const DashboardPayments({Key? key}) : super(key: key);

  @override
  State<DashboardPayments> createState() => _DashboardPaymentsState();
}

class _DashboardPaymentsState extends State<DashboardPayments> {
  _PaymentsFilter _filter = const _PaymentsFilter();

  /* ─── filter setters ─── */
  void _setQuery(String q) =>
      setState(() => _filter = _filter.copyWith(query: q));

  void _setStatus(String s) =>
      setState(() => _filter = _filter.copyWith(status: s));

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      initialDateRange:
          _filter.dateFrom != null && _filter.dateTo != null
              ? DateTimeRange(start: _filter.dateFrom!, end: _filter.dateTo!)
              : null,
    );
    if (picked != null) {
      setState(
        () =>
            _filter = _filter.copyWith(
              dateFrom: picked.start,
              dateTo: picked.end,
            ),
      );
    }
  }

  /* ─── add-payment dialog (mock) ─── */
  Future<void> _openAddPayment() async {
    final formKey = GlobalKey<FormState>();
    final amountCtrl = TextEditingController();
    final contactCtrl = TextEditingController();
    final detailsCtrl = TextEditingController();
    String statusSel = 'pending';
    String methodSel = 'Card';
    String formSel = 'Donation';

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (_) => AlertDialog(
            title: const Text('New Payment (mock)'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: amountCtrl,
                      decoration: const InputDecoration(labelText: 'Amount'),
                      keyboardType: TextInputType.number,
                      validator:
                          (v) =>
                              double.tryParse(v ?? '') == null
                                  ? 'Enter a number'
                                  : null,
                    ),
                    TextFormField(
                      controller: contactCtrl,
                      decoration: const InputDecoration(labelText: 'Contact'),
                      validator:
                          (v) =>
                              v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: detailsCtrl,
                      decoration: const InputDecoration(labelText: 'Details'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: statusSel,
                      items: const [
                        DropdownMenuItem(
                          value: 'pending',
                          child: Text('Pending'),
                        ),
                        DropdownMenuItem(
                          value: 'completed',
                          child: Text('Completed'),
                        ),
                        DropdownMenuItem(
                          value: 'failed',
                          child: Text('Failed'),
                        ),
                      ],
                      onChanged: (v) => statusSel = v ?? 'pending',
                      decoration: const InputDecoration(labelText: 'Status'),
                    ),
                    DropdownButtonFormField<String>(
                      value: methodSel,
                      items: const [
                        DropdownMenuItem(value: 'Card', child: Text('Card')),
                        DropdownMenuItem(value: 'Bank', child: Text('Bank')),
                        DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                      ],
                      onChanged: (v) => methodSel = v ?? 'Card',
                      decoration: const InputDecoration(
                        labelText: 'Payment method',
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: formSel,
                      items: const [
                        DropdownMenuItem(
                          value: 'Donation',
                          child: Text('Donation'),
                        ),
                        DropdownMenuItem(value: 'Event', child: Text('Event')),
                        DropdownMenuItem(value: 'Shop', child: Text('Shop')),
                      ],
                      onChanged: (v) => formSel = v ?? 'Donation',
                      decoration: const InputDecoration(labelText: 'Form type'),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed:
                    () => Navigator.of(context, rootNavigator: true).pop(),
                // <-- fixed
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  await FirebaseFirestore.instance.collection('payments').add({
                    'amount': double.parse(amountCtrl.text),
                    'contact': contactCtrl.text.trim(),
                    'details': detailsCtrl.text.trim(),
                    'status': statusSel,
                    'paymentMethod': methodSel,
                    'formType': formSel,
                    'date': Timestamp.now(),
                  });
                  if (mounted) {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pop(); // <-- fixed
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  /* ─── CSV export (web-only) ─── */
  Future<void> _exportCsv(List<QueryDocumentSnapshot> rows) async {
    if (rows.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nothing to export')));
      return;
    }
    final buffer =
        StringBuffer()
          ..writeln('Amount,Contact,Date,Details,Status,Method,Form');
    for (final d in rows) {
      final p = d.data() as Map<String, dynamic>;
      buffer.writeln(
        '"${p['amount']}",'
        '"${p['contact']}",'
        '"${_fmtDate(p['date'])}",'
        '"${p['details'] ?? ''}",'
        '"${p['status']}",'
        '"${p['paymentMethod']}",'
        '"${p['formType']}"',
      );
    }
    final bytes = utf8.encode(buffer.toString());
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor =
        html.AnchorElement(href: url)
          ..download = 'payments.csv'
          ..click();
    html.Url.revokeObjectUrl(url);
  }

  /* ─── UI ─── */
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payments',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _toolbar(),
          const SizedBox(height: 16),
          Expanded(child: _paymentsTable()),
        ],
      ),
    );
  }

  Widget _toolbar() {
    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        /* search */
        SizedBox(
          width: 260,
          height: 40,
          child: TextField(
            onChanged: _setQuery,
            decoration: InputDecoration(
              hintText: 'Search…',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        /* status popup */
        PopupMenuButton<String>(
          onSelected: _setStatus,
          itemBuilder:
              (_) => const [
                PopupMenuItem(value: 'all', child: Text('All Statuses')),
                PopupMenuItem(value: 'completed', child: Text('Completed')),
                PopupMenuItem(value: 'pending', child: Text('Pending')),
                PopupMenuItem(value: 'failed', child: Text('Failed')),
              ],
          child: _Chip(
            label:
                _filter.status == 'all'
                    ? 'Filter by status'
                    : 'Status: ${_filter.status}',
          ),
        ),
        /* date-range picker */
        OutlinedButton.icon(
          icon: const Icon(Icons.calendar_today, size: 18),
          label: Text(
            _filter.dateFrom == null
                ? 'Add a date range'
                : '${DateFormat.yMd().format(_filter.dateFrom!)} – '
                    '${DateFormat.yMd().format(_filter.dateTo!)}',
          ),
          onPressed: _pickRange,
        ),
        /* export CSV */
        IconButton(
          tooltip: 'Export CSV',
          icon: const Icon(Icons.download),
          onPressed: () async {
            final snap =
                await FirebaseFirestore.instance
                    .collection('payments')
                    .orderBy('date', descending: true)
                    .get();
            final filtered =
                snap.docs
                    .where(
                      (d) => _filter.match(d.data() as Map<String, dynamic>),
                    )
                    .toList();
            await _exportCsv(filtered);
          },
        ),
        /* add payment */
        ElevatedButton.icon(
          icon: const Icon(Icons.add, size: 18, color: Colors.white70),
          label: const Text('Add payment'),
          onPressed: _openAddPayment,
        ),
      ],
    );
  }

  /// live stream → filter → table
  Widget _paymentsTable() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('payments')
              .orderBy('date', descending: true)
              .snapshots(),
      builder: (ctx, snap) {
        if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final rows =
            (snap.data?.docs ?? [])
                .where((d) => _filter.match(d.data() as Map<String, dynamic>))
                .toList();

        if (rows.isEmpty) return const Center(child: Text('No payments found'));
        return DataTable2(
          columns: [
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Contact')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Details')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Method')),
            DataColumn(label: Text('Form')),
          ],
          rows: rows.map(_dataRow).toList(),
        );
      },
    );
  }

  DataRow _dataRow(QueryDocumentSnapshot doc) {
    final p = doc.data() as Map<String, dynamic>;
    final statusColor = _statusColor(p['status']);
    return DataRow(
      cells: [
        DataCell(Text('\$${(p['amount'] ?? 0).toStringAsFixed(2)}')),
        DataCell(Text(p['contact'] ?? '—')),
        DataCell(Text(_fmtDate(p['date']))),
        DataCell(Text(p['details'] ?? '—')),
        DataCell(
          Chip(
            label: Text(
              p['status'] ?? 'pending',
              style: const TextStyle(fontSize: 12),
            ),
            backgroundColor: statusColor.withOpacity(.15),
            labelStyle: TextStyle(color: statusColor),
          ),
        ),
        DataCell(Text(p['paymentMethod'] ?? '—')),
        DataCell(Text(p['formType'] ?? '—')),
      ],
    );
  }

  /* misc helpers */
  String _fmtDate(dynamic ts) =>
      ts is Timestamp ? DateFormat.yMMMd().format(ts.toDate()) : '—';

  Color _statusColor(String? s) {
    switch ((s ?? '').toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

/* helper pill-style button */
class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(label),
  );
}
