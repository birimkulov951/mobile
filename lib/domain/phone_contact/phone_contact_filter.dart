class PhoneContactFilter {
  PhoneContactFilter({
    required this.phoneCountry,
    required this.searchText,
  });

  PhoneContactFilter.UzCountryCode(String searchText)
      : this(
          searchText: searchText,
          phoneCountry: PhoneCountry.uz,
        );

  final PhoneCountry phoneCountry;
  final String searchText;
}

enum PhoneCountry { uz }

extension PhoneCountryExt on PhoneCountry {
  String get code {
    switch (this) {
      case PhoneCountry.uz:
        return '998';
    }
  }

  int get phoneShortLength {
    switch (this) {
      case PhoneCountry.uz:
        return 9;
    }
  }

  int get phoneFullLength {
    switch (this) {
      case PhoneCountry.uz:
        return 12;
    }
  }
}
