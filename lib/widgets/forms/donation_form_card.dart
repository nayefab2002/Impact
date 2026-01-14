import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:impact/screens/forms/models/donation_form.dart';
import 'package:impact/widgets/forms/stat_item.dart';
import 'package:intl/intl.dart';

class DonationFormCard extends StatelessWidget {
  final DonationForm form;
  final VoidCallback onEdit;
  final VoidCallback onView;

  const DonationFormCard({
    super.key,
    required this.form,
    required this.onEdit,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = form.status == 'active';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onView,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with badge and actions
              Row(
                children: [
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.volunteer_activism,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Donation',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Status indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      isActive ? 'LIVE' : 'DRAFT',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isActive ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Action buttons
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: onEdit,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.visibility_outlined,
                      size: 20,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: onView,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Title
              Text(
                form.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              // Stats
              Row(
                children: [
                  buildStatItem(
                    context,
                    icon: Icons.attach_money,
                    value: NumberFormat.simpleCurrency().format(120),
                    label: 'Raised',
                  ),
                  const SizedBox(width: 16),
                  buildStatItem(
                    context,
                    icon: Icons.confirmation_number_outlined,
                    value: "50",
                    label: 'Tickets',
                  ),
                  const SizedBox(width: 16),
                  buildStatItem(
                    context,
                    icon: Icons.calendar_today_outlined,
                    value: DateFormat('MMM dd').format(form.createdTime),
                    label: 'Created',
                  ),
                  const SizedBox(width: 20),
                  IconButton(onPressed: (){
                    String copyLink="https://impact.web.app/donations/${form.id}";
                    Clipboard.setData(ClipboardData(text: copyLink));
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text("link copied!")));

                  }, icon: Icon(Icons.copy,color: Colors.blue,))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}