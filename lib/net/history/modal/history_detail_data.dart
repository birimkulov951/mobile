/// status : 0
/// statusText : "Проведен успешно"
/// comission : "0"
/// details : {"agent_name":{"label":"Агент","value":"PYNET (PYNET Mobile)"},"agent_inn":{"label":"ИНН","value":"205916449"},"provider_name":{"label":"Оператор","value":"Моб. Ташкент гор. ПЭС"},"service_name":{"label":"Услуга","value":"Оплата (mobile)"},"time":{"label":"Время","value":"29.06.2022 12:18:36"},"transaction_id":{"label":"Номер чека","value":"11258182568"},"purchased_amount":{"label":"Оплачено","value":"500"},"soato":{"label":"Соато","value":"26280"},"customer_code":{"label":"Лицевой счёт","value":"0494168"},"consumer":{"label":"Потребитель","value":"01000098392"},"amount":{"label":"Сумма","value":"500"},"PayBank_Date":{"label":"Дата","value":"29.06.2022 11:17:30"},"PAYER_ADDRESS":{"label":"Адрес потребителя","value":"***************"},"PAYER_NAME":{"label":"ФИО потребителя","value":"***************"},"PAYER_AREA":{"label":"Отапливаемая площадь кв.м","value":"56,52"},"PAYER_MANS":{"label":"Кол-о проживающих лиц всего","value":"**"},"PAYER_COUNTER_DATE":{"label":"Дата снятия показаний прибора учета","value":"20.05.2022"},"PAYER_COUNTER":{"label":"Суммарные показания учтенные во взаиморасчетах","value":"492"},"PAYER_COUNTER_TERM":{"label":"Дата окончания срока госповерки счётчика","value":null},"PAYEE_TARIFFS_OVS":{"label":"Отопление","value":"142,00"},"PAYEE_TARIFFS_GVS_2":{"label":"Тариф по ГВ","value":"5242,00"},"PayCard":{"label":"Карта","value":"626272******1557"},"Payment_Code":{"label":"Номер транзакции UZPYNET","value":"11257954548"},"PayBank_Code":{"label":"Номер транзакции ЕОПЦ","value":"015107867461"},"PayCode":{"label":"Номер транзакции Поставщика","value":"e855a2bb9a7f4b958bf2c957af980966"},"Payment":{"label":"Сумма платежа","value":"500"},"pay_amount":{"label":"Сумма платежа проводимого оператору","value":"500"},"terminal_id":{"label":"Номер терминала","value":"4138984"},"clientid":{"label":"Номер телефона","value":"953339038"}}
/// success : true

class HistoryDetailData {
  HistoryDetailData({
    int? status,
    String? statusText,
    String? comission,
    Details? details,
    bool? success,
  }) {
    _status = status;
    _statusText = statusText;
    _comission = comission;
    _details = details;
    _success = success;
  }

  HistoryDetailData.fromJson(dynamic json) {
    _status = json['status'];
    _statusText = json['statusText'];
    _comission = json['comission'];
    _details =
        json['details'] != null ? Details.fromJson(json['details']) : null;
    _success = json['success'];
  }

  int? _status;
  String? _statusText;
  String? _comission;
  Details? _details;
  bool? _success;

  HistoryDetailData copyWith({
    int? status,
    String? statusText,
    String? comission,
    Details? details,
    bool? success,
  }) =>
      HistoryDetailData(
        status: status ?? _status,
        statusText: statusText ?? _statusText,
        comission: comission ?? _comission,
        details: details ?? _details,
        success: success ?? _success,
      );

  int? get status => _status;

  String? get statusText => _statusText;

  String? get comission => _comission;

  Details? get details => _details;

  bool? get success => _success;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['statusText'] = _statusText;
    map['comission'] = _comission;
    if (_details != null) {
      map['details'] = _details!.toJson();
    }
    map['success'] = _success;
    return map;
  }
}

