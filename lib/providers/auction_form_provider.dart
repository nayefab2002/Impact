import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Basic form fields
final auctionFormTitleProvider = StateProvider<String>((ref) => "");
final auctionDescriptionProvider = StateProvider<String>((ref) => "");

// Date and time fields
final auctionStartDateTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());
final auctionEndDateTimeProvider = StateProvider<DateTime>((ref) => DateTime.now().add(const Duration(days: 1)));

// Bid settings
final auctionStartingBidProvider = StateProvider<double>((ref) => 0.0);
final auctionEnableBidIncrementsProvider = StateProvider<bool>((ref) => false);
final auctionBidIncrementProvider = StateProvider<double>((ref) => 1.0);

// Styling
final auctionThemeColorProvider = StateProvider<String>((ref) => "");

// Additional options
final auctionEnableNotificationsProvider = StateProvider<bool>((ref) => true);
final auctionRequireApprovalProvider = StateProvider<bool>((ref) => false);
final auctionAllowDiscountCodesProvider = StateProvider<bool>((ref) => false);
final auctionNotificationEmailProvider = StateProvider<String>((ref) => "");

// Metadata
final auctionFormIdProvider = StateProvider<String>((ref) => "");
final auctionOwnerIdProvider = StateProvider<String>((ref) => "");
final auctionCreatedTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());
final auctionStatusProvider = StateProvider<String>((ref) => "");
final auctionShareableLinkProvider = StateProvider<String>((ref) => "");

// Controllers for form inputs
final auctionTitleControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final auctionDescriptionControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final auctionStartingBidControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final auctionBidIncrementControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final auctionNotificationEmailControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});

// Date controllers (for UI)
final auctionStartDateControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final auctionEndDateControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final auctionStartTimeControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final auctionEndTimeControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});