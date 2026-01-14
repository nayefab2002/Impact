import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Basic form fields
final raffleFormTitleProvider = StateProvider<String>((ref) => "");
final raffleFormLanguageProvider = StateProvider<String>((ref) => "en");

// Rich text description
final raffleDescriptionProvider = StateProvider<List<dynamic>>((ref) {
  return QuillController.basic().document.toDelta().toJson();
});

// Raffle dates (initialized with empty list)
final raffleDatesProvider = StateProvider<List<DateTime>>((ref) => []);

// Styling
final raffleThemeColorProvider = StateProvider<String>((ref) => "");
final raffleLogoUrlProvider = StateProvider<String>((ref) => "");
final raffleBannerUrlProvider = StateProvider<String>((ref) => "");

// Ticket options
final raffleTicketOptionsProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {"title": "General", "price": 0.0, "description": ""};
});

// Additional options
final raffleSalesTargetProvider = StateProvider<bool>((ref) => false);
final raffleSuggestCheckPaymentProvider = StateProvider<bool>((ref) => false);
final raffleEnableDiscountCodesProvider = StateProvider<bool>((ref) => false);
final raffleNotificationEmailsProvider = StateProvider<String>((ref) => "");

// Metadata
final raffleFormIdProvider = StateProvider<String>((ref) => "");
final raffleOwnerIdProvider = StateProvider<String>((ref) => "");
final raffleCreatedTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());
final raffleStatusProvider = StateProvider<String>((ref) => "");
final raffleShareableLinkProvider = StateProvider<String>((ref) => "");

// Controllers for form inputs
final raffleTitleControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final raffleNotificationEmailsControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});

// Ticket option controllers
final raffleTicketPriceControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final raffleTicketQuantityControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final raffleTicketDescriptionControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final raffleTicketMinPerOrderControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final raffleTicketMaxPerOrderControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});

// Quill controller for description
final raffleDescriptionQuillController = StateProvider<QuillController>((ref) {
  return QuillController.basic();
});

// Date controllers (if needed for UI)
final raffleStartDateControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final raffleEndDateControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});