/// agent_name : {"label":"Агент","value":"PYNET (PYNET Mobile)"}
/// agent_inn : {"label":"ИНН","value":"205916449"}
/// provider_name : {"label":"Оператор","value":"Моб. Ташкент гор. ПЭС"}
/// service_name : {"label":"Услуга","value":"Оплата (mobile)"}
/// time : {"label":"Время","value":"29.06.2022 12:18:36"}
/// transaction_id : {"label":"Номер чека","value":"11258182568"}
/// purchased_amount : {"label":"Оплачено","value":"500"}
/// soato : {"label":"Соато","value":"26280"}
/// customer_code : {"label":"Лицевой счёт","value":"0494168"}
/// consumer : {"label":"Потребитель","value":"01000098392"}
/// amount : {"label":"Сумма","value":"500"}
/// PayBank_Date : {"label":"Дата","value":"29.06.2022 11:17:30"}
/// PAYER_ADDRESS : {"label":"Адрес потребителя","value":"***************"}
/// PAYER_NAME : {"label":"ФИО потребителя","value":"***************"}
/// PAYER_AREA : {"label":"Отапливаемая площадь кв.м","value":"56,52"}
/// PAYER_MANS : {"label":"Кол-о проживающих лиц всего","value":"**"}
/// PAYER_COUNTER_DATE : {"label":"Дата снятия показаний прибора учета","value":"20.05.2022"}
/// PAYER_COUNTER : {"label":"Суммарные показания учтенные во взаиморасчетах","value":"492"}
/// PAYER_COUNTER_TERM : {"label":"Дата окончания срока госповерки счётчика","value":null}
/// PAYEE_TARIFFS_OVS : {"label":"Отопление","value":"142,00"}
/// PAYEE_TARIFFS_GVS_2 : {"label":"Тариф по ГВ","value":"5242,00"}
/// PayCard : {"label":"Карта","value":"626272******1557"}
/// Payment_Code : {"label":"Номер транзакции UZPYNET","value":"11257954548"}
/// PayBank_Code : {"label":"Номер транзакции ЕОПЦ","value":"015107867461"}
/// PayCode : {"label":"Номер транзакции Поставщика","value":"e855a2bb9a7f4b958bf2c957af980966"}
/// Payment : {"label":"Сумма платежа","value":"500"}
/// pay_amount : {"label":"Сумма платежа проводимого оператору","value":"500"}
/// terminal_id : {"label":"Номер терминала","value":"4138984"}
/// clientid : {"label":"Номер телефона","value":"953339038"}

class Details {
  Details({
    AgentName? agentName,
    AgentInn? agentInn,
    ProviderName? providerName,
    ServiceName? serviceName,
    Time? time,
    TransactionId? transactionId,
    PurchasedAmount? purchasedAmount,
    Soato? soato,
    CustomerCode? customerCode,
    Consumer? consumer,
    Amount? amount,
    PayBankDate? payBankDate,
    PayerAddress? payeraddress,
    PayerName? payername,
    PayerArea? payerarea,
    PayerMans? payermans,
    PayerCounterDate? payercounterdate,
    PayerCounter? payercounter,
    PayerCounterTerm? payercounterterm,
    PayeeTariffsOvs? payeetariffsovs,
    PayeeTariffsGvs2? payeetariffsgvs2,
    PayCard? payCard,
    PaymentCode? paymentCode,
    PayBankCode? payBankCode,
    PayCode? payCode,
    Payment? payment,
    PayAmount? payAmount,
    TerminalId? terminalId,
    Clientid? clientid,
  }) {
    _agentName = agentName;
    _agentInn = agentInn;
    _providerName = providerName;
    _serviceName = serviceName;
    _time = time;
    _transactionId = transactionId;
    _purchasedAmount = purchasedAmount;
    _soato = soato;
    _customerCode = customerCode;
    _consumer = consumer;
    _amount = amount;
    _payBankDate = payBankDate;
    _payeraddress = payeraddress;
    _payername = payername;
    _payerarea = payerarea;
    _payermans = payermans;
    _payercounterdate = payercounterdate;
    _payercounter = payercounter;
    _payercounterterm = payercounterterm;
    _payeetariffsovs = payeetariffsovs;
    _payeetariffsgvs2 = payeetariffsgvs2;
    _payCard = payCard;
    _paymentCode = paymentCode;
    _payBankCode = payBankCode;
    _payCode = payCode;
    _payment = payment;
    _payAmount = payAmount;
    _terminalId = terminalId;
    _clientid = clientid;
  }

