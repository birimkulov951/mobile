// /// id : null
// /// externalId : null
// /// pan : "986008******7548"
// /// pan2 : null
// /// tranType : "DEBIT"
// /// amount : 15504000
// /// amountCredit : 15504000
// /// date7 : "2022-06-11T14:20:55+05:00"
// /// dcreated : "2022-06-16T14:04:05.618+05:00"
// /// stan : "072860"
// /// date12 : "2022-06-11T14:20:55+05:00"
// /// expiry : null
// /// refNum : null
// /// merchantId : "010710100686102"
// /// terminalId : "271107P6"
// /// currency : 860
// /// field48 : null
// /// field91 : null
// /// resp : 0
// /// status : "OK"
// /// login : null
// /// card1 : "9860080112277548"
// /// card2 : null
// /// merchantName : "SWEET CONFECTIONERY"
// /// account : "0801132001476853"
// /// billId : null
// /// merchantHash : null
// /// paynetCode : null
// /// paynetMessage : null
// /// fio : null
// /// commission : null
// /// transactionId : null
// /// pin : null
// /// tranTime : null
// /// reportDate : null
// /// paynetReceipt : null
// /// additionalInfo : null
// /// mobileQrDto : null
// /// ok : true
// /// successful : false
// /// humo_payment_ref : null
// /// auth_action_code : null
// /// auth_ref_number : null
// /// paymentReceipt : null
//
// class HistoryResponse {
//   HistoryResponse({
//     dynamic id,
//     dynamic externalId,
//     String pan,
//     dynamic pan2,
//     String tranType,
//     num amount,
//     num amountCredit,
//     String date7,
//     String dcreated,
//     String stan,
//     String date12,
//     dynamic expiry,
//     dynamic refNum,
//     String merchantId,
//     String terminalId,
//     num currency,
//     dynamic field48,
//     dynamic field91,
//     num resp,
//     String status,
//     dynamic login,
//     String card1,
//     dynamic card2,
//     String merchantName,
//     String account,
//     dynamic billId,
//     dynamic merchantHash,
//     dynamic paynetCode,
//     dynamic paynetMessage,
//     dynamic fio,
//     dynamic commission,
//     dynamic transactionId,
//     dynamic pin,
//     dynamic tranTime,
//     dynamic reportDate,
//     dynamic paynetReceipt,
//     dynamic additionalInfo,
//     dynamic mobileQrDto,
//     bool ok,
//     bool successful,
//     dynamic humoPaymentRef,
//     dynamic authActionCode,
//     dynamic authRefNumber,
//     dynamic paymentReceipt,
//   }) {
//     _id = id;
//     _externalId = externalId;
//     _pan = pan;
//     _pan2 = pan2;
//     _tranType = tranType;
//     _amount = amount;
//     _amountCredit = amountCredit;
//     _date7 = date7;
//     _dcreated = dcreated;
//     _stan = stan;
//     _date12 = date12;
//     _expiry = expiry;
//     _refNum = refNum;
//     _merchantId = merchantId;
//     _terminalId = terminalId;
//     _currency = currency;
//     _field48 = field48;
//     _field91 = field91;
//     _resp = resp;
//     _status = status;
//     _login = login;
//     _card1 = card1;
//     _card2 = card2;
//     _merchantName = merchantName;
//     _account = account;
//     _billId = billId;
//     _merchantHash = merchantHash;
//     _paynetCode = paynetCode;
//     _paynetMessage = paynetMessage;
//     _fio = fio;
//     _commission = commission;
//     _transactionId = transactionId;
//     _pin = pin;
//     _tranTime = tranTime;
//     _reportDate = reportDate;
//     _paynetReceipt = paynetReceipt;
//     _additionalInfo = additionalInfo;
//     _mobileQrDto = mobileQrDto;
//     _ok = ok;
//     _successful = successful;
//     _humoPaymentRef = humoPaymentRef;
//     _authActionCode = authActionCode;
//     _authRefNumber = authRefNumber;
//     _paymentReceipt = paymentReceipt;
//   }
//
//   HistoryResponse.fromJson(dynamic json) {
//     _id = json['id'];
//     _externalId = json['externalId'];
//     _pan = json['pan'];
//     _pan2 = json['pan2'];
//     _tranType = json['tranType'];
//     _amount = json['amount'];
//     _amountCredit = json['amountCredit'];
//     _date7 = json['date7'];
//     _dcreated = json['dcreated'];
//     _stan = json['stan'];
//     _date12 = json['date12'];
//     _expiry = json['expiry'];
//     _refNum = json['refNum'];
//     _merchantId = json['merchantId'];
//     _terminalId = json['terminalId'];
//     _currency = json['currency'];
//     _field48 = json['field48'];
//     _field91 = json['field91'];
//     _resp = json['resp'];
//     _status = json['status'];
//     _login = json['login'];
//     _card1 = json['card1'];
//     _card2 = json['card2'];
//     _merchantName = json['merchantName'];
//     _account = json['account'];
//     _billId = json['billId'];
//     _merchantHash = json['merchantHash'];
//     _paynetCode = json['paynetCode'];
//     _paynetMessage = json['paynetMessage'];
//     _fio = json['fio'];
//     _commission = json['commission'];
//     _transactionId = json['transactionId'];
//     _pin = json['pin'];
//     _tranTime = json['tranTime'];
//     _reportDate = json['reportDate'];
//     _paynetReceipt = json['paynetReceipt'];
//     _additionalInfo = json['additionalInfo'];
//     _mobileQrDto = json['mobileQrDto'];
//     _ok = json['ok'];
//     _successful = json['successful'];
//     _humoPaymentRef = json['humo_payment_ref'];
//     _authActionCode = json['auth_action_code'];
//     _authRefNumber = json['auth_ref_number'];
//     _paymentReceipt = json['paymentReceipt'];
//   }
//
//   dynamic _id;
//   dynamic _externalId;
//   String _pan;
//   dynamic _pan2;
//   String _tranType;
//   num _amount;
//   num _amountCredit;
//   String _date7;
//   String _dcreated;
//   String _stan;
//   String _date12;
//   dynamic _expiry;
//   dynamic _refNum;
//   String _merchantId;
//   String _terminalId;
//   num _currency;
//   dynamic _field48;
//   dynamic _field91;
//   num _resp;
//   String _status;
//   dynamic _login;
//   String _card1;
//   dynamic _card2;
//   String _merchantName;
//   String _account;
//   dynamic _billId;
//   dynamic _merchantHash;
//   dynamic _paynetCode;
//   dynamic _paynetMessage;
//   dynamic _fio;
//   dynamic _commission;
//   dynamic _transactionId;
//   dynamic _pin;
//   dynamic _tranTime;
//   dynamic _reportDate;
//   dynamic _paynetReceipt;
//   dynamic _additionalInfo;
//   dynamic _mobileQrDto;
//   bool _ok;
//   bool _successful;
//   dynamic _humoPaymentRef;
//   dynamic _authActionCode;
//   dynamic _authRefNumber;
//   dynamic _paymentReceipt;
//
//   HistoryResponse copyWith({
//     dynamic id,
//     dynamic externalId,
//     String pan,
//     dynamic pan2,
//     String tranType,
//     num amount,
//     num amountCredit,
//     String date7,
//     String dcreated,
//     String stan,
//     String date12,
//     dynamic expiry,
//     dynamic refNum,
//     String merchantId,
//     String terminalId,
//     num currency,
//     dynamic field48,
//     dynamic field91,
//     num resp,
//     String status,
//     dynamic login,
//     String card1,
//     dynamic card2,
//     String merchantName,
//     String account,
//     dynamic billId,
//     dynamic merchantHash,
//     dynamic paynetCode,
//     dynamic paynetMessage,
//     dynamic fio,
//     dynamic commission,
//     dynamic transactionId,
//     dynamic pin,
//     dynamic tranTime,
//     dynamic reportDate,
//     dynamic paynetReceipt,
//     dynamic additionalInfo,
//     dynamic mobileQrDto,
//     bool ok,
//     bool successful,
//     dynamic humoPaymentRef,
//     dynamic authActionCode,
//     dynamic authRefNumber,
//     dynamic paymentReceipt,
//   }) =>
//       HistoryResponse(
//         id: id ?? _id,
//         externalId: externalId ?? _externalId,
//         pan: pan ?? _pan,
//         pan2: pan2 ?? _pan2,
//         tranType: tranType ?? _tranType,
//         amount: amount ?? _amount,
//         amountCredit: amountCredit ?? _amountCredit,
//         date7: date7 ?? _date7,
//         dcreated: dcreated ?? _dcreated,
//         stan: stan ?? _stan,
//         date12: date12 ?? _date12,
//         expiry: expiry ?? _expiry,
//         refNum: refNum ?? _refNum,
//         merchantId: merchantId ?? _merchantId,
//         terminalId: terminalId ?? _terminalId,
//         currency: currency ?? _currency,
//         field48: field48 ?? _field48,
//         field91: field91 ?? _field91,
//         resp: resp ?? _resp,
//         status: status ?? _status,
//         login: login ?? _login,
//         card1: card1 ?? _card1,
//         card2: card2 ?? _card2,
//         merchantName: merchantName ?? _merchantName,
//         account: account ?? _account,
//         billId: billId ?? _billId,
//         merchantHash: merchantHash ?? _merchantHash,
//         paynetCode: paynetCode ?? _paynetCode,
//         paynetMessage: paynetMessage ?? _paynetMessage,
//         fio: fio ?? _fio,
//         commission: commission ?? _commission,
//         transactionId: transactionId ?? _transactionId,
//         pin: pin ?? _pin,
//         tranTime: tranTime ?? _tranTime,
//         reportDate: reportDate ?? _reportDate,
//         paynetReceipt: paynetReceipt ?? _paynetReceipt,
//         additionalInfo: additionalInfo ?? _additionalInfo,
//         mobileQrDto: mobileQrDto ?? _mobileQrDto,
//         ok: ok ?? _ok,
//         successful: successful ?? _successful,
//         humoPaymentRef: humoPaymentRef ?? _humoPaymentRef,
//         authActionCode: authActionCode ?? _authActionCode,
//         authRefNumber: authRefNumber ?? _authRefNumber,
//         paymentReceipt: paymentReceipt ?? _paymentReceipt,
//       );
//
//   dynamic get id => _id;
//
//   dynamic get externalId => _externalId;
//
//   String get pan => _pan;
//
//   dynamic get pan2 => _pan2;
//
//   String get tranType => _tranType;
//
//   num get amount => _amount;
//
//   num get amountCredit => _amountCredit;
//
//   String get date7 => _date7;
//
//   String get dcreated => _dcreated;
//
//   String get stan => _stan;
//
//   String get date12 => _date12;
//
//   dynamic get expiry => _expiry;
//
//   dynamic get refNum => _refNum;
//
//   String get merchantId => _merchantId;
//
//   String get terminalId => _terminalId;
//
//   num get currency => _currency;
//
//   dynamic get field48 => _field48;
//
//   dynamic get field91 => _field91;
//
//   num get resp => _resp;
//
//   String get status => _status;
//
//   dynamic get login => _login;
//
//   String get card1 => _card1;
//
//   dynamic get card2 => _card2;
//
//   String get merchantName => _merchantName;
//
//   String get account => _account;
//
//   dynamic get billId => _billId;
//
//   dynamic get merchantHash => _merchantHash;
//
//   dynamic get paynetCode => _paynetCode;
//
//   dynamic get paynetMessage => _paynetMessage;
//
//   dynamic get fio => _fio;
//
//   dynamic get commission => _commission;
//
//   dynamic get transactionId => _transactionId;
//
//   dynamic get pin => _pin;
//
//   dynamic get tranTime => _tranTime;
//
//   dynamic get reportDate => _reportDate;
//
//   dynamic get paynetReceipt => _paynetReceipt;
//
//   dynamic get additionalInfo => _additionalInfo;
//
//   dynamic get mobileQrDto => _mobileQrDto;
//
//   bool get ok => _ok;
//
//   bool get successful => _successful;
//
//   dynamic get humoPaymentRef => _humoPaymentRef;
//
//   dynamic get authActionCode => _authActionCode;
//
//   dynamic get authRefNumber => _authRefNumber;
//
//   dynamic get paymentReceipt => _paymentReceipt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['externalId'] = _externalId;
//     map['pan'] = _pan;
//     map['pan2'] = _pan2;
//     map['tranType'] = _tranType;
//     map['amount'] = _amount;
//     map['amountCredit'] = _amountCredit;
//     map['date7'] = _date7;
//     map['dcreated'] = _dcreated;
//     map['stan'] = _stan;
//     map['date12'] = _date12;
//     map['expiry'] = _expiry;
//     map['refNum'] = _refNum;
//     map['merchantId'] = _merchantId;
//     map['terminalId'] = _terminalId;
//     map['currency'] = _currency;
//     map['field48'] = _field48;
//     map['field91'] = _field91;
//     map['resp'] = _resp;
//     map['status'] = _status;
//     map['login'] = _login;
//     map['card1'] = _card1;
//     map['card2'] = _card2;
//     map['merchantName'] = _merchantName;
//     map['account'] = _account;
//     map['billId'] = _billId;
//     map['merchantHash'] = _merchantHash;
//     map['paynetCode'] = _paynetCode;
//     map['paynetMessage'] = _paynetMessage;
//     map['fio'] = _fio;
//     map['commission'] = _commission;
//     map['transactionId'] = _transactionId;
//     map['pin'] = _pin;
//     map['tranTime'] = _tranTime;
//     map['reportDate'] = _reportDate;
//     map['paynetReceipt'] = _paynetReceipt;
//     map['additionalInfo'] = _additionalInfo;
//     map['mobileQrDto'] = _mobileQrDto;
//     map['ok'] = _ok;
//     map['successful'] = _successful;
//     map['humo_payment_ref'] = _humoPaymentRef;
//     map['auth_action_code'] = _authActionCode;
//     map['auth_ref_number'] = _authRefNumber;
//     map['paymentReceipt'] = _paymentReceipt;
//     return map;
//   }
//   bool get isSuccess => resp == 0 && status == "OK";
//
// }

