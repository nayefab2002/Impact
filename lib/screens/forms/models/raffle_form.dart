import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impact/screens/forms/models/base_form.dart';

class RaffleForm implements BaseForm {
  late final String title;
  late final String language;
  late final List<dynamic> description;
  late final List<DateTime> raffleDates;
  late final String themeColor;
  late final String logoUrl;
  late final String bannerUrl;
  late final Map<String, dynamic> ticketOptions;
  late final bool salesTarget;
  late final bool suggestCheckPayment;
  late final bool enableDiscountCodes;
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
  final String formType = "raffle";
  @override
  late final String shareableLink;

  RaffleForm({
    required this.id,
    required this.ownerId,
    required this.createdTime,
    required this.title,
    required this.language,
    required this.description,
    required this.raffleDates,
    required this.themeColor,
    required this.logoUrl,
    required this.bannerUrl,
    required this.ticketOptions,
    required this.shareableLink,
    required this.status,
    this.salesTarget = false,
    this.suggestCheckPayment = false,
    this.enableDiscountCodes = false,
    this.notificationEmails = "",
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'language': language,
      'description': description,
      'raffleDates': raffleDates.map((date) => Timestamp.fromDate(date)).toList(),
      'themeColor': themeColor,
      'logoUrl': logoUrl,
      'bannerUrl': bannerUrl,
      'ticketOptions': ticketOptions,
      'collectDonation': salesTarget,
      'suggestCheckPayment': suggestCheckPayment,
      'enableDiscountCodes': enableDiscountCodes,
      'notificationEmails': notificationEmails,
      'ownerId': ownerId,
      'createdTime': Timestamp.fromDate(createdTime),
      'status': status,
      'shareableLink': shareableLink,
      'formType': formType,
    };
  }

  factory RaffleForm.fromFirestore(dynamic snapshot) {
    final data = snapshot!.data();
    return RaffleForm(
      id: snapshot.id,
      ownerId: data?["ownerId"] ?? "",
      createdTime: (data?["createdTime"] as Timestamp?)?.toDate() ?? DateTime.now(),
      title: data?["title"] ?? "",
      language: data?["language"] ?? "En",
      description: data?["description"] is List
          ? List<dynamic>.from(data!["description"])
          : [],
      raffleDates: data?["raffleDates"] is List
          ? (data!["raffleDates"] as List).map((t) => (t as Timestamp).toDate()).toList()
          : [],
      themeColor: data?["themeColor"] ?? "#6200EE",
      logoUrl: data?["logoUrl"] ?? "",
      bannerUrl: data?["bannerUrl"] ?? "",
      ticketOptions: data?["ticketOptions"] is Map
          ? Map<String, dynamic>.from(data!["ticketOptions"])
          :  {"title": "General", "price": 0.0, "description": ""},
      salesTarget: data?["collectDonation"] ?? false,
      suggestCheckPayment: data?["suggestCheckPayment"] ?? false,
      enableDiscountCodes: data?["enableDiscountCodes"] ?? false,
      notificationEmails: data?["notificationEmails"] ?? "",
      shareableLink: data?["shareableLink"] ?? "https://impact.web.app/raffle/${snapshot.id}",
      status: data?["status"] ?? "draft",
    );
  }

  RaffleForm copyWith({
    String? id,
    String? title,
    String? language,
    List<dynamic>? description,
    List<DateTime>? raffleDates,
    String? themeColor,
    String? logoUrl,
    String? bannerUrl,
    Map<String, dynamic>? ticketOptions,
    bool? collectDonation,
    bool? suggestCheckPayment,
    bool? enableDiscountCodes,
    String? notificationEmails,
    String? ownerId,
    DateTime? createdTime,
    String? status,
    String? shareableLink,
  }) {
    return RaffleForm(
      id: id ?? this.id,
      title: title ?? this.title,
      language: language ?? this.language,
      description: description ?? this.description,
      raffleDates: raffleDates ?? this.raffleDates,
      themeColor: themeColor ?? this.themeColor,
      logoUrl: logoUrl ?? this.logoUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      ticketOptions: ticketOptions ?? this.ticketOptions,
      salesTarget: collectDonation ?? this.salesTarget,
      suggestCheckPayment: suggestCheckPayment ?? this.suggestCheckPayment,
      enableDiscountCodes: enableDiscountCodes ?? this.enableDiscountCodes,
      notificationEmails: notificationEmails ?? this.notificationEmails,
      ownerId: ownerId ?? this.ownerId,
      createdTime: createdTime ?? this.createdTime,
      status: status ?? this.status,
      shareableLink: shareableLink ?? this.shareableLink,
    );
  }
}