  Details.fromJson(dynamic json) {
    _agentName = json['agent_name'] != null
        ? AgentName.fromJson(json['agent_name'])
        : null;
    _agentInn =
        json['agent_inn'] != null ? AgentInn.fromJson(json['agent_inn']) : null;
    _providerName = json['provider_name'] != null
        ? ProviderName.fromJson(json['provider_name'])
        : null;
    _serviceName = json['service_name'] != null
        ? ServiceName.fromJson(json['service_name'])
        : null;
    _time = json['time'] != null ? Time.fromJson(json['time']) : null;
    _transactionId = json['transaction_id'] != null
        ? TransactionId.fromJson(json['transaction_id'])
        : null;
    _purchasedAmount = json['purchased_amount'] != null
        ? PurchasedAmount.fromJson(json['purchased_amount'])
        : null;
    _soato = json['soato'] != null ? Soato.fromJson(json['soato']) : null;
    _customerCode = json['customer_code'] != null
        ? CustomerCode.fromJson(json['customer_code'])
        : null;
    _consumer =
        json['consumer'] != null ? Consumer.fromJson(json['consumer']) : null;
    _amount = json['amount'] != null ? Amount.fromJson(json['amount']) : null;
    _payBankDate = json['PayBank_Date'] != null
        ? PayBankDate.fromJson(json['PayBank_Date'])
        : null;
    _payeraddress = json['PAYER_ADDRESS'] != null
        ? PayerAddress.fromJson(json['PAYER_ADDRESS'])
        : null;
    _payername = json['PAYER_NAME'] != null
        ? PayerName.fromJson(json['PAYER_NAME'])
        : null;
    _payerarea = json['PAYER_AREA'] != null
        ? PayerArea.fromJson(json['PAYER_AREA'])
        : null;
    _payermans = json['PAYER_MANS'] != null
        ? PayerMans.fromJson(json['PAYER_MANS'])
        : null;
    _payercounterdate = json['PAYER_COUNTER_DATE'] != null
        ? PayerCounterDate.fromJson(json['PAYER_COUNTER_DATE'])
        : null;
    _payercounter = json['PAYER_COUNTER'] != null
        ? PayerCounter.fromJson(json['PAYER_COUNTER'])
        : null;
    _payercounterterm = json['PAYER_COUNTER_TERM'] != null
        ? PayerCounterTerm.fromJson(json['PAYER_COUNTER_TERM'])
        : null;
    _payeetariffsovs = json['PAYEE_TARIFFS_OVS'] != null
        ? PayeeTariffsOvs.fromJson(json['PAYEE_TARIFFS_OVS'])
        : null;
    _payeetariffsgvs2 = json['PAYEE_TARIFFS_GVS_2'] != null
        ? PayeeTariffsGvs2.fromJson(json['PAYEE_TARIFFS_GVS_2'])
        : null;
    _payCard =
        json['PayCard'] != null ? PayCard.fromJson(json['PayCard']) : null;
    _paymentCode = json['Payment_Code'] != null
        ? PaymentCode.fromJson(json['Payment_Code'])
        : null;
    _payBankCode = json['PayBank_Code'] != null
        ? PayBankCode.fromJson(json['PayBank_Code'])
        : null;
    _payCode =
        json['PayCode'] != null ? PayCode.fromJson(json['PayCode']) : null;
    _payment =
        json['Payment'] != null ? Payment.fromJson(json['Payment']) : null;
    _payAmount = json['pay_amount'] != null
        ? PayAmount.fromJson(json['pay_amount'])
        : null;
    _terminalId = json['terminal_id'] != null
        ? TerminalId.fromJson(json['terminal_id'])
        : null;
    _clientid =
        json['clientid'] != null ? Clientid.fromJson(json['clientid']) : null;
  }

  AgentName? _agentName;
  AgentInn? _agentInn;
  ProviderName? _providerName;
  ServiceName? _serviceName;
  Time? _time;
  TransactionId? _transactionId;
  PurchasedAmount? _purchasedAmount;
  Soato? _soato;
  CustomerCode? _customerCode;
  Consumer? _consumer;
  Amount? _amount;
  PayBankDate? _payBankDate;
  PayerAddress? _payeraddress;
  PayerName? _payername;
  PayerArea? _payerarea;
  PayerMans? _payermans;
  PayerCounterDate? _payercounterdate;
  PayerCounter? _payercounter;
  PayerCounterTerm? _payercounterterm;
  PayeeTariffsOvs? _payeetariffsovs;
  PayeeTariffsGvs2? _payeetariffsgvs2;
  PayCard? _payCard;
  PaymentCode? _paymentCode;
  PayBankCode? _payBankCode;
  PayCode? _payCode;
  Payment? _payment;
  PayAmount? _payAmount;
  TerminalId? _terminalId;
  Clientid? _clientid;

