import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/membership_form_provider.dart';
import 'package:impact/widgets/step_progress_indicator.dart';

class MembershipFormCustomization extends ConsumerStatefulWidget {
  const MembershipFormCustomization({super.key});

  @override
  ConsumerState createState() => _MembershipFormCustomizationState();
}

class _MembershipFormCustomizationState extends ConsumerState<MembershipFormCustomization> {
  // Customization toggles
  bool emailNotification = true;
  bool showGoal = false;
  bool showProgress = false;

  // Advanced Settings toggles
  bool allowComments = false;
  bool enableReceipt = false;
  bool enableReminders = false;
  bool allowOffline = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Customize Experience"),
          const SizedBox(height: 16),

          SwitchListTile(
            title: const Text("Send email confirmation after membership purchase"),
            value: emailNotification,
            onChanged: (value) {
              setState(() => emailNotification = value);
              ref.read(membershipEmailNotificationProvider.notifier).state=value;
            },
          ),
          SwitchListTile(
            title: const Text("Display fundraising goal"),
            value: showGoal,
            onChanged: (value) {
              setState(() => showGoal = value);
              ref.read(membershipShowGoalProvider.notifier).state=value;
            },
          ),
          SwitchListTile(
            title: const Text("Display progress bar on campaign"),
            value: showProgress,
            onChanged: (value) {
              setState(() => showProgress = value);
              ref.read(membershipShowProgressProvider.notifier).state=value;
            },
          ),

          const SizedBox(height: 32),
          _sectionTitle("Advanced Settings"),
          const SizedBox(height: 16),

          SwitchListTile.adaptive(
            title: const Text("Allow comments from donors"),
            value: allowComments,
            onChanged: (val) {
              setState(() => allowComments = val);
              ref.read(membershipAllowCommentsProvider.notifier).state=val;
            },
          ),
          const Divider(height: 32),

          SwitchListTile.adaptive(
            title: const Text("Send receipt to members"),
            subtitle: const Text("Automatically email a receipt after membership purchase."),
            value: enableReceipt,
            onChanged: (val) {
              setState(() => enableReceipt = val);
              ref.read(membershipEnableReceiptProvider.notifier).state=val;
            },
          ),
          const Divider(height: 32),

          SwitchListTile.adaptive(
            title: const Text("Enable renewal reminders"),
            subtitle: const Text("Send automatic email reminders when memberships are about to expire."),
            value: enableReminders,
            onChanged: (val) {
              setState(() => enableReminders = val);
              ref.read(membershipEnableRemindersProvider.notifier).state=val;
            }
          ),
          const Divider(height: 32),

          SwitchListTile.adaptive(
            title: const Text("Allow offline payment options"),
            subtitle: const Text("Let members pay via cash, check, or other offline methods."),
            value: allowOffline,
            onChanged: (val) {
              setState(() => allowOffline = val);
              ref.read(membershipAllowOfflineProvider.notifier).state=val;
            },
          ),

        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Color(0xFF333366),
      ),
    );
  }
}