/// id : 6196484600
/// externalId : "1656483426051"
/// pan : "626272******1557"
/// pan2 : null
/// tranType : "DEBIT"
/// amount : 50000
/// amountCredit : null
/// date7 : "2022-06-29T11:17:30+05:00"
/// dcreated : "2022-06-29T11:17:06.139+05:00"
/// stan : "151625"
/// date12 : "0022-06-29T11:17:30+04:37:11"
/// expiry : 2504
/// refNum : "015107867461"
/// merchantId : "90330129663"
/// terminalId : "96071911"
/// currency : 860
/// field48 : null
/// field91 : null
/// resp : 0
/// status : "OK"
/// login : "998999050316"
/// card1 : "C782EDA3423D4C37302CFC3EF1DB7453"
/// card2 : null
/// merchantName : "Теплоэнерго"
/// account : "01000098392"
/// billId : 6159701076
/// merchantHash : "4834"
/// paynetCode : 0
/// paynetMessage : "Проведен успешно"
/// fio : null
/// commission : null
/// transactionId : 11257954548
/// pin : null
/// tranTime : "2022-06-29T11:17:30+05:00"
/// reportDate : null
/// paynetReceipt : "{\"status\":0,\"statusText\":\"Проведен успешно\",\"comission\":\"0\",\"details\":{\"consumer\":{\"label\":\"Потребитель\",\"value\":\"01000098392\"},\"amount\":{\"label\":\"Сумма\",\"value\":\"500\"},\"PayBank_Date\":{\"label\":\"Дата\",\"value\":\"29.06.2022 11:17:30\"},\"PAYER_ADDRESS\":{\"label\":\"Адрес потребителя\",\"value\":\"***************\"},\"PAYER_NAME\":{\"label\":\"ФИО потребителя\",\"value\":\"***************\"},\"PAYER_AREA\":{\"label\":\"Отапливаемая площадь кв.м\",\"value\":\"56,52\"},\"PAYER_MANS\":{\"label\":\"Кол-о проживающих лиц всего\",\"value\":\"**\"},\"PAYER_COUNTER_DATE\":{\"label\":\"Дата снятия показаний прибора учета\",\"value\":\"20.05.2022\"},\"PAYER_COUNTER\":{\"label\":\"Суммарные показания учтенные во взаиморасчетах\",\"value\":\"492\"},\"PAYER_COUNTER_TERM\":{\"label\":\"Дата окончания срока госповерки счётчика\",\"value\":null},\"PAYEE_TARIFFS_OVS\":{\"label\":\"Отопление\",\"value\":\"142,00\"},\"PAYEE_TARIFFS_GVS_2\":{\"label\":\"Тариф по ГВ\",\"value\":\"5242,00\"},\"service_name\":{\"label\":\"Услуга\",\"value\":\"Оплата\"},\"PayCard\":{\"label\":\"Карта\",\"value\":\"626272******1557\"},\"Payment_Code\":{\"label\":\"Номер транзакции UZPAYNET\",\"value\":\"11257954548\"},\"PayBank_Code\":{\"label\":\"Номер транзакции ЕОПЦ\",\"value\":\"015107867461\"},\"PayCode\":{\"label\":\"Номер транзакции Поставщика\",\"value\":\"e855a2bb9a7f4b958bf2c957af980966\"},\"Payment\":{\"label\":\"Сумма платежа\",\"value\":\"500\"},\"pay_amount\":{\"label\":\"Сумма платежа проводимого оператору\",\"value\":\"500\"},\"agent_name\":{\"label\":\"Агент\",\"value\":\"IPS PAYNET (Теплоэнергии)\"},\"agent_inn\":{\"label\":\"ИНН\",\"value\":\"175916449\"},\"time\":{\"label\":\"Время\",\"value\":\"29.06.2022 11:17:30\"},\"terminal_id\":{\"label\":\"Номер терминала\",\"value\":\"4155902\"},\"transaction_id\":{\"label\":\"Номер чека\",\"value\":\"11257954548\"},\"provider_name\":{\"label\":\"Оператор\",\"value\":\"Теплоэнерго Моб.\"}},\"success\":true}"
/// additionalInfo : null
/// mobileQrDto : {"id":16191673,"tranId":6196484600,"terminalId":"EP000000000017","checkId":2766804,"fiscalSign":"260621711382","qrCodeUrl":"https://ofd.soliq.uz/epi?t=EP000000000017&r=2766804&c=20220629111730&s=260621711382","totalAmount":500,"paynetComission":0,"providerPayment":500,"vat":65.21,"paymentType":"DEBIT","cash":0,"card":500,"remains":0,"agentAddress":"Узбекистан, г. Ташкент, ул. Фурката, 10","fiscalNumber":"EP000000000017","virtualKassNumber":"7.0.0","productCode":"09906001002000000"}
/// successful : false
/// ok : true
/// humo_payment_ref : null
/// auth_action_code : null
/// auth_ref_number : null
/// paymentReceipt : null

