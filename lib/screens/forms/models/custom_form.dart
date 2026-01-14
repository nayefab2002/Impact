import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impact/screens/forms/models/base_form.dart';

class CustomForm implements BaseForm {
  late final String title;
  late final String language;
  late final String description;
  late final String themeColor;
  late final String formLogoUrl;
  late final String welcomeMessage;
  late final bool showProgressBar;
  late final bool enableRecurringDonations;
  late final bool allowDonorComments;
  late final bool askToCoverFees;
  late final String emailReceiptMessage;
  @override
  late final String id;
  @override
  late final String ownerId;
  @override
  late final DateTime createdTime;
  @override
  late final String status;
  @override
  final String formType = "custom";
  @override
  late final String shareableLink;

  CustomForm({
    required this.id,
    required this.ownerId,
    required this.createdTime,
    required this.title,
    required this.language,
    required this.description,
    required this.themeColor,
    required this.formLogoUrl,
    required this.welcomeMessage,
    required this.showProgressBar,
    required this.enableRecurringDonations,
    required this.allowDonorComments,
    required this.askToCoverFees,
    required this.emailReceiptMessage,
    required this.shareableLink,
    required this.status,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'language': language,
      'description': description,
      'themeColor': themeColor,
      'formLogoUrl': formLogoUrl,
      'welcomeMessage': welcomeMessage,
      'showProgressBar': showProgressBar,
      'enableRecurringDonations': enableRecurringDonations,
      'allowDonorComments': allowDonorComments,
      'askToCoverFees': askToCoverFees,
      'emailReceiptMessage': emailReceiptMessage,
      'ownerId': ownerId,
      'createdTime': Timestamp.fromDate(createdTime),
      'status': status,
      'shareableLink': shareableLink,
      'formType': formType,
    };
  }

  factory CustomForm.fromFirestore(dynamic snapshot) {
    final data = snapshot!.data();
    return CustomForm(
      id: snapshot.id,
      ownerId: data?["ownerId"] ?? "",
      createdTime: (data?["createdTime"] as Timestamp?)?.toDate() ?? DateTime.now(),
      title: data?["title"] ?? "",
      language: data?["language"] ?? "En",
      description:data?["description"]??"",
      themeColor: data?["themeColor"] ?? "#6200EE",
      formLogoUrl: data?["formLogoUrl"] ?? "",
      welcomeMessage: data?["welcomeMessage"] ?? "",
      showProgressBar: data?["showProgressBar"] ?? false,
      enableRecurringDonations: data?["enableRecurringDonations"] ?? false,
      allowDonorComments: data?["allowDonorComments"] ?? false,
      askToCoverFees: data?["askToCoverFees"] ?? false,
      emailReceiptMessage: data?["emailReceiptMessage"] ?? "",
      shareableLink: data?["shareableLink"] ?? "https://impact.web.app/custom/${snapshot.id}",
      status: data?["status"] ?? "draft",
    );
  }

  CustomForm copyWith({
    String? id,
    String? title,
    String? language,
    String? description,
    String? themeColor,
    String? formLogoUrl,
    String? welcomeMessage,
    bool? showProgressBar,
    bool? enableRecurringDonations,
    bool? allowDonorComments,
    bool? askToCoverFees,
    String? emailReceiptMessage,
    String? ownerId,
    DateTime? createdTime,
    String? status,
    String? shareableLink,
  }) {
    return CustomForm(
      id: id ?? this.id,
      title: title ?? this.title,
      language: language ?? this.language,
      description: description ?? this.description,
      themeColor: themeColor ?? this.themeColor,
      formLogoUrl: formLogoUrl ?? this.formLogoUrl,
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      showProgressBar: showProgressBar ?? this.showProgressBar,
      enableRecurringDonations: enableRecurringDonations ?? this.enableRecurringDonations,
      allowDonorComments: allowDonorComments ?? this.allowDonorComments,
      askToCoverFees: askToCoverFees ?? this.askToCoverFees,
      emailReceiptMessage: emailReceiptMessage ?? this.emailReceiptMessage,
      ownerId: ownerId ?? this.ownerId,
      createdTime: createdTime ?? this.createdTime,
      status: status ?? this.status,
      shareableLink: shareableLink ?? this.shareableLink,
    );
  }
}