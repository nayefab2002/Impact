import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impact/screens/forms/models/base_form.dart';

class DonationForm implements BaseForm {
  late final String title;
  late final String language;
  late final bool isGenerateTaxReceipt;
  late final bool toAddThermometer;
  late final List<dynamic> description;
  late final String themeColor;
  late final String eventLogoUrl;
  late final String bannerUrl;
  late final Map<String, bool> suggestedDonationAmount;
  late final Map<String, bool> donorQuestions;
  late final String emailSubject;
  late final String emailBody;
  late final String emailToNotify;
  @override
  late final String id;
  @override
  late final String ownerId;
  @override
  late final DateTime createdTime;
  @override
  late final String status;
  @override
  final String formType = "donation";
  @override
  late final String shareableLink;

  DonationForm({
    required this.id,
    required this.ownerId,
    required this.createdTime,
    required this.title,
    required this.language,
    required this.description,
    required this.themeColor,
    required this.eventLogoUrl,
    required this.suggestedDonationAmount,
    required this.donorQuestions,
    required this.shareableLink,
    required this.status,
    required this.emailBody,
    required this.emailSubject,
    this.isGenerateTaxReceipt = false,
    this.bannerUrl = "",
    this.toAddThermometer = false,
    this.emailToNotify = "",
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'language': language,
      'isGenerateTaxReceipt': isGenerateTaxReceipt,
      'toAddThermometer': toAddThermometer,
      'description': description,
      'themeColor': themeColor,
      'eventLogoUrl': eventLogoUrl,
      'bannerUrl': bannerUrl,
      'donorQuestions': donorQuestions,
      'suggestedDonationAmount': suggestedDonationAmount,
      'ownerId': ownerId,
      'createdTime': Timestamp.fromDate(createdTime),
      'status': status,
      'shareableLink': shareableLink,
      'formType': formType,
      'emailSubject': emailSubject,
      'emailBody': emailBody,
      'emailAddress': emailToNotify,
    };
  }

  factory DonationForm.fromFirestore(dynamic snapshot) {
    final data = snapshot!.data();
    return DonationForm(
      id: snapshot.id,
      // Use snapshot.id instead of data["id"]
      ownerId: data?["ownerId"] ?? "",
      createdTime:
          (data?["createdTime"] as Timestamp?)?.toDate() ?? DateTime.now(),
      title: data?["title"] ?? "",
      language: data?["language"] ?? "",
      description:
          data?["description"] is List
              ? List<dynamic>.from(data!["description"])
              : [],
      themeColor: data?["themeColor"] ?? "#6200EE",
      eventLogoUrl: data?["eventLogoUrl"] ?? "",
      bannerUrl: data?["bannerUrl"] ?? "",
      donorQuestions:
          data?["donorQuestions"] is Map
              ? Map<String, bool>.from(data!["donorQuestions"])
              : {
                'email': true,
                'firstName': true,
                'lastName': true,
                'state': true,
                'country': true,
                'address': true,
              },
      suggestedDonationAmount:
          data?["suggestedDonationAmount"] is Map
              ? Map<String, bool>.from(data!["suggestedDonationAmount"])
              : {
                "lessThan100": false,
                "between100_300": false,
                "moreThan300": false,
              },
      shareableLink:
          data?["shareableLink"] ??
          "https://impact.web.app/donations/${snapshot.id}",
      status: data?["status"] ?? "draft",
      emailBody:data?['emailBody']??"",
      emailSubject: data?["emailSubject"] ?? "",
      emailToNotify: data?["emailAddress"] ?? "",
      isGenerateTaxReceipt: data?["isGenerateTaxReceipt"] ?? false,
      toAddThermometer: data?["toAddThermometer"] ?? false,
    );
  }

  DonationForm copyWith({
    String? id,
    String? title,
    String? dateTime,
    String? language,
    List<Map<String, dynamic>>? description,
    String? themeColor,
    String? eventLogoUrl,
    String? bannerUrl,
    Map<String, bool>? suggestedDonationAmount,
    Map<String, bool>? donorQuestions,
    String? emailSubject,
    String? emailBody,
    String? ownerId,
    DateTime? createdTime,
    String? status,
    String? shareableLink,
    bool? isGenerateTaxReceipt,
    bool? toAddThermometer,
    String? emailToNotify

  }) {
    return DonationForm(
      id: id ?? this.id,
      title: title ?? this.title,
      language: language ?? this.language,
      description: description ?? this.description,
      themeColor: themeColor ?? this.themeColor,
      eventLogoUrl: eventLogoUrl ?? this.eventLogoUrl,
      ownerId: ownerId ?? this.ownerId,
      createdTime: createdTime ?? this.createdTime,
      status: status ?? this.status,
      shareableLink: shareableLink ?? this.shareableLink,
      suggestedDonationAmount:
          suggestedDonationAmount ?? this.suggestedDonationAmount,
      donorQuestions: donorQuestions ?? this.donorQuestions,
      emailBody: emailBody ?? this.emailBody,
      emailSubject: emailSubject ?? this.emailSubject,
      emailToNotify: emailToNotify??this.emailToNotify,
      isGenerateTaxReceipt: isGenerateTaxReceipt??this.isGenerateTaxReceipt,
      toAddThermometer: toAddThermometer??this.toAddThermometer,

    );
  }
}
