import 'package:mobile_ultra/main.dart';

class RequestError {
  final String? title;
  final String? detail;
  final int? status;
  final String? left;
  final String? id;
  final String? msgUz;
  final String? msgRu;

  RequestError({
    this.id,
    this.title,
    this.detail,
    this.status,
    this.left,
    this.msgRu,
    this.msgUz,
  });

  factory RequestError.fromJson(Map<String, dynamic> json) => RequestError(
        id: json['id'],
        title: json['title'],
        detail: json['detail'],
        status: json['status'],
        left: json['left'],
        msgRu: json['ru'],
        msgUz: json['uz'],
      );

  String? get getTitleByLanguage => locale.prefix == 'ru' ? msgRu : msgUz;

  @override
  String toString() {
    return 'RequestError{title: $title, detail: $detail, status: $status,'
        ' left: $left, id: $id, msgUz: $msgUz, msgRu: $msgRu}';
  }
}
