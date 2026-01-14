import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impact/screens/forms/models/base_form.dart';

class EventForm implements BaseForm {
  late final String title;
  late final String dateTime;
  late final String address;
  late final List<dynamic> description;
  late final String themeColor;
  late final String eventLogoUrl;
  late final Map<String, dynamic> ticketOptions;
  late final Map<String, bool> attendeeInfoCollection;
  @override
  late final String id;
  @override
  late final String ownerId;
  @override
  late final DateTime createdTime;
  @override
  late final String status;
  @override
  final String formType = "event";
  @override
  late final String shareableLink;

  EventForm(
      {required this.id, required this.ownerId, required this.createdTime, required this.dateTime, required this.title,
        required this.address, required this.description, required this.themeColor,
        required this.eventLogoUrl, required this.ticketOptions, required this.attendeeInfoCollection,
        required this.shareableLink, required this.status
      });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime,
      'address': address,
      'description': description,
      'themeColor': themeColor,
      'eventLogoUrl': eventLogoUrl,
      'ticketOptions': ticketOptions,
      'attendeeInfoCollection': attendeeInfoCollection,
      'ownerId': ownerId,
      'createdTime': Timestamp.fromDate(createdTime),
      'status': status,
      'shareableLink': shareableLink,
      'formType': formType,
    };
  }

  factory EventForm.fromFirestore(
      dynamic snapshot){
    final data = snapshot!.data();
    //print(data!["status"]);
    return EventForm(
        id: snapshot.id,  // Use snapshot.id instead of data["id"]
        ownerId: data?["ownerId"] ?? "",
        createdTime: (data?["createdTime"] as Timestamp?)?.toDate() ?? DateTime.now(),
        dateTime: data?["dateTime"] ?? DateTime.now().toIso8601String(),
        title: data?["title"] ?? "",
        address: data?["address"] ?? "",
        description: data?["description"] is List
            ? List<dynamic>.from(data!["description"])
            : [],
        themeColor: data?["themeColor"] ?? "#6200EE",
        eventLogoUrl: data?["eventLogoUrl"] ?? "",
        ticketOptions: data?["ticketOptions"] is Map
            ? Map<String, dynamic>.from(data!["ticketOptions"])
            : {},
        attendeeInfoCollection: data?["attendeeInfoCollection"] is Map
            ? Map<String, bool>.from(data!["attendeeInfoCollection"])
            : {'email': true, 'fullName': true, 'phoneNumber': false},
        shareableLink: data?["shareableLink"] ??
            "https://impact.web.app/events/${snapshot.id}",
        status: data?["status"] ?? "draft"
    );
  }

  EventForm copyWith({
    String? id,
    String? title,
    String? dateTime,
    String? address,
    List<Map<String, dynamic>>? description,
    String? themeColor,
    String? eventLogoUrl,
    Map<String, dynamic>? ticketOptions,
    Map<String, bool>? attendeeInfoCollection,
    String? ownerId,
    DateTime? createdTime,
    String? status,
    String? shareableLink,
  }) {
    return EventForm(
      id: id ?? this.id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      address: address ?? this.address,
      description: description ?? this.description,
      themeColor: themeColor ?? this.themeColor,
      eventLogoUrl: eventLogoUrl ?? this.eventLogoUrl,
      ticketOptions: ticketOptions ?? this.ticketOptions,
      attendeeInfoCollection: attendeeInfoCollection ?? this.attendeeInfoCollection,
      ownerId: ownerId ?? this.ownerId,
      createdTime: createdTime ?? this.createdTime,
      status: status ?? this.status,
      shareableLink: shareableLink ?? this.shareableLink,
    );
  }

}