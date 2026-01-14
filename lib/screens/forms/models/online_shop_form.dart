import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impact/screens/forms/models/base_form.dart';

class ShopForm implements BaseForm {
  late final String title;
  late final String description;
  late final Map<String, String> items;
  late final bool allowAdditionalDonation;
  late final Map<String, bool> purchaserInfo;
  late final String themeColor;
  late final String shopLogoUrl;
  late final String bannerUrl;
  late final String bannerMediaType; // 'Image' or 'Video'
  late final String emailSubject;
  late final String emailBody;
  late final String emailToNotify;
  late final bool memoryOptionEnabled;
  late final bool suggestCheckOption;

  @override
  late final String id;
  @override
  late final String ownerId;
  @override
  late final DateTime createdTime;
  @override
  late final String status;
  @override
  final String formType = "shop";
  @override
  late final String shareableLink;

  ShopForm({
    required this.id,
    required this.ownerId,
    required this.createdTime,
    required this.title,
    required this.description,
    required this.items,
    required this.allowAdditionalDonation,
    required this.purchaserInfo,
    required this.themeColor,
    required this.shopLogoUrl,
    required this.bannerUrl,
    required this.bannerMediaType,
    required this.shareableLink,
    required this.status,
    required this.emailSubject,
    required this.emailBody,
    this.emailToNotify = "",
    this.memoryOptionEnabled = false,
    this.suggestCheckOption = false,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'items': items,
      'allowAdditionalDonation': allowAdditionalDonation,
      'purchaserInfo': purchaserInfo,
      'themeColor': themeColor,
      'shopLogoUrl': shopLogoUrl,
      'bannerUrl': bannerUrl,
      'bannerMediaType': bannerMediaType,
      'emailSubject': emailSubject,
      'emailBody': emailBody,
      'emailToNotify': emailToNotify,
      'memoryOptionEnabled': memoryOptionEnabled,
      'suggestCheckOption': suggestCheckOption,
      'ownerId': ownerId,
      'createdTime': Timestamp.fromDate(createdTime),
      'status': status,
      'shareableLink': shareableLink,
      'formType': formType,
    };
  }

  factory ShopForm.fromFirestore(dynamic snapshot) {
    final data = snapshot!.data();
    return ShopForm(
      id: snapshot.id,
      ownerId: data?["ownerId"] ?? "",
      createdTime: (data?["createdTime"] as Timestamp?)?.toDate() ?? DateTime.now(),
      title: data?["title"] ?? "",
      description: data?["description"] ?? "",
      items: data?["items"] is List ? Map<String,String>.from(data!["items"]) : {
        "uploadImageUrl":"",
        "title":"",
        "price":"",
        "description":""
      },
      allowAdditionalDonation: data?["allowAdditionalDonation"] ?? false,
      purchaserInfo: data?["purchaserInfo"] is Map
          ? Map<String, bool>.from(data!["purchaserInfo"])
          : {
        'Email': true,
        'First Name': true,
        'Last Name': true,
        'Address': false,
        'State': true,
        'Country': true,
      },
      themeColor: data?["themeColor"] ?? "#6200EE",
      shopLogoUrl: data?["shopLogoUrl"] ?? "",
      bannerUrl: data?["bannerUrl"] ?? "",
      bannerMediaType: data?["bannerMediaType"] ?? "Image",
      emailSubject: data?["emailSubject"] ?? "Thank you for your purchase",
      emailBody: data?["emailBody"] ?? "",
      emailToNotify: data?["emailToNotify"] ?? "",
      memoryOptionEnabled: data?["memoryOptionEnabled"] ?? false,
      suggestCheckOption: data?["suggestCheckOption"] ?? false,
      shareableLink: data?["shareableLink"] ?? "https://impact.web.app/shop/${snapshot.id}",
      status: data?["status"] ?? "draft",
    );
  }

  ShopForm copyWith({
    String? id,
    String? title,
    String? description,
    Map<String, String>? items,
    bool? allowAdditionalDonation,
    Map<String, bool>? purchaserInfo,
    String? themeColor,
    String? shopLogoUrl,
    String? bannerUrl,
    String? bannerMediaType,
    String? emailSubject,
    String? emailBody,
    String? emailToNotify,
    bool? memoryOptionEnabled,
    bool? suggestCheckOption,
    String? ownerId,
    DateTime? createdTime,
    String? status,
    String? shareableLink,
  }) {
    return ShopForm(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      items: items ?? this.items,
      allowAdditionalDonation: allowAdditionalDonation ?? this.allowAdditionalDonation,
      purchaserInfo: purchaserInfo ?? this.purchaserInfo,
      themeColor: themeColor ?? this.themeColor,
      shopLogoUrl: shopLogoUrl ?? this.shopLogoUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      bannerMediaType: bannerMediaType ?? this.bannerMediaType,
      emailSubject: emailSubject ?? this.emailSubject,
      emailBody: emailBody ?? this.emailBody,
      emailToNotify: emailToNotify ?? this.emailToNotify,
      memoryOptionEnabled: memoryOptionEnabled ?? this.memoryOptionEnabled,
      suggestCheckOption: suggestCheckOption ?? this.suggestCheckOption,
      ownerId: ownerId ?? this.ownerId,
      createdTime: createdTime ?? this.createdTime,
      status: status ?? this.status,
      shareableLink: shareableLink ?? this.shareableLink,
    );
  }
}