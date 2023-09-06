import 'package:equatable/equatable.dart';
import 'package:mobile_ultra/main.dart';

class AbroadTransferCountryEntity with EquatableMixin {
  final String icon;
  final Country country;
  final int merchantId;
  final String flagToCountryUrl;

  const AbroadTransferCountryEntity({
    required this.icon,
    required this.country,
    required this.merchantId,
    required this.flagToCountryUrl,
  });

  @override
  List<Object> get props => [
        icon,
        country,
        merchantId,
        flagToCountryUrl,
      ];
}

enum Country { kazakhstan }

extension CountryExt on Country {
  String get countryLabel {
    switch (this) {
      case Country.kazakhstan:
        return locale.getText('to_kazakhstan');
    }
  }

  String get countryName {
    switch (this) {
      case Country.kazakhstan:
        return locale.getText('Kazakhstan');
    }
  }
}
