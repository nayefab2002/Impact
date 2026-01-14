import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/donation_form_provider.dart';
import 'package:impact/screens/forms/donation/donation_form_advanced.dart';
import 'package:impact/screens/forms/donation/donation_form_customization.dart';
import 'package:impact/screens/forms/donation/donation_form_general.dart';
import 'package:impact/screens/forms/models/donation_form.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/firebase_provider.dart';

class DonationScreen extends ConsumerStatefulWidget {
  const DonationScreen({super.key});

  @override
  ConsumerState createState() => _DonationScreenState();
}

class _DonationScreenState extends ConsumerState<DonationScreen> {
  int currentStep = 0;

  final GlobalKey<FormState> _generalFormKey = GlobalKey<FormState>();

  publishDonationForm() async {
    final newDonationForm = DonationForm(
      id: "",
      ownerId: ref.read(currentUserIDProvider),
      createdTime: ref.read(donationFormDateTimeProvider),
      title: ref.read(donationTitleControllerProvider).text,
      language: ref.read(donationFormLanguageProvider),
      description: ref.read(donationDescriptionQuillController).document.toDelta().toJson(),
      themeColor: ref.read(donationThemeColorProvider),
      eventLogoUrl: "",
      bannerUrl: "",
      suggestedDonationAmount: ref.read(donationSuggestedDonationAmountProvider),
      donorQuestions: ref.read(donationDonorQuestionsProvider),
      shareableLink: ref.read(donationShareableLinkProvider),
      status: ref.read(donationStatusProvider),
      emailBody: ref.read(emailBodyQuillController).document.toPlainText(),
      emailSubject: ref.read(emailSubjectProvider).text,
      toAddThermometer: ref.read(toAddThermometerProvider),
      emailToNotify: ref.read(emailAddressController).text,
      isGenerateTaxReceipt: ref.read(toGenerateTaxReceiptProvider),
    );

    await ref.read(firestoreServiceProvider).addDonationForm(newDonationForm);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Donation Form created!")));
    Navigator.pop(context);
  }

  Future<String> uploadImageToFirebase(Uint8List bytes) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      String fileName = "Images/donationForm/${DateTime.now().toIso8601String()}.jpg";
      final imageRef = storageRef.child(fileName);
      final uploadTask = imageRef.putData(bytes, SettableMetadata(contentType: "Image/jpg"));
      final snapShot = await uploadTask;
      final String downloadImagePath = await snapShot.ref.getDownloadURL();
      return downloadImagePath;
    } catch (e) {
      return "";
    }
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
          "Create Donation Form",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stepper(
        steps: [
          Step(
            title: Text("General"),
            content: DonationFormGeneral(formKey: _generalFormKey),
            isActive: currentStep == 0,
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: Text("Customization"),
            content: DonationFormCustomization(),
            isActive: currentStep == 1,
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: Text("Advanced"),
            content: DonationFormAdvanced(),
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
            final isValid = _generalFormKey.currentState?.validate() ?? false;
            if (isValid) {
              setState(() {
                currentStep += 1;
              });
            }
          } else if (currentStep != 2) {
            setState(() {
              currentStep += 1;
            });
          }
        },
        onStepCancel: () {
          if (currentStep != 0) {
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
                  child: Text("Continue"),
                ),
              if (currentStep == 2)
                ElevatedButton(
                  onPressed: () async {
                    await publishDonationForm();
                  },
                  child: Text("Publish"),
                ),
              if (currentStep != 0)
                ElevatedButton(
                  onPressed: details.onStepCancel,
                  child: Text("Back"),
                ),
            ],
          );
        },
      ),
    );
  }
}
