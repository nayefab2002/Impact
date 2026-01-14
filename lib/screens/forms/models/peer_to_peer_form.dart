import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impact/screens/forms/models/base_form.dart';

class PeerToPeerForm implements BaseForm {
  late final String title;
  late final String language;
  late final bool generateTaxReceipt;
  late final double goalAmount;
  late final List<dynamic> description;
  late final List<dynamic> fundraiserMessage;
  late final Map<String, List<double>> suggestedAmounts; // Key: 'One-Time', 'Monthly', 'Yearly'
  late final String themeColor;
  late final String logoUrl;
  late final String bannerUrl;
  // late final String bannerMediaType; // 'Image' or 'Video'
  // late final String youtubeUrl;
  late final Map<String, bool> donorQuestions;
  late final String emailSubject;
  late final String emailBody;
  late final bool addSalesTarget;
  late final bool suggestCheckPayment;
  late final bool addDiscountCodes;
  late final String notificationEmails;

  @override
  late final String id;
  @override
  late final String ownerId;
  @override
  late final DateTime createdTime;
  @override
  late final String status;
  @override
  final String formType = "peer_to_peer";
  @override
  late final String shareableLink;

  PeerToPeerForm({
    required this.id,
    required this.ownerId,
    required this.createdTime,
    required this.title,
    required this.language,
    required this.generateTaxReceipt,
    required this.goalAmount,
    required this.description,
    required this.fundraiserMessage,
    required this.suggestedAmounts,
    required this.themeColor,
    required this.logoUrl,
    required this.bannerUrl,
    // required this.bannerMediaType,
    // required this.youtubeUrl,
    required this.donorQuestions,
    required this.emailSubject,
    required this.emailBody,
    required this.shareableLink,
    required this.status,
    this.addSalesTarget = false,
    this.suggestCheckPayment = false,
    this.addDiscountCodes = false,
    this.notificationEmails = "",
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'language': language,
      'generateTaxReceipt': generateTaxReceipt,
      'goalAmount': goalAmount,
      'description': description,
      'fundraiserMessage': fundraiserMessage,
      'suggestedAmounts': suggestedAmounts,
      'themeColor': themeColor,
      'logoUrl': logoUrl,
      'bannerUrl': bannerUrl,
      // 'bannerMediaType': bannerMediaType,
      // 'youtubeUrl': youtubeUrl,
      'donorQuestions': donorQuestions,
      'emailSubject': emailSubject,
      'emailBody': emailBody,
      'addSalesTarget': addSalesTarget,
      'suggestCheckPayment': suggestCheckPayment,
      'addDiscountCodes': addDiscountCodes,
      'notificationEmails': notificationEmails,
      'ownerId': ownerId,
      'createdTime': Timestamp.fromDate(createdTime),
      'status': status,
      'shareableLink': shareableLink,
      'formType': formType,
    };
  }

  factory PeerToPeerForm.fromFirestore(dynamic snapshot) {
    final data = snapshot!.data();
    return PeerToPeerForm(
      id: snapshot.id,
      ownerId: data?["ownerId"] ?? "",
      createdTime: (data?["createdTime"] as Timestamp?)?.toDate() ?? DateTime.now(),
      title: data?["title"] ?? "",
      language: data?["language"] ?? "En",
      generateTaxReceipt: data?["generateTaxReceipt"] ?? true,
      goalAmount: (data?["goalAmount"] as num?)?.toDouble() ?? 0.0,
      description: data?["description"] is List
          ? List<dynamic>.from(data!["description"])
          : [],
      fundraiserMessage: data?["fundraiserMessage"] is List
          ? List<dynamic>.from(data!["fundraiserMessage"])
          : [],
      suggestedAmounts: data?["suggestedAmounts"] is Map
          ? Map<String, List<double>>.from(
          (data!["suggestedAmounts"] as Map).map(
                  (k, v) => MapEntry(k, List<double>.from(v))
          )
      )
          : {
        'One-Time': [25.0, 50.0, 100.0, 250.0],
        'Monthly': [10.0, 25.0, 50.0, 100.0],
        'Yearly': [100.0, 250.0, 500.0, 1000.0],
      },
      themeColor: data?["themeColor"] ?? "#6200EE",
      logoUrl: data?["logoUrl"] ?? "",
      bannerUrl: data?["bannerUrl"] ?? "",
      // bannerMediaType: data?["bannerMediaType"] ?? "Image",
      // youtubeUrl: data?["youtubeUrl"] ?? "",
      donorQuestions: data?["donorQuestions"] is Map
          ? Map<String, bool>.from(data!["donorQuestions"])
          : {
        'Email': true,
        'First Name': false,
        'Last Name': false,
        'Address': false,
        'State': false,
        'Country': false,
      },
      emailSubject: data?["emailSubject"] ?? "Thank you for your donation",
      emailBody: data?["emailBody"] ?? "",
      addSalesTarget: data?["addSalesTarget"] ?? false,
      suggestCheckPayment: data?["suggestCheckPayment"] ?? false,
      addDiscountCodes: data?["addDiscountCodes"] ?? false,
      notificationEmails: data?["notificationEmails"] ?? "",
      shareableLink: data?["shareableLink"] ?? "https://impact.web.app/peer-to-peer/${snapshot.id}",
      status: data?["status"] ?? "draft",
    );
  }

  PeerToPeerForm copyWith({
    String? id,
    String? title,
    String? language,
    bool? generateTaxReceipt,
    double? goalAmount,
    List<dynamic>? description,
    List<dynamic>? fundraiserMessage,
    Map<String, List<double>>? suggestedAmounts,
    String? themeColor,
    String? logoUrl,
    String? bannerUrl,
    // String? bannerMediaType,
    // String? youtubeUrl,
    Map<String, bool>? donorQuestions,
    String? emailSubject,
    String? emailBody,
    bool? addSalesTarget,
    bool? suggestCheckPayment,
    bool? addDiscountCodes,
    String? notificationEmails,
    String? ownerId,
    DateTime? createdTime,
    String? status,
    String? shareableLink,
  }) {
    return PeerToPeerForm(
      id: id ?? this.id,
      title: title ?? this.title,
      language: language ?? this.language,
      generateTaxReceipt: generateTaxReceipt ?? this.generateTaxReceipt,
      goalAmount: goalAmount ?? this.goalAmount,
      description: description ?? this.description,
      fundraiserMessage: fundraiserMessage ?? this.fundraiserMessage,
      suggestedAmounts: suggestedAmounts ?? this.suggestedAmounts,
      themeColor: themeColor ?? this.themeColor,
      logoUrl: logoUrl ?? this.logoUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      // bannerMediaType: bannerMediaType ?? this.bannerMediaType,
      // youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      donorQuestions: donorQuestions ?? this.donorQuestions,
      emailSubject: emailSubject ?? this.emailSubject,
      emailBody: emailBody ?? this.emailBody,
      addSalesTarget: addSalesTarget ?? this.addSalesTarget,
      suggestCheckPayment: suggestCheckPayment ?? this.suggestCheckPayment,
      addDiscountCodes: addDiscountCodes ?? this.addDiscountCodes,
      notificationEmails: notificationEmails ?? this.notificationEmails,
      ownerId: ownerId ?? this.ownerId,
      createdTime: createdTime ?? this.createdTime,
      status: status ?? this.status,
      shareableLink: shareableLink ?? this.shareableLink,
    );
  }
}