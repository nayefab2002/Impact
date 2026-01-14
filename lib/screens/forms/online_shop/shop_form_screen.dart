import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact/providers/firebase_provider.dart';
import 'package:impact/providers/online_shop_form_provider.dart';
import 'package:impact/screens/forms/models/online_shop_form.dart';
import 'package:impact/screens/forms/online_shop/shop_form_advanced.dart';
import 'package:impact/screens/forms/online_shop/shop_form_customization.dart';
import 'package:impact/screens/forms/online_shop/shop_form_general.dart';

class OnlineShopScreen extends ConsumerStatefulWidget {
  const OnlineShopScreen({super.key});

  @override
  ConsumerState createState() => _OnlineShopScreenState();
}

class _OnlineShopScreenState extends ConsumerState<OnlineShopScreen> {
  int currentStep = 0;

  publishOnlineShopForm() async {
    final newShopForm = ShopForm(
      id: '',
      ownerId: ref.read(currentUserIDProvider),
      createdTime: DateTime.now(),
      title: ref.read(shopTitleControllerProvider).text,
      description: ref.read(shopDescriptionControllerProvider).text,
      items: {
        'title': ref.read(shopItemTitleControllerProvider).text,
        'price': ref.read(shopItemPriceControllerProvider).text,
        'description': ref.read(shopItemDescriptionControllerProvider).text,
      },
      allowAdditionalDonation: ref.read(shopAllowAdditionalDonationProvider),
      purchaserInfo: ref.read(shopPurchaserInfoProvider),
      themeColor: ref.read(shopThemeColorProvider) ?? '#6200EE',
      shopLogoUrl: ref.read(shopLogoUrlProvider) ?? '',
      bannerUrl: ref.read(shopBannerUrlProvider) ?? '',
      bannerMediaType: ref.read(shopBannerMediaTypeProvider) ?? 'Image',
      emailSubject: ref.read(shopEmailSubjectControllerProvider).text,
      emailBody: ref.read(onlineShopEmailDescriptionQuillController).document.toPlainText(),
      emailToNotify: ref.read(shopEmailToNotifyControllerProvider).text,
      memoryOptionEnabled: ref.read(shopMemoryOptionEnabledProvider),
      suggestCheckOption: ref.read(shopSuggestCheckOptionProvider),
      shareableLink: '',
      status: 'active',
    );

    await ref.read(firestoreServiceProvider).addOnlineShopForm(newShopForm);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Shop form created!")));
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
          "Create Online Shop Form",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stepper(
        steps: [
          Step(
            title: const Text("General"),
            content: const ShopFormGeneral(),
            isActive: currentStep == 0,
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text("Customization"),
            content: const ShopFormCustomization(),
            isActive: currentStep == 1,
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text("Advanced"),
            content: const ShopFormAdvanced(),
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
            if (!ShopFormGeneral.formKey.currentState!.validate()) return;
          }

          if (currentStep != 2) {
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
                  child: const Text("Continue"),
                ),
              if (currentStep == 2)
                ElevatedButton(
                  onPressed: () async {
                    await publishOnlineShopForm();
                  },
                  child: const Text("Publish"),
                ),
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
