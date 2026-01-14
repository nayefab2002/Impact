import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/widgets/step_progress_indicator.dart';

import '../../../providers/membership_form_provider.dart';

class MembershipFormMemberships extends ConsumerStatefulWidget {
  const MembershipFormMemberships({super.key});

  @override
  ConsumerState createState() => _MembershipFormMembershipsState();
}

class _MembershipFormMembershipsState extends ConsumerState<MembershipFormMemberships> {
  final List<Map<String, dynamic>> _membershipLevels = [
    {
      "name": "Standard Member",
      "price": "25",
      "validity": "yearly",
      "description": ""
    }
  ];

  bool _allowDonation = true;
  bool _requireAddress = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Membership Levels"),
          const SizedBox(height: 8),
          const Text("Add different membership tiers with price and duration."),
          const SizedBox(height: 16),
          ...List.generate(_membershipLevels.length, (index){
            return _buildMembershipCard(_membershipLevels[index],index);
          }),
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add Membership Level"),
            onPressed: _addMembershipLevel,
          ),

          const SizedBox(height: 32),
          _sectionTitle("Additional Donation"),
          CheckboxListTile(
            title: const Text("Allow members to add a donation during sign up"),
            value: _allowDonation,
            onChanged: (val) => setState(() {
              _allowDonation = val!;
              ref.read(membershipAllowDonationProvider.notifier).state=val;
            }),
          ),

          const SizedBox(height: 24),
          _sectionTitle("Information to Collect"),
          const Text("By default, we ask for name, email, state, and country."),
          const SizedBox(height: 12),
          CheckboxListTile(
            title: const Text("Require mailing address"),
            value: _requireAddress,
            onChanged: (val) {
              setState(() => _requireAddress = val!);
              ref.read(membershipRequireAddressProvider.notifier).state=val!;
            },
          ),
          // const SizedBox(height: 8),
          // ElevatedButton(
          //   onPressed: () {
          //     // Placeholder for adding more fields
          //   },
          //   child: const Text("+ Add a custom question"),
          // ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildMembershipCard(Map<String, dynamic> level, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: ref.read(membershipLevelNameController),
              decoration: const InputDecoration(labelText: "Membership Name"),
              onChanged: (value) {
                level["name"] = value;
                setState(() {
                  _membershipLevels[index]=level;
                });
                ref.read(membershipLevelsProvider.notifier).state=_membershipLevels;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: ref.read(membershipLevelPriceController),
              decoration: const InputDecoration(
                labelText: "Price",
                prefixText: "\$",
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                level["price"] = value;
                setState(() {
                  _membershipLevels[index]=level;
                });
                ref.read(membershipLevelsProvider.notifier).state=_membershipLevels;
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: level["validity"],
              decoration: const InputDecoration(labelText: "Validity"),
              items: const [
                DropdownMenuItem(value: "monthly", child: Text("Monthly")),
                DropdownMenuItem(value: "yearly", child: Text("Yearly")),
                DropdownMenuItem(value: "none", child: Text("No Expiration")),
              ],
              onChanged: (val) {
                level["validity"] = val;
                setState(() {
                  _membershipLevels[index]=level;
                });
                ref.read(membershipLevelsProvider.notifier).state=_membershipLevels;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 2,
              onChanged: (value) {
                level["description"] = value;
                setState(() {
                  _membershipLevels[index]=level;
                });
                ref.read(membershipLevelsProvider.notifier).state=_membershipLevels;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Color(0xFF333366),
      ),
    );
  }

  void _addMembershipLevel() {
    setState(() {
      _membershipLevels.add({
        "name": "New Member",
        "price": "0",
        "validity": "monthly",
        "description": "",
      });
    });
    ref.read(membershipLevelsProvider.notifier).state=_membershipLevels;
  }
}
