import 'package:equatable/equatable.dart';

class NotificationEntity with EquatableMixin {
  const NotificationEntity({
    required this.id,
    required this.date,
    required this.title,
    required this.message,
    required this.logoUrl,
    required this.subtitle,
  });

  final int id;
  final String date;
  final String title;
  final String? logoUrl;
  final String message;
  final String? subtitle;

  @override
  String toString() {
    return '''NotificationEntity{data: id: $id, title: $title,
    subtitle: $subtitle, logoUrl: $logoUrl, message : $message}''';
  }

  @override
  List<Object?> get props => [
        id,
        date,
        title,
        logoUrl,
        subtitle,
        message,
      ];
}
