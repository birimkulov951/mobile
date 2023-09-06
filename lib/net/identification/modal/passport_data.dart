class PassportData {
  String? pinfl;
  String? passportNumber;
  String? photoBase64;

  PassportData({this.pinfl, this.passportNumber, this.photoBase64});

  PassportData.fromJson(Map<String, dynamic> json) {
    pinfl = json['pinfl'];
    passportNumber = json['document'];
    photoBase64 = json['photo_base64'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pinfl'] = this.pinfl;
    data['document'] = this.passportNumber;
    data['photo_base64'] = this.photoBase64;
    return data;
  }
}
