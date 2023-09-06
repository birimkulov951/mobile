class BookFundRegion {
  final String? regionId;
  final String? regionName;

  BookFundRegion({
    this.regionId,
    this.regionName,
  });

  factory BookFundRegion.fromJson(dynamic json) => BookFundRegion(
        regionId: json['regionId'],
        regionName: json['regionName'],
      );

  static List<BookFundRegion> parseJsonResponse(List<dynamic> jsonResponse) =>
      List.generate(jsonResponse.length,
          (index) => BookFundRegion.fromJson(jsonResponse[index]));

  @override
  String toString() => '{ "id": $regionId; "title": "$regionName" }';
}