  Details copyWith({
    AgentName? agentName,
    AgentInn? agentInn,
    ProviderName? providerName,
    ServiceName? serviceName,
    Time? time,
    TransactionId? transactionId,
    PurchasedAmount? purchasedAmount,
    Soato? soato,
    CustomerCode? customerCode,
    Consumer? consumer,
    Amount? amount,
    PayBankDate? payBankDate,
    PayerAddress? payeraddress,
    PayerName? payername,
    PayerArea? payerarea,
    PayerMans? payermans,
    PayerCounterDate? payercounterdate,
    PayerCounter? payercounter,
    PayerCounterTerm? payercounterterm,
    PayeeTariffsOvs? payeetariffsovs,
    PayeeTariffsGvs2? payeetariffsgvs2,
    PayCard? payCard,
    PaymentCode? paymentCode,
    PayBankCode? payBankCode,
    PayCode? payCode,
    Payment? payment,
    PayAmount? payAmount,
    TerminalId? terminalId,
    Clientid? clientid,
  }) =>
      Details(
        agentName: agentName ?? _agentName,
        agentInn: agentInn ?? _agentInn,
        providerName: providerName ?? _providerName,
        serviceName: serviceName ?? _serviceName,
        time: time ?? _time,
        transactionId: transactionId ?? _transactionId,
        purchasedAmount: purchasedAmount ?? _purchasedAmount,
        soato: soato ?? _soato,
        customerCode: customerCode ?? _customerCode,
        consumer: consumer ?? _consumer,
        amount: amount ?? _amount,
        payBankDate: payBankDate ?? _payBankDate,
        payeraddress: payeraddress ?? _payeraddress,
        payername: payername ?? _payername,
        payerarea: payerarea ?? _payerarea,
        payermans: payermans ?? _payermans,
        payercounterdate: payercounterdate ?? _payercounterdate,
        payercounter: payercounter ?? _payercounter,
        payercounterterm: payercounterterm ?? _payercounterterm,
        payeetariffsovs: payeetariffsovs ?? _payeetariffsovs,
        payeetariffsgvs2: payeetariffsgvs2 ?? _payeetariffsgvs2,
        payCard: payCard ?? _payCard,
        paymentCode: paymentCode ?? _paymentCode,
        payBankCode: payBankCode ?? _payBankCode,
        payCode: payCode ?? _payCode,
        payment: payment ?? _payment,
        payAmount: payAmount ?? _payAmount,
        terminalId: terminalId ?? _terminalId,
        clientid: clientid ?? _clientid,
      );

  AgentName? get agentName => _agentName;

  AgentInn? get agentInn => _agentInn;

  ProviderName? get providerName => _providerName;

  ServiceName? get serviceName => _serviceName;

  Time? get time => _time;

  TransactionId? get transactionId => _transactionId;

  PurchasedAmount? get purchasedAmount => _purchasedAmount;

  Soato? get soato => _soato;

  CustomerCode? get customerCode => _customerCode;

  Consumer? get consumer => _consumer;

  Amount? get amount => _amount;

  PayBankDate? get payBankDate => _payBankDate;

  PayerAddress? get payeraddress => _payeraddress;

  PayerName? get payername => _payername;

  PayerArea? get payerarea => _payerarea;

  PayerMans? get payermans => _payermans;

  PayerCounterDate? get payercounterdate => _payercounterdate;

  PayerCounter? get payercounter => _payercounter;

  PayerCounterTerm? get payercounterterm => _payercounterterm;

  PayeeTariffsOvs? get payeetariffsovs => _payeetariffsovs;

  PayeeTariffsGvs2? get payeetariffsgvs2 => _payeetariffsgvs2;

  PayCard? get payCard => _payCard;

  PaymentCode? get paymentCode => _paymentCode;

  PayBankCode? get payBankCode => _payBankCode;

  PayCode? get payCode => _payCode;

  Payment? get payment => _payment;

  PayAmount? get payAmount => _payAmount;

  TerminalId? get terminalId => _terminalId;

