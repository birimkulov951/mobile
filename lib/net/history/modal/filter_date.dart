enum PeriodType {
  month,
  week,
  calendar,
  none,
}

class PeriodDateType {
  List<Carrd>? cardData;
  Dates? dates;
  PeriodTypee? periodType;
  String? headerButtonType;
  List<bool>? selectedCrads;

  PeriodDateType({
    this.cardData,
    this.dates,
    this.periodType,
    this.headerButtonType,
    this.selectedCrads,
  });

  PeriodDateType.fromJson(Map<String, dynamic> json) {
    selectedCrads = json['selectedCrads'].cast<bool>();
    if (json['cardData'] != null) {
      cardData = <Carrd>[];
      json['cardData'].forEach((v) {
        cardData?.add(new Carrd.fromJson(v));
      });
    }
    headerButtonType = json['type'];
    dates = json['dates'] != null ? new Dates.fromJson(json['dates']) : null;
    periodType = json['periodType'] != null
        ? new PeriodTypee.fromJson(json['periodType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['selectedCrads'] = this.selectedCrads;
    if (this.cardData != null) {
      data['cardData'] = this.cardData!.map((v) => v.toJson()).toList();
    }
    if (this.dates != null) {
      data['dates'] = this.dates!.toJson();
    }
    data['type'] = this.headerButtonType;
    if (this.periodType != null) {
      data['periodType'] = this.periodType!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'PeriodDateType{cardData: $cardData, dates: $dates, '
        'periodType: $periodType, headerButtonType: $headerButtonType, '
        'selectedCrads: $selectedCrads}';
  }
}

class Carrd {
  int? type;
  String? card;

  Carrd({
    this.type,
    this.card,
  });

  Carrd.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    card = json['card'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['card'] = this.card;
    return data;
  }

  @override
  String toString() {
    return 'Carrd{type: $type, card: $card}';
  }
}

class Dates {
  String? startDate;
  String? endDate;

  Dates({
    this.startDate,
    this.endDate,
  });

  Dates.fromJson(Map<String, dynamic> json) {
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    return data;
  }

  @override
  String toString() {
    return 'Dates{startDate: $startDate, endDate: $endDate}';
  }
}

class PeriodTypee {
  String? type;

  PeriodTypee({this.type});

  PeriodTypee.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    return data;
  }

  @override
  String toString() {
    return 'PeriodTypee{type: $type}';
  }
}
