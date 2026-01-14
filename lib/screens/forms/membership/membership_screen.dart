import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/firebase_provider.dart';
import 'package:impact/providers/membership_form_provider.dart';
import 'package:impact/screens/forms/membership/membership_form_customization.dart';
import 'package:impact/screens/forms/membership/membership_form_general.dart';
import 'package:impact/screens/forms/membership/membership_form_memberships.dart';
import 'package:impact/screens/forms/models/membership_form.dart';

class MembershipScreen extends ConsumerStatefulWidget {
  const MembershipScreen({super.key});

  @override
  ConsumerState createState() => _MembershipScreenState();
}

class _MembershipScreenState extends ConsumerState<MembershipScreen> {
  int currentStep = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  publishMemberShipForm() async {
    final newForm = MembershipForm(
      id: "",
      ownerId: ref.read(currentUserIDProvider),
      createdTime: DateTime.now(),
      title: ref.read(membershipTitleControllerProvider).text,
      language: ref.read(membershipFormLanguageProvider),
      description: ref.read(membershipDescriptionQuillController).document.toDelta().toJson(),
      membershipLevels: ref.read(membershipLevelsProvider),
      shareableLink: ref.read(membershipShareableLinkProvider),
      status: ref.read(membershipStatusProvider),
      allowComments: ref.read(membershipAllowCommentsProvider),
      allowDonation: ref.read(membershipAllowDonationProvider),
      allowOffline: ref.read(membershipAllowOfflineProvider),
      showGoal: ref.read(membershipShowGoalProvider),
      showProgress: ref.read(membershipShowProgressProvider),
      requireAddress: ref.read(membershipRequireAddressProvider),
      emailNotification: ref.read(membershipEmailNotificationProvider),
      enableReceipt: ref.read(membershipEnableReceiptProvider),
      enableReminders: ref.read(membershipEnableRemindersProvider),
    );

    await ref.read(firestoreServiceProvider).addMembershipForm(newForm);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Membership form created!")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF6A4CBC)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Create Membership Form",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stepper(
        steps: [
          Step(
            title: const Text("General"),
            content: MembershipFormGeneral(formKey: _formKey),
            isActive: currentStep == 0,
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text("Memberships"),
            content: const MembershipFormMemberships(),
            isActive: currentStep == 1,
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text("Customization"),
            content: const MembershipFormCustomization(),
            isActive: currentStep == 2,
          ),
        ],
        type: StepperType.horizontal,
        onStepTapped: (index) {
          setState(() {
            currentStep = index;
          });
        },
        currentStep: currentStep,
        onStepContinue: () {
          if (currentStep == 0) {
            if (_formKey.currentState?.validate() ?? false) {
              setState(() {
                currentStep += 1;
              });
            }
          } else if (currentStep < 2) {
            setState(() {
              currentStep += 1;
            });
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() {
              currentStep -= 1;
            });
          }
        },
        controlsBuilder: (context, details) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (currentStep != 2)
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: const Text("Continue"),
                ),
              if (currentStep == 2)
                ElevatedButton(
                  onPressed: () async {
                    await publishMemberShipForm();
                  },
                  child: const Text("Publish"),
                ),
              const SizedBox(width: 16),
              if (currentStep != 0)
                ElevatedButton(
                  onPressed: details.onStepCancel,
                  child: const Text("Back"),
                ),
            ],
          );
        },
      ),
    );
  }
}