class HistoryResponse {
  HistoryResponse({
    int? id,
    String? externalId,
    String? pan,
    dynamic pan2,
    String? tranType,
    int? amount,
    dynamic amountCredit,
    String? date7,
    String? dcreated,
    String? stan,
    String? date12,
    int? expiry,
    String? refNum,
    String? merchantId,
    String? terminalId,
    int? currency,
    dynamic field48,
    dynamic field91,
    int? resp,
    String? status,
    String? login,
    String? card1,
    dynamic card2,
    String? merchantName,
    String? account,
    int? billId,
    String? merchantHash,
    int? paynetCode,
    String? paynetMessage,
    dynamic fio,
    dynamic commission,
    int? transactionId,
    dynamic pin,
    String? tranTime,
    dynamic reportDate,
    String? paynetReceipt,
    required dynamic additionalInfo,
    MobileQrDto? mobileQrDto,
    bool? successful,
    bool? ok,
    dynamic humoPaymentRef,
    dynamic authActionCode,
    dynamic authRefNumber,
    dynamic paymentReceipt,
  }) {
    _id = id;
    _externalId = externalId;
    _pan = pan;
    _pan2 = pan2;
    _tranType = tranType;
    _amount = amount;
    _amountCredit = amountCredit;
    _date7 = date7;
    _dcreated = dcreated;
    _stan = stan;
    _date12 = date12;
    _expiry = expiry;
    _refNum = refNum;
    _merchantId = merchantId;
    _terminalId = terminalId;
    _currency = currency;
    _field48 = field48;
    _field91 = field91;
    _resp = resp;
    _status = status;
    _login = login;
    _card1 = card1;
    _card2 = card2;
    _merchantName = merchantName;
    _account = account;
    _billId = billId;
    _merchantHash = merchantHash;
    _paynetCode = paynetCode;
    _paynetMessage = paynetMessage;
    _fio = fio;
    _commission = commission;
    _transactionId = transactionId;
    _pin = pin;
    _tranTime = tranTime;
    _reportDate = reportDate;
    _paynetReceipt = paynetReceipt;
    _additionalInfo = additionalInfo;
    _mobileQrDto = mobileQrDto;
    _successful = successful;
    _ok = ok;
    _humoPaymentRef = humoPaymentRef;
    _authActionCode = authActionCode;
    _authRefNumber = authRefNumber;
    _paymentReceipt = paymentReceipt;
  }

