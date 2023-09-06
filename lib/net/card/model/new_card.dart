class NewCard {
  int? color;
  String? date;
  bool? main;
  String? number;
  String? name;
  int? order;
  String? token;
  int? type;

  NewCard({
    this.color,
    this.date,
    this.main,
    this.number,
    this.name,
    this.order,
    this.token,
    this.type,
  });

  Map<String, dynamic> toJson() => {
        'color': color,
        'expiry': date,
        'main': main,
        'pan': number,
        'name': name,
        'order': order,
        'token': token,
        'type': type,
      };
}
