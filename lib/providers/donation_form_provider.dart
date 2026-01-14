import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final donationFormTitleProvider = StateProvider<String>((ref) {
  return "";
});
final donationFormDateTimeProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});
final donationFormLanguageProvider = StateProvider<String>((ref) {
  return "En";
});

final donationDescriptionProvider = StateProvider<List<dynamic>>((ref) {
  return QuillController.basic().document.toDelta().toJson();
});

final donationThemeColorProvider = StateProvider<String>((ref) {
  return "";
});
final donationLogoUrlProvider = StateProvider<String>((ref) {
  return "";
});
final donationBannerUrlProvider = StateProvider<String>((ref) {
  return "";
});
final donationSuggestedDonationAmountProvider = StateProvider<Map<String, bool>>((ref) {
  return {
    "lessThan100": false,
    "between100_300": false,
    "moreThan300": false,
  };
});
final donationDonorQuestionsProvider = StateProvider<Map<String, bool>>((ref) {
  return  {
    'email': true,
    'firstName': true,
    'lastName': true,
    'state': true,
    'country': true,
    'address': true,
  };
});

final donationFormIdProvider = StateProvider<String>((ref) {
  return "";
});

final donationCreatedTimeProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});
final donationStatusProvider = StateProvider<String>((ref) {
  return "";
});
final donationShareableLinkProvider = StateProvider<String>((ref) {
  return "";
});


final donationTitleControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final donationDescriptionQuillController=StateProvider<QuillController>((ref){
  return QuillController.basic();
});
final emailBodyQuillController=StateProvider<QuillController>((ref){
  return QuillController.basic();
});
final emailSubjectProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final emailAddressController = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final toGenerateTaxReceiptProvider = StateProvider<bool>((ref) {
  return true;
});

final toAddThermometerProvider = StateProvider<bool>((ref) {
  return false;
});

final donationLogoBytesProvider = StateProvider<Uint8List?>((ref) {
   return null;
});

final donationBannerBytesProvider = StateProvider<Uint8List?>((ref) {
  return null;
});