  HistoryResponse.fromJson(dynamic json) {
    _id = json['id'];
    _externalId = json['externalId'];
    _pan = json['pan'];
    _pan2 = json['pan2'];
    _tranType = json['tranType'];
    _amount = json['amount'];
    _amountCredit = json['amountCredit'];
    _date7 = json['date7'];
    _dcreated = json['dcreated'];
    _stan = json['stan'];
    _date12 = json['date12'];
    _expiry = json['expiry'];
    _refNum = json['refNum'];
    _merchantId = json['merchantId'];
    _terminalId = json['terminalId'];
    _currency = json['currency'];
    _field48 = json['field48'];
    _field91 = json['field91'];
    _resp = json['resp'];
    _status = json['status'];
    _login = json['login'];
    _card1 = json['card1'];
    _card2 = json['card2'];
    _merchantName = json['merchantName'];
    _account = json['account'];
    _billId = json['billId'];
    _merchantHash = json['merchantHash'];
    _paynetCode = json['paynetCode'];
    _paynetMessage = json['paynetMessage'];
    _fio = json['fio'];
    _commission = json['commission'];
    _transactionId = json['transactionId'];
    _pin = json['pin'];
    _tranTime = json['tranTime'];
    _reportDate = json['reportDate'];
    _paynetReceipt = json['paynetReceipt'];
    _additionalInfo = json['additionalInfo'];
    _mobileQrDto = json['mobileQrDto'] != null
        ? MobileQrDto.fromJson(json['mobileQrDto'])
        : null;
    _successful = json['successful'];
    _ok = json['ok'];
    _humoPaymentRef = json['humo_payment_ref'];
    _authActionCode = json['auth_action_code'];
    _authRefNumber = json['auth_ref_number'];
    _paymentReceipt = json['paymentReceipt'];
  }

