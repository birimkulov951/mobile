class BookFundSector {
  final String? sectorId;
  final String? sectorName;

  BookFundSector({
    this.sectorId,
    this.sectorName,
  });

  factory BookFundSector.fromJson(dynamic json) => BookFundSector(
        sectorId: json['sectorId'],
        sectorName: json['sectorName'],
      );

  static List<BookFundSector> parseJsonResponse(List<dynamic> jsonResponse) =>
      List.generate(jsonResponse.length,
          (index) => BookFundSector.fromJson(jsonResponse[index]));
}
