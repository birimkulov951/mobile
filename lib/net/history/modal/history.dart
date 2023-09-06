
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
    int? pynetCode,
    String? pynetMessage,
    dynamic fio,
    dynamic commission,
    int? transactionId,
    dynamic pin,
    String? tranTime,
    dynamic reportDate,
    String? pynetReceipt,
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
    _pynetCode = pynetCode;
    _pynetMessage = pynetMessage;
    _fio = fio;
    _commission = commission;
    _transactionId = transactionId;
    _pin = pin;
    _tranTime = tranTime;
    _reportDate = reportDate;
    _pynetReceipt = pynetReceipt;
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
    _pynetCode = json['pynetCode'];
    _pynetMessage = json['pynetMessage'];
    _fio = json['fio'];
    _commission = json['commission'];
    _transactionId = json['transactionId'];
    _pin = json['pin'];
    _tranTime = json['tranTime'];
    _reportDate = json['reportDate'];
    _pynetReceipt = json['pynetReceipt'];
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
  int? _pynetCode;
  String? _pynetMessage;
  dynamic _fio;
  dynamic _commission;
  int? _transactionId;
  dynamic _pin;
  String? _tranTime;
  dynamic _reportDate;
  String? _pynetReceipt;
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
    int? pynetCode,
    String? pynetMessage,
    dynamic fio,
    dynamic commission,
    int? transactionId,
    dynamic pin,
    String? tranTime,
    dynamic reportDate,
    String? pynetReceipt,
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
        pynetCode: pynetCode ?? _pynetCode,
        pynetMessage: pynetMessage ?? _pynetMessage,
        fio: fio ?? _fio,
        commission: commission ?? _commission,
        transactionId: transactionId ?? _transactionId,
        pin: pin ?? _pin,
        tranTime: tranTime ?? _tranTime,
        reportDate: reportDate ?? _reportDate,
        pynetReceipt: pynetReceipt ?? _pynetReceipt,
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

  int? get pynetCode => _pynetCode;

  String? get pynetMessage => _pynetMessage;

  dynamic get fio => _fio;

  dynamic get commission => _commission;

  int? get transactionId => _transactionId;

  dynamic get pin => _pin;

  String? get tranTime => _tranTime;

  dynamic get reportDate => _reportDate;

  String? get pynetReceipt => _pynetReceipt;

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
    map['pynetCode'] = _pynetCode;
    map['pynetMessage'] = _pynetMessage;
    map['fio'] = _fio;
    map['commission'] = _commission;
    map['transactionId'] = _transactionId;
    map['pin'] = _pin;
    map['tranTime'] = _tranTime;
    map['reportDate'] = _reportDate;
    map['pynetReceipt'] = _pynetReceipt;
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
/// pynetComission : 0
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
    int? pynetComission,
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
    _pynetComission = pynetComission;
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
    _pynetComission = json['pynetComission'];
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
  int? _pynetComission;
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
    int? pynetComission,
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
        pynetComission: pynetComission ?? _pynetComission,
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

  int? get pynetComission => _pynetComission;

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
    map['pynetComission'] = _pynetComission;
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