  int? _id;
  String? _externalId;
  String? _pan;
  dynamic _pan2;
  String? _tranType;
  int? _amount;
  dynamic _amountCredit;
  String? _date7;
  String? _dcreated;
  String? _stan;
  String? _date12;
  int? _expiry;
  String? _refNum;
  String? _merchantId;
  String? _terminalId;
  int? _currency;
  dynamic _field48;
  dynamic _field91;
  int? _resp;
  String? _status;
  String? _login;
  String? _card1;
  dynamic _card2;
  String? _merchantName;
  String? _account;
  int? _billId;
  String? _merchantHash;
  int? _paynetCode;
  String? _paynetMessage;
  dynamic _fio;
  dynamic _commission;
  int? _transactionId;
  dynamic _pin;
  String? _tranTime;
  dynamic _reportDate;
  String? _paynetReceipt;
  dynamic _additionalInfo;
  MobileQrDto? _mobileQrDto;
  bool? _successful;
  bool? _ok;
  dynamic _humoPaymentRef;
  dynamic _authActionCode;
  dynamic _authRefNumber;
  dynamic _paymentReceipt;

  HistoryResponse copyWith({
    int? id,
    String? externalId,
    String? pan,
    dynamic pan2,
    String? tranType,
    int? amount,
    dynamic amountCredit,
    String? date7,
    String? dcreated,
    String? stan,
    String? date12,
    int? expiry,
    String? refNum,
    String? merchantId,
    String? terminalId,
    int? currency,
    dynamic field48,
    dynamic field91,
    int? resp,
    String? status,
    String? login,
    String? card1,
    dynamic card2,
    String? merchantName,
    String? account,
    int? billId,
    String? merchantHash,
    int? paynetCode,
    String? paynetMessage,
    dynamic fio,
    dynamic commission,
    int? transactionId,
    dynamic pin,
    String? tranTime,
    dynamic reportDate,
    String? paynetReceipt,
    dynamic additionalInfo,
    MobileQrDto? mobileQrDto,
    bool? successful,
    bool? ok,
    dynamic humoPaymentRef,
    dynamic authActionCode,
    dynamic authRefNumber,
    dynamic paymentReceipt,
  }) =>
      HistoryResponse(
        id: id ?? _id,
        externalId: externalId ?? _externalId,
        pan: pan ?? _pan,
        pan2: pan2 ?? _pan2,
        tranType: tranType ?? _tranType,
        amount: amount ?? _amount,
        amountCredit: amountCredit ?? _amountCredit,
        date7: date7 ?? _date7,
        dcreated: dcreated ?? _dcreated,
        stan: stan ?? _stan,
        date12: date12 ?? _date12,
        expiry: expiry ?? _expiry,
        refNum: refNum ?? _refNum,
        merchantId: merchantId ?? _merchantId,
        terminalId: terminalId ?? _terminalId,
        currency: currency ?? _currency,
        field48: field48 ?? _field48,
        field91: field91 ?? _field91,
        resp: resp ?? _resp,
        status: status ?? _status,
        login: login ?? _login,
        card1: card1 ?? _card1,
        card2: card2 ?? _card2,
        merchantName: merchantName ?? _merchantName,
        account: account ?? _account,
        billId: billId ?? _billId,
        merchantHash: merchantHash ?? _merchantHash,
        paynetCode: paynetCode ?? _paynetCode,
        paynetMessage: paynetMessage ?? _paynetMessage,
        fio: fio ?? _fio,
        commission: commission ?? _commission,
        transactionId: transactionId ?? _transactionId,
        pin: pin ?? _pin,
        tranTime: tranTime ?? _tranTime,
        reportDate: reportDate ?? _reportDate,
        paynetReceipt: paynetReceipt ?? _paynetReceipt,
        additionalInfo: additionalInfo ?? _additionalInfo,
        mobileQrDto: mobileQrDto ?? _mobileQrDto,
        successful: successful ?? _successful,
        ok: ok ?? _ok,
        humoPaymentRef: humoPaymentRef ?? _humoPaymentRef,
        authActionCode: authActionCode ?? _authActionCode,
        authRefNumber: authRefNumber ?? _authRefNumber,
        paymentReceipt: paymentReceipt ?? _paymentReceipt,
      );