  Clientid? get clientid => _clientid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_agentName != null) {
      map['agent_name'] = _agentName!.toJson();
    }
    if (_agentInn != null) {
      map['agent_inn'] = _agentInn!.toJson();
    }
    if (_providerName != null) {
      map['provider_name'] = _providerName!.toJson();
    }
    if (_serviceName != null) {
      map['service_name'] = _serviceName!.toJson();
    }
    if (_time != null) {
      map['time'] = _time!.toJson();
    }
    if (_transactionId != null) {
      map['transaction_id'] = _transactionId!.toJson();
    }
    if (_purchasedAmount != null) {
      map['purchased_amount'] = _purchasedAmount!.toJson();
    }
    if (_soato != null) {
      map['soato'] = _soato!.toJson();
    }
    if (_customerCode != null) {
      map['customer_code'] = _customerCode!.toJson();
    }
    if (_consumer != null) {
      map['consumer'] = _consumer!.toJson();
    }
    if (_amount != null) {
      map['amount'] = _amount!.toJson();
    }
    if (_payBankDate != null) {
      map['PayBank_Date'] = _payBankDate!.toJson();
    }
    if (_payeraddress != null) {
      map['PAYER_ADDRESS'] = _payeraddress!.toJson();
    }
    if (_payername != null) {
      map['PAYER_NAME'] = _payername!.toJson();
    }
    if (_payerarea != null) {
      map['PAYER_AREA'] = _payerarea!.toJson();
    }
    if (_payermans != null) {
      map['PAYER_MANS'] = _payermans!.toJson();
    }
    if (_payercounterdate != null) {
      map['PAYER_COUNTER_DATE'] = _payercounterdate!.toJson();
    }
    if (_payercounter != null) {
      map['PAYER_COUNTER'] = _payercounter!.toJson();
    }
    if (_payercounterterm != null) {
      map['PAYER_COUNTER_TERM'] = _payercounterterm!.toJson();
    }
    if (_payeetariffsovs != null) {
      map['PAYEE_TARIFFS_OVS'] = _payeetariffsovs!.toJson();
    }
    if (_payeetariffsgvs2 != null) {
      map['PAYEE_TARIFFS_GVS_2'] = _payeetariffsgvs2!.toJson();
    }
    if (_payCard != null) {
      map['PayCard'] = _payCard!.toJson();
    }
    if (_paymentCode != null) {
      map['Payment_Code'] = _paymentCode!.toJson();
    }
    if (_payBankCode != null) {
      map['PayBank_Code'] = _payBankCode!.toJson();
    }
    if (_payCode != null) {
      map['PayCode'] = _payCode!.toJson();
    }
    if (_payment != null) {
      map['Payment'] = _payment!.toJson();
    }
    if (_payAmount != null) {
      map['pay_amount'] = _payAmount!.toJson();
    }
    if (_terminalId != null) {
      map['terminal_id'] = _terminalId!.toJson();
    }
    if (_clientid != null) {
      map['clientid'] = _clientid!.toJson();
    }
    return map;
  }
}

/// label : "Номер телефона"
/// value : "953339038"

