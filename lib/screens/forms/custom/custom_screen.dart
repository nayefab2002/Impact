import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/custom_form_provider.dart';
import 'package:impact/providers/firebase_provider.dart';
import 'package:impact/screens/forms/custom/custom_form_advanced.dart';
import 'package:impact/screens/forms/custom/custom_form_customization.dart';
import 'package:impact/screens/forms/custom/custom_form_general.dart';
import 'package:impact/screens/forms/models/custom_form.dart';

class CustomScreen extends ConsumerStatefulWidget {
  const CustomScreen({super.key});

  @override
  ConsumerState createState() => _CustomScreenState();
}

class _CustomScreenState extends ConsumerState<CustomScreen> {
  int currentStep = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  publishEvent() async {
    final newCustomForm = CustomForm(
      id: '',
      ownerId: ref.read(currentUserIDProvider),
      createdTime: DateTime.now(),
      title: ref.read(customFormTitleControllerProvider).text,
      language: ref.read(customFormLanguageProvider),
      description: ref.read(customFormDescriptionControllerProvider).text,
      themeColor: ref.read(customFormThemeColorProvider) ?? '0xFF6A4CBC',
      formLogoUrl: ref.read(customFormLogoUrlProvider) ?? '',
      welcomeMessage: ref.read(customFormWelcomeMessageControllerProvider).text,
      showProgressBar: ref.read(customFormShowProgressBarProvider),
      enableRecurringDonations: ref.read(customFormEnableRecurringDonationsProvider),
      allowDonorComments: ref.read(customFormAllowDonorCommentsProvider),
      askToCoverFees: ref.read(customFormAskToCoverFeesProvider) ?? true,
      emailReceiptMessage: ref.read(customFormEmailReceiptMessageControllerProvider).text,
      shareableLink: ref.read(customFormShareableLinkProvider) ?? '',
      status: 'active',
    );

    await ref.read(firestoreServiceProvider).addCustomForm(newCustomForm);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Custom Form created!")),
    );
    Navigator.pop(context);
  }

  void _handleStepContinue() {
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
        title: Text("Create Custom Form",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stepper(
        steps: [
          Step(
            title: const Text("General"),
            content: CustomFormGeneral(formKey: _formKey),
            isActive: currentStep == 0,
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text("Customization"),
            content: const CustomFormCustomization(),
            isActive: currentStep == 1,
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text("Advanced"),
            content: const CustomFormAdvanced(),
            isActive: currentStep == 2,
          ),
        ],
        type: StepperType.horizontal,
        currentStep: currentStep,
        onStepTapped: (index) => setState(() => currentStep = index),
        onStepContinue: _handleStepContinue,
        onStepCancel: () {
          if (currentStep > 0) setState(() => currentStep -= 1);
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
                    await publishEvent();
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
