import 'package:intl/intl.dart';

class News {
  final int? id;
  final String? banner;
  final String? title;
  final String? date;
  final String? message;
  final int? active;
  final bool? isNew;

  News({
    this.id,
    this.banner,
    this.title,
    this.date,
    this.message,
    this.active,
    this.isNew = false,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json['id'],
        banner: json['logoUrl'],
        title: json['title'],
        date: json['date'],
        message: json['message'],
        active: json['active'],
        isNew: DateTime.now()
                .difference(
                    DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(json['date']))
                .inDays ==
            0,
      );
}