  int? get id => _id;

  String? get externalId => _externalId;

  String? get pan => _pan;

  dynamic get pan2 => _pan2;

  String? get tranType => _tranType;

  int? get amount => _amount;

  dynamic get amountCredit => _amountCredit;

  String? get date7 => _date7;

  String? get dcreated => _dcreated;

  String? get stan => _stan;

  String? get date12 => _date12;

  int? get expiry => _expiry;

  String? get refNum => _refNum;

  String? get merchantId => _merchantId;

  String? get terminalId => _terminalId;

  int? get currency => _currency;

  dynamic get field48 => _field48;

  dynamic get field91 => _field91;

  int? get resp => _resp;

  String? get status => _status;

  String? get login => _login;

  String? get card1 => _card1;

  dynamic get card2 => _card2;

  String? get merchantName => _merchantName;

  String? get account => _account;

  int? get billId => _billId;

  String? get merchantHash => _merchantHash;

  int? get paynetCode => _paynetCode;

  String? get paynetMessage => _paynetMessage;

  dynamic get fio => _fio;

  dynamic get commission => _commission;

  int? get transactionId => _transactionId;

  dynamic get pin => _pin;

  String? get tranTime => _tranTime;

  dynamic get reportDate => _reportDate;

  String? get paynetReceipt => _paynetReceipt;

