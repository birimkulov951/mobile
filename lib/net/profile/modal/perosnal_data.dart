

class MyData {
  int? id;
  String? userLogin;
  String? pinPp;
  String? engName;
  String? nameLatin;
  String? patronYmLatin;
  String? document;
  String? birthDate;
  int? sex;
  String? surnameLatin;

  MyData({
    this.id,
    this.userLogin,
    this.pinPp,
    this.engName,
    this.nameLatin,
    this.patronYmLatin,
    this.document,
    this.birthDate,
    this.sex,
    this.surnameLatin,
  });

  MyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userLogin = json['userLogin'];
    pinPp = json['pinPp'];
    engName = json['engName'];
    nameLatin = json['nameLatin'];
    patronYmLatin = json['patronYmLatin'];
    document = json['document'];
    birthDate = json['birthDate'];
    sex = json['sex'];
    surnameLatin = json['surnameLatin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userLogin'] = this.userLogin;
    data['pinPp'] = this.pinPp;
    data['engName'] = this.engName;
    data['nameLatin'] = this.nameLatin;
    data['patronYmLatin'] = this.patronYmLatin;
    data['document'] = this.document;
    data['birthDate'] = this.birthDate;
    data['sex'] = this.sex;
    data['surnameLatin'] = this.surnameLatin;
    return data;
  }
}
