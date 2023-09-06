class NotificationResponse {
  NotificationResponse({
    int? id,
    String? title,
    String? message,
    dynamic logoUrl,
    String? date,
    int? active,
  }) {
    _id = id;
    _title = title;
    _message = message;
    _logoUrl = logoUrl;
    _date = date;
    _active = active;
  }

  NotificationResponse.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _message = json['message'];
    _logoUrl = json['logo_url'];
    _date = json['date'];
    _active = json['active'];
  }

  int? _id;
  String? _title;
  String? _message;
  dynamic _logoUrl;
  String? _date;
  int? _active;

  NotificationResponse copyWith({
    int? id,
    String? title,
    String? message,
    dynamic logoUrl,
    String? date,
    int? active,
  }) =>
      NotificationResponse(
        id: id ?? _id,
        title: title ?? _title,
        message: message ?? _message,
        logoUrl: logoUrl ?? _logoUrl,
        date: date ?? _date,
        active: active ?? _active,
      );

  int? get id => _id;

  String? get title => _title;

  String? get message => _message;

  dynamic get logoUrl => _logoUrl;

  String? get date => _date;

  int? get active => _active;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['message'] = _message;
    map['logo_url'] = _logoUrl;
    map['date'] = _date;
    map['active'] = _active;
    return map;
  }
}
