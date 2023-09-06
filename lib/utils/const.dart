import 'package:mobile_ultra/domain/payment/payment_categories_entity.dart';

// TODO: specific merchant names should be set to each id
const _mobileAndGts = 1;
const _internetAndTv = 3;
const _internetAndTv2 = 9;
const _internetAndT3 = 4;
const _communalPayments = 6;
const _communalPayments2 = 70;
const _governmentServices = 101;
const _transport = 71;
const _transport2 = 11;
const _transport3 = 74;
const _transport4 = -3769;
const _ewallets = 15;
const _loansInstallments = 81;
const _loansInstallments2 = 17;
const _otherServices = 75;
const _otherServices2 = 76;
const _education = 77;
const _inPlaces = 16;
const _other = 78;
const _other2 = 79;
const _other3 = 80;
const _other4 = 14;
const _other5 = 7;
const _other6 = 12;
const _other7 = 667;
const _excludedMerchantIds = [
  1,
  3,
  4,
  6,
  9,
  11,
  14,
  15,
  16,
  17,
  70,
  71,
  73,
  74,
  75,
  76,
  77,
  78,
  79,
  80,
  81,
  101,
];

class Const {
  Const._();

  static const String APP_NAME = "EXAMPLE";
  static const String APP_NAME_DEV = "EXAMPLE_DEV";

  static const PUBLIC_OFFER =
      "";
  static const PUBLIC_OFFER2 =
      "";
  static const BONUS_TERMS =
      "";
  static const pynetMapDomain = "";
  static const pynetDomain = "";
  static const pynetCallCenter = "";
  static const TRACK_PAYMENTS_OFFER =
      "";
  static const infoBot = "";
  static const playStoreUrl =
      "";

  static const int MOBILE_OTHER_CARD = -1;
  static const int UZCARD = 1;
  static const int BONUS = 2;
  static const int HUMO = 4;
  static const int WALLET = 5;

  static const ERR_BAD_CREDENTIALS = "bad_credentials";
  static const ERR_ACTIVATION_CODE_SENT = "activation_code_sent";
  static const ERR_ACCESS_DENIED = 'access_denied';
  static const ERR_INVALID_TOKEN = "invalid_token";
  static const AUTHORIZATION = "Authorization";
  static const APP_VERSION = "App-Version";

  static const TONIROVKA = 'TN';
  static const DRIVER_DOC = 'DL';
  static const MIB = 'ID=';

  static const GUBDD_PREFIX = [
    'GA',
    'AC',
    'NA',
    'RS',
    'NV',
    'RA',
    'RJ',
    'RR',
    'KV',
  ];

  static const String created = "CREATED";
  static const String expired = "EXPIRED";
  static const String verified = "VERIFIED";
  static const String paid = "PAID";

  /// Payment categories helper
  static List<PaymentCategoryEntity> paymentCatList = [
    PaymentCategoryEntity(
      'mobile_and_gts',
      'assets/graphics_redesign/mobile_gts.svg',
      categoryIds: [_mobileAndGts],
    ),
    PaymentCategoryEntity(
      'internet_and_tv',
      'assets/graphics_redesign/internet.svg',
      categoryIds: [
        _internetAndTv,
        _internetAndTv2,
        _internetAndT3,
      ],
      subCategories: [
        PaymentSubCategoryEntity(
          'internet',
          'assets/graphics_redesign/wifi.svg',
          categoryIds: [_internetAndTv],
        ),
        PaymentSubCategoryEntity(
          'tv',
          'assets/graphics_redesign/internet.svg',
          categoryIds: [_internetAndTv2],
        ),
        PaymentSubCategoryEntity(
          'ip_telephony',
          'assets/graphics_redesign/ip_tv.svg',
          categoryIds: [_internetAndT3],
        ),
      ],
    ),
    PaymentCategoryEntity(
      'communal_payments',
      'assets/graphics_redesign/communal.svg',
      categoryIds: [
        _communalPayments,
        _communalPayments2,
      ],
    ),
    PaymentCategoryEntity(
      'government_services',
      'assets/graphics_redesign/goverment.svg',
      categoryIds: [_governmentServices],
    ),
    PaymentCategoryEntity(
      'transport',
      'assets/graphics_redesign/auto.svg',
      categoryIds: [
        _transport,
        _transport2,
        _transport3,
        _transport4,
      ],
      subCategories: [
        PaymentSubCategoryEntity(
          'taxi_license',
          'assets/graphics/taxi.svg',
          categoryIds: [_transport],
        ),
        PaymentSubCategoryEntity(
          'taxi_dept',
          'assets/graphics/taxi.svg',
          categoryIds: [_transport2],
        ),
        PaymentSubCategoryEntity(
          'intercity_transport',
          'assets/graphics_redesign/auto.svg',
          categoryIds: [_transport3],
        ),
        PaymentSubCategoryEntity(
          'atto_replenishment',
          'assets/graphics/atto.svg',
          categoryIds: [_transport4],
        ),
      ],
    ),
    PaymentCategoryEntity(
      'ewallets',
      'assets/graphics_redesign/my_wallet.svg',
      categoryIds: [_ewallets],
    ),
    PaymentCategoryEntity(
      'loans_installments',
      'assets/graphics_redesign/loans.svg',
      categoryIds: [
        _loansInstallments,
        _loansInstallments2,
      ],
    ),
    PaymentCategoryEntity(
      'other_services',
      'assets/graphics_redesign/globus.svg',
      categoryIds: [
        _otherServices,
        _otherServices2,
      ],
      subCategories: [
        PaymentSubCategoryEntity(
          'games_and_social',
          'assets/graphics/games.svg',
          categoryIds: [_otherServices],
        ),
        PaymentSubCategoryEntity(
          'foreign_operators',
          'assets/graphics_redesign/globus.svg',
          categoryIds: [_otherServices2],
        ),
      ],
    ),
    PaymentCategoryEntity(
      'education',
      'assets/graphics_redesign/education.svg',
      categoryIds: [_education],
    ),
    PaymentCategoryEntity(
      'in_places',
      'assets/graphics_redesign/location.svg',
      categoryIds: [_inPlaces],
    ),
    PaymentCategoryEntity(
      'other',
      'assets/graphics_redesign/others.svg',
      categoryIds: [
        _other,
        _other2,
        _other3,
        _other4,
        _other5,
        _other6,
        _other7,
      ],
      subCategories: [
        PaymentSubCategoryEntity(
          'ad',
          'assets/graphics/ads.svg',
          categoryIds: [_other],
        ),
        PaymentSubCategoryEntity(
          'insurance',
          'assets/graphics/insurance.svg',
          categoryIds: [_other2],
        ),
        PaymentSubCategoryEntity(
          'internet_market',
          'assets/graphics/imarket.svg',
          categoryIds: [_other3],
        ),
        PaymentSubCategoryEntity(
          'charity',
          'assets/graphics/charity.svg',
          categoryIds: [_other4],
        ),
        PaymentSubCategoryEntity(
          'other',
          'assets/graphics_redesign/others.svg',
          categoryIds: [
            _other5,
            _other6,
            _other7,
          ],
          excludedIds: _excludedMerchantIds,
        ),
      ],
    ),
  ];
}
