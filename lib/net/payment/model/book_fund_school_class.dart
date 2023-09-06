class BookFundSchoolClass {
  final int? classId;
  final String? classLang;
  final String? classNumber;
  final int? amount;
  final int? amountWithCommission;

  BookFundSchoolClass({
    this.classId,
    this.classLang,
    this.classNumber,
    this.amount,
    this.amountWithCommission,
  });

  factory BookFundSchoolClass.fromJson(dynamic json) => BookFundSchoolClass(
        classId: json['classId'],
        classLang: json['classLang'],
        classNumber: json['classNumber'],
        amount: json['amount'],
        amountWithCommission: json['amountWithCommission'],
      );

  static List<BookFundSchoolClass> parseJsonResponse(
          List<dynamic> jsonResponse) =>
      List.generate(jsonResponse.length,
          (index) => BookFundSchoolClass.fromJson(jsonResponse[index]));
}
