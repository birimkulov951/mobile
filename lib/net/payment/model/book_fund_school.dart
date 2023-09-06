class BookFundSchool {
  final String? regionId;
  final String? sectorId;
  final String? schoolNumber;
  final String? schoolAccount;

  BookFundSchool({
    this.regionId,
    this.sectorId,
    this.schoolNumber,
    this.schoolAccount,
  });

  factory BookFundSchool.fromJson(dynamic json) => BookFundSchool(
        regionId: json['regionId'],
        sectorId: json['sectorId'],
        schoolNumber: json['schoolNumber'],
        schoolAccount: json['schoolAccount'],
      );

  static List<BookFundSchool> parseJsonResponse(List<dynamic> jsonResponse) =>
      List.generate(jsonResponse.length,
          (index) => BookFundSchool.fromJson(jsonResponse[index]));
}
