import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impact/screens/forms/models/base_form.dart';

class AuctionForm implements BaseForm {
  late final String title;
  late final String description;
  late final DateTime startDateTime;
  late final DateTime endDateTime;
  late final double startingBid;
  late final bool enableBidIncrements;
  late final double bidIncrement;
  late final String themeColor;
  late final bool enableNotifications;
  late final bool requireApproval;
  late final bool allowDiscountCodes;
  late final String notificationEmail;

  @override
  late final String id;
  @override
  late final String ownerId;
  @override
  late final DateTime createdTime;
  @override
  late final String status;
  @override
  final String formType = "auction";
  @override
  late final String shareableLink;

  AuctionForm({
    required this.id,
    required this.ownerId,
    required this.createdTime,
    required this.title,
    required this.description,
    required this.startDateTime,
    required this.endDateTime,
    required this.startingBid,
    required this.enableBidIncrements,
    required this.bidIncrement,
    required this.themeColor,
    required this.shareableLink,
    required this.status,
    this.enableNotifications = true,
    this.requireApproval = false,
    this.allowDiscountCodes = false,
    this.notificationEmail = "",
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDateTime': Timestamp.fromDate(startDateTime),
      'endDateTime': Timestamp.fromDate(endDateTime),
      'startingBid': startingBid,
      'enableBidIncrements': enableBidIncrements,
      'bidIncrement': bidIncrement,
      'themeColor': themeColor,
      'enableNotifications': enableNotifications,
      'requireApproval': requireApproval,
      'allowDiscountCodes': allowDiscountCodes,
      'notificationEmail': notificationEmail,
      'ownerId': ownerId,
      'createdTime': Timestamp.fromDate(createdTime),
      'status': status,
      'shareableLink': shareableLink,
      'formType': formType,
    };
  }

  factory AuctionForm.fromFirestore(dynamic snapshot) {
    final data = snapshot!.data();
    return AuctionForm(
      id: snapshot.id,
      ownerId: data?["ownerId"] ?? "",
      createdTime: (data?["createdTime"] as Timestamp?)?.toDate() ?? DateTime.now(),
      title: data?["title"] ?? "",
      description: data?["description"] ?? "",
      startDateTime: (data?["startDateTime"] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDateTime: (data?["endDateTime"] as Timestamp?)?.toDate() ?? DateTime.now().add(const Duration(days: 7)),
      startingBid: (data?["startingBid"] as num?)?.toDouble() ?? 0.0,
      enableBidIncrements: data?["enableBidIncrements"] ?? true,
      bidIncrement: (data?["bidIncrement"] as num?)?.toDouble() ?? 5.0,
      themeColor: data?["themeColor"] ?? "#6200EE",
      enableNotifications: data?["enableNotifications"] ?? true,
      requireApproval: data?["requireApproval"] ?? false,
      allowDiscountCodes: data?["allowDiscountCodes"] ?? false,
      notificationEmail: data?["notificationEmail"] ?? "",
      shareableLink: data?["shareableLink"] ?? "https://impact.web.app/auction/${snapshot.id}",
      status: data?["status"] ?? "draft",
    );
  }

  AuctionForm copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDateTime,
    DateTime? endDateTime,
    double? startingBid,
    bool? enableBidIncrements,
    double? bidIncrement,
    String? themeColor,
    bool? enableNotifications,
    bool? requireApproval,
    bool? allowDiscountCodes,
    String? notificationEmail,
    String? ownerId,
    DateTime? createdTime,
    String? status,
    String? shareableLink,
  }) {
    return AuctionForm(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      startingBid: startingBid ?? this.startingBid,
      enableBidIncrements: enableBidIncrements ?? this.enableBidIncrements,
      bidIncrement: bidIncrement ?? this.bidIncrement,
      themeColor: themeColor ?? this.themeColor,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      requireApproval: requireApproval ?? this.requireApproval,
      allowDiscountCodes: allowDiscountCodes ?? this.allowDiscountCodes,
      notificationEmail: notificationEmail ?? this.notificationEmail,
      ownerId: ownerId ?? this.ownerId,
      createdTime: createdTime ?? this.createdTime,
      status: status ?? this.status,
      shareableLink: shareableLink ?? this.shareableLink,
    );
  }
}