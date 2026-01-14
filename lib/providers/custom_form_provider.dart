import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Basic form information
final customFormTitleProvider = StateProvider<String>((ref) => "");
final customFormLanguageProvider = StateProvider<String>((ref) => "en");

// Rich content
final customFormDescriptionProvider = StateProvider<List<dynamic>>((ref) {
  return QuillController.basic().document.toDelta().toJson();
});
final customFormWelcomeMessageProvider = StateProvider<String>((ref) => "");

// Styling
final customFormThemeColorProvider = StateProvider<String>((ref) => "#3B82F6"); // Default blue-500
final customFormLogoUrlProvider = StateProvider<String>((ref) => "");

// Form behavior options
final customFormShowProgressBarProvider = StateProvider<bool>((ref) => true);
final customFormEnableRecurringDonationsProvider = StateProvider<bool>((ref) => false);
final customFormAllowDonorCommentsProvider = StateProvider<bool>((ref) => false);
final customFormAskToCoverFeesProvider = StateProvider<bool>((ref) => true);

// Email settings
final customFormEmailReceiptMessageProvider = StateProvider<String>((ref) => "");

// Metadata
final customFormIdProvider = StateProvider<String>((ref) => "");
final customFormOwnerIdProvider = StateProvider<String>((ref) => "");
final customFormCreatedTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());
final customFormStatusProvider = StateProvider<String>((ref) => "draft");
final customFormShareableLinkProvider = StateProvider<String>((ref) => "");

// Controllers
final customFormTitleControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final customFormDescriptionControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final customFormWelcomeMessageControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final customFormEmailReceiptMessageControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});

// Quill controller for rich text editing
final customFormDescriptionQuillController = StateProvider<QuillController>((ref) {
  return QuillController.basic();
});

// Theme color picker helper
final customFormThemeColorValueProvider = Provider<Color>((ref) {
  final hexColor = ref.watch(customFormThemeColorProvider);
  return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
});