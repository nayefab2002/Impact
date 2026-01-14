
abstract class BaseForm{
  String get id;
  String get ownerId;
  DateTime get createdTime;
  String get status;
  String get formType;
  String get shareableLink;

  Map<String, dynamic> toJson();
}