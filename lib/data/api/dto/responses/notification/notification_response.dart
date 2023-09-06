import 'package:json_annotation/json_annotation.dart';

part 'notification_response.g.dart';

@JsonSerializable()
class NotificationResponse {
  const NotificationResponse({
    required this.id,
    required this.date,
    required this.title,
    required this.message,
    this.logoUrl,
    this.subtitle,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);

  final int id;
  final String date;
  final String title;
  final String? logoUrl;
  final String message;
  final String? subtitle;

  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);
}