  dynamic get additionalInfo => _additionalInfo;

  MobileQrDto? get mobileQrDto => _mobileQrDto;

  bool? get successful => _successful;

  bool? get ok => _ok;

  dynamic get humoPaymentRef => _humoPaymentRef;

  dynamic get authActionCode => _authActionCode;

  dynamic get authRefNumber => _authRefNumber;

  dynamic get paymentReceipt => _paymentReceipt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['externalId'] = _externalId;
    map['pan'] = _pan;
    map['pan2'] = _pan2;
    map['tranType'] = _tranType;
    map['amount'] = _amount;
    map['amountCredit'] = _amountCredit;
    map['date7'] = _date7;
    map['dcreated'] = _dcreated;
    map['stan'] = _stan;
    map['date12'] = _date12;
    map['expiry'] = _expiry;
    map['refNum'] = _refNum;
    map['merchantId'] = _merchantId;
    map['terminalId'] = _terminalId;
    map['currency'] = _currency;
    map['field48'] = _field48;
    map['field91'] = _field91;
    map['resp'] = _resp;
    map['status'] = _status;
    map['login'] = _login;
    map['card1'] = _card1;
    map['card2'] = _card2;
    map['merchantName'] = _merchantName;
    map['account'] = _account;
    map['billId'] = _billId;
    map['merchantHash'] = _merchantHash;
    map['paynetCode'] = _paynetCode;
    map['paynetMessage'] = _paynetMessage;
    map['fio'] = _fio;
    map['commission'] = _commission;
    map['transactionId'] = _transactionId;
    map['pin'] = _pin;
    map['tranTime'] = _tranTime;
    map['reportDate'] = _reportDate;
    map['paynetReceipt'] = _paynetReceipt;
    map['additionalInfo'] = _additionalInfo;
    if (_mobileQrDto != null) {
      map['mobileQrDto'] = _mobileQrDto!.toJson();
    }
    map['successful'] = _successful;
    map['ok'] = _ok;
    map['humo_payment_ref'] = _humoPaymentRef;
    map['auth_action_code'] = _authActionCode;
    map['auth_ref_number'] = _authRefNumber;
    map['paymentReceipt'] = _paymentReceipt;
    return map;
  }

  bool get isSuccess => resp == 0 && status == "OK";
}

/// id : 16191673
/// tranId : 6196484600
/// terminalId : "EP000000000017"
/// checkId : 2766804
/// fiscalSign : "260621711382"
/// qrCodeUrl : "https://ofd.soliq.uz/epi?t=EP000000000017&r=2766804&c=20220629111730&s=260621711382"
/// totalAmount : 500
/// paynetComission : 0
/// providerPayment : 500
/// vat : 65.21
/// paymentType : "DEBIT"
/// cash : 0
/// card : 500
/// remains : 0
/// agentAddress : "Узбекистан, г. Ташкент, ул. Фурката, 10"
/// fiscalNumber : "EP000000000017"
/// virtualKassNumber : "7.0.0"
/// productCode : "09906001002000000"

class MobileQrDto {
  MobileQrDto({
    int? id,
    int? tranId,
    String? terminalId,
    int? checkId,
    String? fiscalSign,
    String? qrCodeUrl,
    int? totalAmount,
    int? paynetComission,
    int? providerPayment,
    double? vat,
    String? paymentType,
    int? cash,
    int? card,
    int? remains,
    String? agentAddress,
    String? fiscalNumber,
    String? virtualKassNumber,
    String? productCode,
  }) {
    _id = id;
    _tranId = tranId;
    _terminalId = terminalId;
    _checkId = checkId;
    _fiscalSign = fiscalSign;
    _qrCodeUrl = qrCodeUrl;
    _totalAmount = totalAmount;
    _paynetComission = paynetComission;
    _providerPayment = providerPayment;
    _vat = vat;
    _paymentType = paymentType;
    _cash = cash;
    _card = card;
    _remains = remains;
    _agentAddress = agentAddress;
    _fiscalNumber = fiscalNumber;
    _virtualKassNumber = virtualKassNumber;
    _productCode = productCode;
  }

