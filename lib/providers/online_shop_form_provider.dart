import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Basic shop information
final shopFormTitleProvider = StateProvider<String>((ref) => "");
final shopDescriptionProvider = StateProvider<String>((ref) => "");

// Shop items (product ID -> product details)
final shopItemsProvider = StateProvider<Map<String, String>>((ref) => {});

// Configuration options
final shopAllowAdditionalDonationProvider = StateProvider<bool>((ref) => false);
final shopMemoryOptionEnabledProvider = StateProvider<bool>((ref) => false);
final shopSuggestCheckOptionProvider = StateProvider<bool>((ref) => false);

// Purchaser information collection
final shopPurchaserInfoProvider = StateProvider<Map<String, bool>>((ref) {
  return {
    'name': true,
    'email': true,
    'phone': false,
    'address': false,
    'message': false,
  };
});

// Styling and media
final shopThemeColorProvider = StateProvider<String>((ref) => "");
final shopLogoUrlProvider = StateProvider<String>((ref) => "");
final shopBannerUrlProvider = StateProvider<String>((ref) => "");
final shopBannerMediaTypeProvider = StateProvider<String>((ref) => "Image");

// Email settings
final shopEmailSubjectProvider = StateProvider<String>((ref) => "");
final shopEmailBodyProvider = StateProvider<String>((ref) => "");
final shopEmailToNotifyProvider = StateProvider<String>((ref) => "");

// Metadata
final shopFormIdProvider = StateProvider<String>((ref) => "");
final shopOwnerIdProvider = StateProvider<String>((ref) => "");
final shopCreatedTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());
final shopStatusProvider = StateProvider<String>((ref) => "");
final shopShareableLinkProvider = StateProvider<String>((ref) => "");

// Controllers for form inputs
final shopTitleControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final shopDescriptionControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});

final shopItemTitleControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final shopItemDescriptionControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final shopItemPriceControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final shopEmailSubjectControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final shopEmailBodyControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final shopEmailToNotifyControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final onlineShopEmailDescriptionQuillController = StateProvider<QuillController>((ref) {
  return QuillController.basic();
});
// For managing items (additional providers for item management)
final shopCurrentItemIdProvider = StateProvider<String>((ref) => "");
final shopCurrentItemNameProvider = StateProvider<String>((ref) => "");
final shopCurrentItemPriceProvider = StateProvider<String>((ref) => "");
final shopCurrentItemDescriptionProvider = StateProvider<String>((ref) => "");