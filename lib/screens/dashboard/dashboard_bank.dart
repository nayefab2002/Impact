import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/models/bank_account.dart';
import 'package:impact/providers/firebase_provider.dart';
import 'package:impact/providers/bank_provider.dart';

class DashboardBank extends ConsumerWidget {
  const DashboardBank({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.read(currentUserIDProvider);
    final state = ref.watch(bankProvider(userId));
    final notifier = ref.read(bankProvider(userId).notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AccountSummaryCard(count: state.accounts.length),

            if (state.isLoading) const LinearProgressIndicator(),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  state.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),

            const SizedBox(height: 32),
            _SectionTitle('Connected Bank Accounts'),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.accounts.length,
              itemBuilder: (_, i) {
                final account = state.accounts[i];
                return _BankAccountCard(
                  account: account,
                  onDelete: () => notifier.removeAccount(account.id),
                );
              },
            ),

            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _openConnectDialog(context, notifier),
              icon: const Icon(Icons.link, color: Colors.white70),
              label: const Text('Connect New Bank'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openConnectDialog(
    BuildContext ctx,
    BankNotifier notifier,
  ) async {
    final formKey = GlobalKey<FormState>();
    final bankCtrl = TextEditingController();
    final typeCtrl = TextEditingController();
    final accountCtrl = TextEditingController();
    final routingCtrl = TextEditingController();

    await showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Connect Bank Account'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: bankCtrl,
                decoration: const InputDecoration(labelText: 'Bank name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: typeCtrl,
                decoration: const InputDecoration(labelText: 'Account type (e.g., Checking)'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: accountCtrl,
                decoration: const InputDecoration(labelText: 'Account number'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
              TextFormField(
                controller: routingCtrl,
                decoration: const InputDecoration(labelText: 'Routing number'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              await notifier.addAccount(
                BankAccount(
                  bankName: bankCtrl.text.trim(),
                  accountType: typeCtrl.text.trim(),
                  accountNumber: accountCtrl.text.trim(),
                  routingNumber: routingCtrl.text.trim(),
                ),
              );
              if (ctx.mounted) Navigator.of(ctx, rootNavigator: true).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// Helper Widgets
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  );
}

class _AccountSummaryCard extends StatelessWidget {
  final int count;
  
  const _AccountSummaryCard({required this.count});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Connected Account${count != 1 ? 's' : ''}',
                  style: TextStyle(color: Colors.blue[800]),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.account_balance_wallet, size: 40, color: Colors.blue[800]),
          ],
        ),
      ),
    );
  }
}

class _BankAccountCard extends StatelessWidget {
  final BankAccount account;
  final VoidCallback onDelete;
  
  const _BankAccountCard({
    required this.account,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final lastFourAcct = account.accountNumber.length > 4 
        ? account.accountNumber.substring(account.accountNumber.length - 4)
        : account.accountNumber;
        
    final lastFourRouting = account.routingNumber.length > 4 
        ? account.routingNumber.substring(account.routingNumber.length - 4)
        : account.routingNumber;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance, color: Colors.blue[800]),
                const SizedBox(width: 12),
                Text(
                  account.bankName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _AccountDetailRow(
              label: 'Account Type',
              value: account.accountType,
            ),
            _AccountDetailRow(
              label: 'Account Number',
              value: '••••$lastFourAcct',
            ),
            _AccountDetailRow(
              label: 'Routing Number',
              value: '••••$lastFourRouting',
            ),
            _AccountDetailRow(
              label: 'Added',
              value: '${account.createdAt.day}/${account.createdAt.month}/${account.createdAt.year}',
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountDetailRow extends StatelessWidget {
  final String label;
  final String value;
  
  const _AccountDetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}