import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/firebase_provider.dart';
import 'package:impact/providers/event_form_provider.dart';
import 'package:impact/screens/forms/event/event_form_advanced.dart';
import 'package:impact/screens/forms/event/event_form_customization.dart';
import 'package:impact/screens/forms/event/event_form_general.dart';
import '../models/event_form.dart';

class EventScreen extends ConsumerStatefulWidget {
  const EventScreen({super.key});

  @override
  ConsumerState createState() => _EventScreenState();
}

class _EventScreenState extends ConsumerState<EventScreen> {
  int currentStep = 0;

  final _generalFormKey = GlobalKey<FormState>();
  final _customizationFormKey = GlobalKey<FormState>();
  final _advancedFormKey = GlobalKey<EventFormAdvancedState>();

  publishEvent() async {
    final newEventForm = EventForm(
      id: "",
      ownerId: ref.read(currentUserIDProvider),
      createdTime: ref.read(eventCreatedTimeProvider),
      dateTime: ref.read(eventFormDateTimeProvider),
      title: ref.read(titleControllerProvider).text,
      address: ref.read(addressControllerProvider).text,
      description:
          ref.read(descriptionQuillController).document.toDelta().toJson(),
      themeColor: ref.read(eventThemeColorProvider),
      eventLogoUrl: ref.read(eventLogoUrlProvider),
      ticketOptions: ref.read(eventTicketOptionsProvider),
      attendeeInfoCollection: ref.read(attendeeInfoCollectionProvider),
      shareableLink: ref.read(eventShareableLinkProvider),
      status: ref.read(eventStatusProvider),
    );

    await ref.read(firestoreServiceProvider).addEventForm(newEventForm);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Event created!")),
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
          "Create Event Form",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
      ),
      body: Stepper(
        steps: [
          Step(
            title: const Text("General"),
            content: EventFormGeneral(formKey: _generalFormKey),
            isActive: currentStep == 0,
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text("Customization"),
            content: Form(
              key: _customizationFormKey,
              child: const EventFormCustomization(),
            ),
            isActive: currentStep == 1,
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text("Advanced"),
            content: EventFormAdvanced(key: _advancedFormKey),
            isActive: currentStep == 2,
          ),
        ],
        type: StepperType.horizontal,
        currentStep: currentStep,
        onStepTapped: (index) {
          setState(() {
            currentStep = index;
          });
        },
        onStepContinue: () {
          if (currentStep == 0) {
            if (_generalFormKey.currentState?.validate() ?? false) {
              setState(() => currentStep += 1);
            }
          } else if (currentStep == 1) {
            if (_customizationFormKey.currentState?.validate() ?? false) {
              setState(() => currentStep += 1);
            }
          }
        },
        onStepCancel: () {
          if (currentStep != 0) {
            setState(() => currentStep -= 1);
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
                  onPressed: () {
                    final isValid =
                        _advancedFormKey.currentState?.validate() ?? false;
                    if (isValid) publishEvent();
                  },
                  child: const Text("Publish"),
                ),
              const SizedBox(width: 12),
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
