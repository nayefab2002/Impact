import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Basic form information
final membershipFormTitleProvider = StateProvider<String>((ref) => "");
final membershipFormLanguageProvider = StateProvider<String>((ref) => "en");

// Rich content
final membershipFormDescriptionProvider = StateProvider<List<dynamic>>((ref) {
  return QuillController.basic().document.toDelta().toJson();
});

// Membership levels
final membershipLevelsProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);

// Form configuration options
final membershipAllowDonationProvider = StateProvider<bool>((ref) => true);
final membershipRequireAddressProvider = StateProvider<bool>((ref) => false);
final membershipEmailNotificationProvider = StateProvider<bool>((ref) => true);
final membershipShowGoalProvider = StateProvider<bool>((ref) => false);
final membershipShowProgressProvider = StateProvider<bool>((ref) => false);
final membershipAllowCommentsProvider = StateProvider<bool>((ref) => false);
final membershipEnableReceiptProvider = StateProvider<bool>((ref) => false);
final membershipEnableRemindersProvider = StateProvider<bool>((ref) => false);
final membershipAllowOfflineProvider = StateProvider<bool>((ref) => false);

// Metadata
final membershipFormIdProvider = StateProvider<String>((ref) => "");
final membershipOwnerIdProvider = StateProvider<String>((ref) => "");
final membershipCreatedTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());
final membershipStatusProvider = StateProvider<String>((ref) => "draft");
final membershipShareableLinkProvider = StateProvider<String>((ref) => "");

// Controllers
final membershipTitleControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});

// Quill controller
final membershipDescriptionQuillController = StateProvider<QuillController>((ref) {
  return QuillController.basic();
});

// Current membership level being edited
final currentMembershipLevelProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'name': '',
    'price': 0.0,
    'description': '',
    'duration': 1,
    'durationUnit': 'year', // 'month' or 'year'
    'features': [],
  };
});

// Controllers for membership level editing
final membershipLevelNameController = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final membershipLevelPriceController = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final membershipLevelDescriptionController = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final membershipLevelDurationController = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});