class Clientid {
  Clientid({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  Clientid.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  Clientid copyWith({
    String? label,
    String? value,
  }) =>
      Clientid(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Номер терминала"
/// value : "4138984"

class TerminalId {
  TerminalId({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  TerminalId.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  TerminalId copyWith({
    String? label,
    String? value,
  }) =>
      TerminalId(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Сумма платежа проводимого оператору"
/// value : "500"

class PayAmount {
  PayAmount({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  PayAmount.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  PayAmount copyWith({
    String? label,
    String? value,
  }) =>
      PayAmount(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Сумма платежа"
/// value : "500"

class Payment {
  Payment({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  Payment.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  Payment copyWith({
    String? label,
    String? value,
  }) =>
      Payment(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Номер транзакции Поставщика"
/// value : "e855a2bb9a7f4b958bf2c957af980966"

class PayCode {
  PayCode({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  PayCode.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  PayCode copyWith({
    String? label,
    String? value,
  }) =>
      PayCode(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Номер транзакции ЕОПЦ"
/// value : "015107867461"

class PayBankCode {
  PayBankCode({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  PayBankCode.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  PayBankCode copyWith({
    String? label,
    String? value,
  }) =>
      PayBankCode(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Номер транзакции UZPYNET"
/// value : "11257954548"

class PaymentCode {
  PaymentCode({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  PaymentCode.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  PaymentCode copyWith({
    String? label,
    String? value,
  }) =>
      PaymentCode(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Карта"
/// value : "626272******1557"

class PayCard {
  PayCard({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  PayCard.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  PayCard copyWith({
    String? label,
    String? value,
  }) =>
      PayCard(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Тариф по ГВ"
/// value : "5242,00"

class PayeeTariffsGvs2 {
  PayeeTariffsGvs2({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  PayeeTariffsGvs2.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  PayeeTariffsGvs2 copyWith({
    String? label,
    String? value,
  }) =>
      PayeeTariffsGvs2(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Отопление"
/// value : "142,00"

class PayeeTariffsOvs {
  PayeeTariffsOvs({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  PayeeTariffsOvs.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  PayeeTariffsOvs copyWith({
    String? label,
    String? value,
  }) =>
      PayeeTariffsOvs(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Дата окончания срока госповерки счётчика"
/// value : null

class PayerCounterTerm {
  PayerCounterTerm({
    String? label,
    dynamic value,
  }) {
    _label = label;
    _value = value;
  }

  PayerCounterTerm.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  dynamic _value;

  PayerCounterTerm copyWith({
    String? label,
    dynamic value,
  }) =>
      PayerCounterTerm(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  dynamic get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Суммарные показания учтенные во взаиморасчетах"
/// value : "492"

class PayerCounter {
  PayerCounter({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  PayerCounter.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  PayerCounter copyWith({
    String? label,
    String? value,
  }) =>
      PayerCounter(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Дата снятия показаний прибора учета"
/// value : "20.05.2022"

class PayerCounterDate {
  PayerCounterDate({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  PayerCounterDate.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  PayerCounterDate copyWith({
    String? label,
    String? value,
  }) =>
      PayerCounterDate(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Кол-о проживающих лиц всего"
/// value : "**"

class PayerMans {
  PayerMans({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  PayerMans.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  PayerMans copyWith({
    String? label,
    String? value,
  }) =>
      PayerMans(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Отапливаемая площадь кв.м"
/// value : "56,52"

class PayerArea {
  PayerArea({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  PayerArea.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  PayerArea copyWith({
    String? label,
    String? value,
  }) =>
      PayerArea(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "ФИО потребителя"
/// value : "***************"

class PayerName {
  PayerName({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  PayerName.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  PayerName copyWith({
    String? label,
    String? value,
  }) =>
      PayerName(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Адрес потребителя"
/// value : "***************"

class PayerAddress {
  PayerAddress({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  PayerAddress.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  PayerAddress copyWith({
    String? label,
    String? value,
  }) =>
      PayerAddress(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Дата"
/// value : "29.06.2022 11:17:30"

class PayBankDate {
  PayBankDate({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  PayBankDate.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  PayBankDate copyWith({
    String? label,
    String? value,
  }) =>
      PayBankDate(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Сумма"
/// value : "500"

class Amount {
  Amount({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  Amount.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  Amount copyWith({
    String? label,
    String? value,
  }) =>
      Amount(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Потребитель"
/// value : "01000098392"

class Consumer {
  Consumer({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  Consumer.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  Consumer copyWith({
    String? label,
    String? value,
  }) =>
      Consumer(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Лицевой счёт"
/// value : "0494168"

class CustomerCode {
  CustomerCode({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  CustomerCode.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  CustomerCode copyWith({
    String? label,
    String? value,
  }) =>
      CustomerCode(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Соато"
/// value : "26280"

class Soato {
  Soato({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  Soato.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  Soato copyWith({
    String? label,
    String? value,
  }) =>
      Soato(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Оплачено"
/// value : "500"

class PurchasedAmount {
  PurchasedAmount({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  PurchasedAmount.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  PurchasedAmount copyWith({
    String? label,
    String? value,
  }) =>
      PurchasedAmount(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Номер чека"
/// value : "11258182568"

class TransactionId {
  TransactionId({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  TransactionId.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  TransactionId copyWith({
    String? label,
    String? value,
  }) =>
      TransactionId(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Время"
/// value : "29.06.2022 12:18:36"

class Time {
  Time({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  Time.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  Time copyWith({
    String? label,
    String? value,
  }) =>
      Time(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Услуга"
/// value : "Оплата (mobile)"

class ServiceName {
  ServiceName({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  ServiceName.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  ServiceName copyWith({
    String? label,
    String? value,
  }) =>
      ServiceName(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Оператор"
/// value : "Моб. Ташкент гор. ПЭС"

class ProviderName {
  ProviderName({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  ProviderName.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  ProviderName copyWith({
    String? label,
    String? value,
  }) =>
      ProviderName(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "ИНН"
/// value : "205916449"

class AgentInn {
  AgentInn({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  AgentInn.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  AgentInn copyWith({
    String? label,
    String? value,
  }) =>
      AgentInn(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}

/// label : "Агент"
/// value : "PYNET (PYNET Mobile)"

class AgentName {
  AgentName({
    String? label,
    String? value,
  }) {
    _label = label;
    _value = value;
  }

  AgentName.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }

  String? _label;
  String? _value;

  AgentName copyWith({
    String? label,
    String? value,
  }) =>
      AgentName(
        label: label ?? _label,
        value: value ?? _value,
      );

  String? get label => _label;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}
