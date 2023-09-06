class AdditionInfo {
  final int logLevel;
  final String infoTextRu;
  final String infoTextEn;
  final String infoTextUz;

  AdditionInfo({
    this.logLevel = -1,
    this.infoTextRu = '',
    this.infoTextEn = '',
    this.infoTextUz = '',
  });

  factory AdditionInfo.fromJson(Map<String, dynamic> json) => AdditionInfo(
        logLevel: json['logLevel'],
        infoTextUz: json['infoTextUz'],
        infoTextEn: json['infoTextEn'],
        infoTextRu: json['infoTextRu'],
      );
}
