import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventFormTitleProvider = StateProvider<String>((ref) {
  return "";
});
final eventFormDateTimeProvider = StateProvider<String>((ref) {
  return "";
});
final eventFormAddressProvider = StateProvider<String>((ref) {
  return "";
});

final eventDescriptionProvider = StateProvider<List<dynamic>>((ref) {
  return QuillController.basic().document.toDelta().toJson();
});

final eventThemeColorProvider = StateProvider<String>((ref) {
  return "";
});
final eventLogoUrlProvider = StateProvider<String>((ref) {
  return "";
});
final eventTicketOptionsProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {"type": "General", "price": 0.0, "description": ""};
});
final attendeeInfoCollectionProvider = StateProvider<Map<String, bool>>((ref) {
  return {'email': true, 'fullName': true, 'phoneNumber': false};
});

final eventFormIdProvider = StateProvider<String>((ref) {
  return "";
});

final eventCreatedTimeProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});
final eventStatusProvider = StateProvider<String>((ref) {
  return "";
});
final eventShareableLinkProvider = StateProvider<String>((ref) {
  return "";
});


final titleControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final addressControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final descriptionQuillController=StateProvider<QuillController>((ref){
  return QuillController.basic();
});