  MobileQrDto.fromJson(dynamic json) {
    _id = json['id'];
    _tranId = json['tranId'];
    _terminalId = json['terminalId'];
    _checkId = json['checkId'];
    _fiscalSign = json['fiscalSign'];
    _qrCodeUrl = json['qrCodeUrl'];
    _totalAmount = json['totalAmount'];
    _paynetComission = json['paynetComission'];
    _providerPayment = json['providerPayment'];
    _vat = json['vat'];
    _paymentType = json['paymentType'];
    _cash = json['cash'];
    _card = json['card'];
    _remains = json['remains'];
    _agentAddress = json['agentAddress'];
    _fiscalNumber = json['fiscalNumber'];
    _virtualKassNumber = json['virtualKassNumber'];
    _productCode = json['productCode'];
  }

  int? _id;
  int? _tranId;
  String? _terminalId;
  int? _checkId;
  String? _fiscalSign;
  String? _qrCodeUrl;
  int? _totalAmount;
  int? _paynetComission;
  int? _providerPayment;
  double? _vat;
  String? _paymentType;
  int? _cash;
  int? _card;
  int? _remains;
  String? _agentAddress;
  String? _fiscalNumber;
  String? _virtualKassNumber;
  String? _productCode;

  MobileQrDto copyWith({
    int? id,
    int? tranId,
    String? terminalId,
    int? checkId,
    String? fiscalSign,
    String? qrCodeUrl,
    int? totalAmount,
    int? paynetComission,
    int? providerPayment,
    double? vat,
    String? paymentType,
    int? cash,
    int? card,
    int? remains,
    String? agentAddress,
    String? fiscalNumber,
    String? virtualKassNumber,
    String? productCode,
  }) =>
      MobileQrDto(
        id: id ?? _id,
        tranId: tranId ?? _tranId,
        terminalId: terminalId ?? _terminalId,
        checkId: checkId ?? _checkId,
        fiscalSign: fiscalSign ?? _fiscalSign,
        qrCodeUrl: qrCodeUrl ?? _qrCodeUrl,
        totalAmount: totalAmount ?? _totalAmount,
        paynetComission: paynetComission ?? _paynetComission,
        providerPayment: providerPayment ?? _providerPayment,
        vat: vat ?? _vat,
        paymentType: paymentType ?? _paymentType,
        cash: cash ?? _cash,
        card: card ?? _card,
        remains: remains ?? _remains,
        agentAddress: agentAddress ?? _agentAddress,
        fiscalNumber: fiscalNumber ?? _fiscalNumber,
        virtualKassNumber: virtualKassNumber ?? _virtualKassNumber,
        productCode: productCode ?? _productCode,
      );

  int? get id => _id;

  int? get tranId => _tranId;

  String? get terminalId => _terminalId;

  int? get checkId => _checkId;

  String? get fiscalSign => _fiscalSign;

  String? get qrCodeUrl => _qrCodeUrl;

  int? get totalAmount => _totalAmount;

  int? get paynetComission => _paynetComission;

  int? get providerPayment => _providerPayment;

  double? get vat => _vat;

  String? get paymentType => _paymentType;

  int? get cash => _cash;

  int? get card => _card;

  int? get remains => _remains;

  String? get agentAddress => _agentAddress;

  String? get fiscalNumber => _fiscalNumber;

  String? get virtualKassNumber => _virtualKassNumber;

  String? get productCode => _productCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['tranId'] = _tranId;
    map['terminalId'] = _terminalId;
    map['checkId'] = _checkId;
    map['fiscalSign'] = _fiscalSign;
    map['qrCodeUrl'] = _qrCodeUrl;
    map['totalAmount'] = _totalAmount;
    map['paynetComission'] = _paynetComission;
    map['providerPayment'] = _providerPayment;
    map['vat'] = _vat;
    map['paymentType'] = _paymentType;
    map['cash'] = _cash;
    map['card'] = _card;
    map['remains'] = _remains;
    map['agentAddress'] = _agentAddress;
    map['fiscalNumber'] = _fiscalNumber;
    map['virtualKassNumber'] = _virtualKassNumber;
    map['productCode'] = _productCode;
    return map;
  }
}
