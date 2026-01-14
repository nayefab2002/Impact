import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/auction_form_provider.dart';
import 'package:impact/providers/firebase_provider.dart';
import 'package:impact/screens/forms/auction/auction_form_advanced.dart';
import 'package:impact/screens/forms/auction/auction_form_customization.dart';
import 'package:impact/screens/forms/auction/auction_form_general.dart';
import 'package:impact/screens/forms/models/auction_form.dart';
import 'package:intl/intl.dart';

class AuctionScreen extends ConsumerStatefulWidget {
  const AuctionScreen({super.key});

  @override
  ConsumerState createState() => _AuctionScreenState();
}

class _AuctionScreenState extends ConsumerState<AuctionScreen> {
  int currentStep = 0;
  final _generalFormKey = GlobalKey<FormState>();

  publishAuctionForm() async {
    DateFormat format = DateFormat("MM/dd/yyyy HH:mm");
    final newAuctionForm = AuctionForm(
      id: '',
      ownerId: ref.read(currentUserIDProvider),
      createdTime: DateTime.now(),
      title: ref.read(auctionTitleControllerProvider).text,
      description: ref.read(auctionDescriptionControllerProvider).text,
      startDateTime: format.parse(ref.read(auctionStartDateControllerProvider).text),
      endDateTime: format.parse(ref.read(auctionEndDateControllerProvider).text),
      startingBid: ref.read(auctionStartingBidProvider),
      enableBidIncrements: ref.read(auctionEnableBidIncrementsProvider),
      bidIncrement: ref.read(auctionBidIncrementProvider),
      themeColor: ref.read(auctionThemeColorProvider),
      enableNotifications: ref.read(auctionEnableNotificationsProvider),
      requireApproval: ref.read(auctionRequireApprovalProvider),
      allowDiscountCodes: ref.read(auctionAllowDiscountCodesProvider),
      notificationEmail: ref.read(auctionNotificationEmailProvider),
      status: 'active',
      shareableLink: ref.read(auctionShareableLinkProvider),
    );

    await ref.read(firestoreServiceProvider).addAuctionForm(newAuctionForm);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Auction Form created!")),
    );
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
          "Create Auction Form",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stepper(
        steps: [
          Step(
            title: const Text("General"),
            content: AuctionFormGeneral(formKey: _generalFormKey),
            isActive: currentStep == 0,
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text("Customization"),
            content: AuctionFormCustomization(),
            isActive: currentStep == 1,
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text("Advanced"),
            content: AuctionFormAdvanced(),
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
            if (_generalFormKey.currentState!.validate()) {
              setState(() {
                currentStep++;
              });
            }
          } else if (currentStep == 1) {
            setState(() {
              currentStep++;
            });
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() {
              currentStep--;
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
                    await publishAuctionForm();
                  },
                  child: const Text("Publish"),
                ),
              if (currentStep != 0)
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
