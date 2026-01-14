import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impact/screens/forms/models/base_form.dart';

class MembershipForm implements BaseForm {
  late final String title;
  late final String language;
  late final List<dynamic> description;
  late final List<Map<String, dynamic>> membershipLevels;
  late final bool allowDonation;
  late final bool requireAddress;
  late final bool emailNotification;
  late final bool showGoal;
  late final bool showProgress;
  late final bool allowComments;
  late final bool enableReceipt;
  late final bool enableReminders;
  late final bool allowOffline;

  @override
  late final String id;
  @override
  late final String ownerId;
  @override
  late final DateTime createdTime;
  @override
  late final String status;
  @override
  final String formType = "membership";
  @override
  late final String shareableLink;

  MembershipForm({
    required this.id,
    required this.ownerId,
    required this.createdTime,
    required this.title,
    required this.language,
    required this.description,
    required this.membershipLevels,
    required this.shareableLink,
    required this.status,
    this.allowDonation = true,
    this.requireAddress = false,
    this.emailNotification = true,
    this.showGoal = false,
    this.showProgress = false,
    this.allowComments = false,
    this.enableReceipt = false,
    this.enableReminders = false,
    this.allowOffline = false,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'language': language,
      'description': description,
      'membershipLevels': membershipLevels,
      'allowDonation': allowDonation,
      'requireAddress': requireAddress,
      'emailNotification': emailNotification,
      'showGoal': showGoal,
      'showProgress': showProgress,
      'allowComments': allowComments,
      'enableReceipt': enableReceipt,
      'enableReminders': enableReminders,
      'allowOffline': allowOffline,
      'ownerId': ownerId,
      'createdTime': Timestamp.fromDate(createdTime),
      'status': status,
      'shareableLink': shareableLink,
      'formType': formType,
    };
  }

  factory MembershipForm.fromFirestore(dynamic snapshot) {
    final data = snapshot!.data();
    return MembershipForm(
      id: snapshot.id,
      ownerId: data?["ownerId"] ?? "",
      createdTime: (data?["createdTime"] as Timestamp?)?.toDate() ?? DateTime.now(),
      title: data?["title"] ?? "",
      language: data?["language"] ?? "En",
      description: data?["description"] is List
          ? List<dynamic>.from(data!["description"])
          : [],
      membershipLevels: data?["membershipLevels"] is List
          ? List<Map<String, dynamic>>.from(data!["membershipLevels"])
          : [
        {
          "name": "Standard Member",
          "price": "25",
          "validity": "yearly",
          "description": ""
        }
      ],
      allowDonation: data?["allowDonation"] ?? true,
      requireAddress: data?["requireAddress"] ?? false,
      emailNotification: data?["emailNotification"] ?? true,
      showGoal: data?["showGoal"] ?? false,
      showProgress: data?["showProgress"] ?? false,
      allowComments: data?["allowComments"] ?? false,
      enableReceipt: data?["enableReceipt"] ?? false,
      enableReminders: data?["enableReminders"] ?? false,
      allowOffline: data?["allowOffline"] ?? false,
      shareableLink: data?["shareableLink"] ?? "https://impact.web.app/membership/${snapshot.id}",
      status: data?["status"] ?? "draft",
    );
  }

  MembershipForm copyWith({
    String? id,
    String? title,
    String? language,
    List<dynamic>? description,
    List<Map<String, dynamic>>? membershipLevels,
    bool? allowDonation,
    bool? requireAddress,
    bool? emailNotification,
    bool? showGoal,
    bool? showProgress,
    bool? allowComments,
    bool? enableReceipt,
    bool? enableReminders,
    bool? allowOffline,
    String? ownerId,
    DateTime? createdTime,
    String? status,
    String? shareableLink,
  }) {
    return MembershipForm(
      id: id ?? this.id,
      title: title ?? this.title,
      language: language ?? this.language,
      description: description ?? this.description,
      membershipLevels: membershipLevels ?? this.membershipLevels,
      allowDonation: allowDonation ?? this.allowDonation,
      requireAddress: requireAddress ?? this.requireAddress,
      emailNotification: emailNotification ?? this.emailNotification,
      showGoal: showGoal ?? this.showGoal,
      showProgress: showProgress ?? this.showProgress,
      allowComments: allowComments ?? this.allowComments,
      enableReceipt: enableReceipt ?? this.enableReceipt,
      enableReminders: enableReminders ?? this.enableReminders,
      allowOffline: allowOffline ?? this.allowOffline,
      ownerId: ownerId ?? this.ownerId,
      createdTime: createdTime ?? this.createdTime,
      status: status ?? this.status,
      shareableLink: shareableLink ?? this.shareableLink,
    );
  }
}
