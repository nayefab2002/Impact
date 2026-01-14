import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Basic form fields
final peerToPeerFormTitleProvider = StateProvider<String>((ref) => "");
final peerToPeerFormLanguageProvider = StateProvider<String>((ref) => "en");
final peerToPeerGenerateTaxReceiptProvider = StateProvider<bool>((ref) => false);
final peerToPeerGoalAmountProvider = StateProvider<double>((ref) => 0.0);

// Rich text descriptions
final peerToPeerDescriptionProvider = StateProvider<List<dynamic>>((ref) {
  return QuillController.basic().document.toDelta().toJson();
});
final peerToPeerFundraiserMessageProvider = StateProvider<List<dynamic>>((ref) {
  return QuillController.basic().document.toDelta().toJson();
});

// Suggested amounts
final peerToPeerSuggestedAmountsProvider = StateProvider<Map<String, List<double>>>((ref) {
  return {
    'One-Time': [],
    'Monthly': [],
    'Yearly': [],
  };
});

// Styling
final peerToPeerThemeColorProvider = StateProvider<String>((ref) => "");
final peerToPeerLogoUrlProvider = StateProvider<String>((ref) => "");
final peerToPeerBannerUrlProvider = StateProvider<String>((ref) => "");

// Donor questions
final peerToPeerDonorQuestionsProvider = StateProvider<Map<String, bool>>((ref) {
  return {
    'Email': true,
    'First Name': false,
    'Last Name': false,
    'Address': false,
    'State': false,
    'Country': false,
  };
});

// Email settings
final peerToPeerEmailSubjectProvider = StateProvider<String>((ref) => "");
final peerToPeerEmailBodyProvider = StateProvider<String>((ref) => "");

// Additional options
final peerToPeerAddSalesTargetProvider = StateProvider<bool>((ref) => false);
final peerToPeerSuggestCheckPaymentProvider = StateProvider<bool>((ref) => false);
final peerToPeerAddDiscountCodesProvider = StateProvider<bool>((ref) => false);
final peerToPeerNotificationEmailsProvider = StateProvider<String>((ref) => "");

// Metadata
final peerToPeerFormIdProvider = StateProvider<String>((ref) => "");
final peerToPeerOwnerIdProvider = StateProvider<String>((ref) => "");
final peerToPeerCreatedTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());
final peerToPeerStatusProvider = StateProvider<String>((ref) => "");
final peerToPeerShareableLinkProvider = StateProvider<String>((ref) => "");

// Controllers for form inputs
final peerToPeerTitleControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final peerToPeerGoalAmountControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final peerToPeerEmailSubjectControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final peerToPeerEmailBodyControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final peerToPeerNotificationEmailsControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});

// Quill controllers
final peerToPeerDescriptionQuillController = StateProvider<QuillController>((ref) {
  return QuillController.basic();
});
final peerToPeerFundraiserMessageQuillController = StateProvider<QuillController>((ref) {
  return QuillController.basic();
});

final peerToPeerEmailQuillProvider = StateProvider<QuillController>((ref) {
  return QuillController.basic();
});
