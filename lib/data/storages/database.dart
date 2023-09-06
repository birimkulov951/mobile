import 'dart:async';
import 'dart:convert';

import 'package:mobile_ultra/data/storages/tables/t_card_bean.dart';
import 'package:mobile_ultra/data/storages/tables/t_cards.dart';
import 'package:mobile_ultra/data/storages/tables/t_category.dart';
import 'package:mobile_ultra/data/storages/tables/t_fast_payment.dart';
import 'package:mobile_ultra/data/storages/tables/t_favorites.dart';
import 'package:mobile_ultra/data/storages/tables/t_field_values.dart';
import 'package:mobile_ultra/data/storages/tables/t_fields.dart';
import 'package:mobile_ultra/data/storages/tables/t_merchants.dart';
import 'package:mobile_ultra/data/storages/tables/t_news.dart';
import 'package:mobile_ultra/data/storages/tables/t_pynet_id.dart';
import 'package:mobile_ultra/data/storages/tables/t_reminder.dart';
import 'package:mobile_ultra/domain/cards/card_balance_entity.dart';
import 'package:mobile_ultra/domain/cards/card_beans_entity.dart';
import 'package:mobile_ultra/domain/cards/cards_balance_entity.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/domain/favorite/favorite.dart';
import 'package:mobile_ultra/extensions/common_extensions.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/model/payment/fpi.dart';
import 'package:mobile_ultra/model/payment/merchant_fields.dart';
import 'package:mobile_ultra/net/card/model/card.dart' as u_card;
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/card/model/card_been.dart';
import 'package:mobile_ultra/net/card/model/main_data.dart';
import 'package:mobile_ultra/net/payment/model/bill.dart';
import 'package:mobile_ultra/net/payment/model/pynetid.dart';
import 'package:mobile_ultra/net/payment/model/reminder.dart';
import 'package:mobile_ultra/ui_models/various/fpi_widget.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MUDatabase {
  Database? database;

  Future<MUDatabase> open() async {
    if (!isOpen) {
      database = await openDatabase(
        join(await getDatabasesPath(), 'mobile_ultra.db'),
        onCreate: (db, version) async {
          await db.execute(TCategory.SQL);
          await db.execute(TMerchants.SQL);
          await db.execute(TFields.SQL);
          await db.execute(TFieldValues.SQL);
          await db.execute(TPynetId.SQL);
          await db.execute(TFastPayment.SQL);
          await db.execute(TCards.SQL);
          await db.execute(TFavorites.SQL);
          await db.execute(TCardBean.SQL);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion == 1) {
            await db.execute(TMerchants.AT_BONUS);
          }

          if (oldVersion <= 2) {
            await db.execute(TCards.SQL);
            await db.execute(TFavorites.SQL);
            await db.execute(TFields.AT_REQUIRED);
            await db.execute(TNews.DROP);
          }

          if (oldVersion <= 3) {
            await db.execute(TCardBean.SQL);
            await db.execute(TMerchants.AT_STATE);
          }

          if (oldVersion <= 4) {
            try {
              await db.execute(TFavorites.AT_ORDER);
            } on Exception catch (_) {}
          }
        },
        version: 5,
      );
    }
    return this;
  }

  bool get isOpen {
    return database != null;
  }

  Future close() async {
    await database?.close();
    database = null;
  }

  /// Сторит данные по провайдерам
  Future setAllDataMerchants(Map<String, dynamic> data) async {
    await setFields(data['fields']);
    await setFieldValues(data['values']);
  }

  Future clearAllDataMerchants() async {
    await database?.delete(TFields.NAME);
    await database?.delete(TFieldValues.NAME);
  }

  /// Сторит поля провайдеров
  Future setFields(List<dynamic> fieldList) async {
    if (fieldList.isEmpty) return;

    await database?.delete(TFields.NAME);

    await database?.transaction((transaction) {
      final batch = transaction.batch();

      fieldList.forEach((item) {
        batch.insert(
          TFields.NAME,
          {
            TFields.ID: item['id'],
            TFields.MERCHANT_ID: item['merchantId'],
            TFields.TYPE_NAME: item['name'],
            TFields.TYPE: item['type'],
            TFields.NAME_RU: item['labelRu'],
            TFields.NAME_UZ: item['labelUz'],
            TFields.NAME_EN: item['labelEn'],
            TFields.FIELD_SIZE: item['fieldSize'],
            TFields.CONTROL_TYPE: item['controlType'],
            TFields.CONTROL_TYPE_INFO: item['controlTypeInfo'],
            TFields.PARENT_ID: item['parentId'],
            TFields.REQUIRED: item['required'],
            TFields.ORDER: item['ord'],
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });

      return batch.commit(noResult: true);
    });
  }

  /// Сторит значения по-умолчанию поля
  Future setFieldValues(List<dynamic> fieldValueList) async {
    if (fieldValueList.isEmpty) return;

    await database?.delete(TFieldValues.NAME);

    await database?.transaction((transaction) {
      final batch = transaction.batch();

      fieldValueList.forEach((item) {
        batch.insert(
          TFieldValues.NAME,
          {
            TFieldValues.ID: item['id'],
            TFieldValues.FIELD_ID: item['field_id'],
            TFieldValues.FIELD_VALUE: item['field_value'],
            TFieldValues.NAME_RU: item['field_label_ru'],
            TFieldValues.NAME_EN: item['field_label_en'],
            TFieldValues.NAME_UZ: item['field_label_uz'],
            TFieldValues.AMOUNT: item['amount'],
            TFieldValues.PREFIX: item['prefix'],
            TFieldValues.PARENT_ID: item['parent_id'],
            TFieldValues.CHECK_ID: item['check_id'],
            TFieldValues.ORDER: item['display_order'],
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });

      return batch.commit(noResult: true);
    });
  }

  /// Возвращает список полей по провайдеру
  Future<List<MerchantField>> getMerchantFields(
    int? merchantId,
    String lang,
  ) async {
    final List<MerchantField> items = [];

    final List<Map<String, dynamic>> result = (await database?.query(
          TFields.NAME,
          where: '${TFields.MERCHANT_ID} = ?',
          whereArgs: [merchantId],
          orderBy: TFields.ORDER,
        ) ??
        []);

    printLog('MERCHANT ID: ${merchantId}__________________________');
    for (int i = 0; i < result.length; i++) {
      final item = result[i];

      printLog('____________________________________________________');
      printLog('type: ${item[TFields.TYPE]}');
      printLog('typeName: ${item[TFields.TYPE_NAME]}');
      printLog('fieldSize: ${item[TFields.FIELD_SIZE]}');
      printLog('label: ${item['${TFields.NAME_}$lang']}');
      printLog('controlType: ${item[TFields.CONTROL_TYPE]}');
      printLog('controlTypeInfo: ${item[TFields.CONTROL_TYPE_INFO]}');
      printLog('required: ${item[TFields.REQUIRED] == 1}');
      printLog('parentId: ${item[TFields.PARENT_ID]}');

      items.add(
        MerchantField(
          id: item[TFields.ID],
          type: item[TFields.TYPE],
          typeName: item[TFields.TYPE_NAME],
          fieldSize: item[TFields.FIELD_SIZE],
          label: item['${TFields.NAME_}$lang'],
          controlType: item[TFields.CONTROL_TYPE],
          controlTypeInfo: item[TFields.CONTROL_TYPE_INFO],
          parentId: item[TFields.PARENT_ID],
          isRequired: item[TFields.REQUIRED] == 1,
          values: await getMerchantFieldValues(item[TFields.ID], lang),
        ),
      );
    }

    return items;
  }

  /// Возвращает список значений по полю
  Future<List<MerchantFieldValue>> getMerchantFieldValues(
    int fieldId,
    String lang,
  ) async {
    final List<Map<String, dynamic>> result = (await database?.query(
          TFieldValues.NAME,
          where: '${TFieldValues.FIELD_ID} = ?',
          whereArgs: [fieldId],
          orderBy: TFieldValues.ORDER,
        ) ??
        []);

    printLog('');
    printLog(' FIELD ID: $fieldId');
    return List.generate(result.length, (index) {
      final item = result[index];

      printLog(' _____________________________________________');
      printLog(' id: ${item[TFieldValues.ID]}');
      printLog(' fieldValue: ${item[TFieldValues.FIELD_VALUE]}');
      printLog(' label: ${item['${TFieldValues.NAME_}$lang']}');
      printLog(' amount: ${item[TFieldValues.AMOUNT]}');
      printLog(' prefix: ${item[TFieldValues.PREFIX]}');
      printLog(' checkId: ${item[TFieldValues.CHECK_ID]}');
      printLog(' parentId: ${item[TFieldValues.PARENT_ID]}');

      return MerchantFieldValue(
        id: item[TFieldValues.ID],
        fieldValue: item[TFieldValues.FIELD_VALUE],
        label: item['${TFieldValues.NAME_}$lang'],
        amount: item[TFieldValues.AMOUNT],
        prefix: item[TFieldValues.PREFIX],
        checkId: item[TFieldValues.CHECK_ID],
        parentId: item[TFieldValues.PARENT_ID],
      );
    });
  }

  /// Сторит лицевые счета
  Future setMyAccounts(List<PynetId> accountList) async {
    await database?.transaction((transaction) async {
      final batch = transaction.batch();

      accountList.forEach((item) {
        batch.insert(TPynetId.NAME, {
          TPynetId.ID: item.id,
          TPynetId.UPDATE_TIME: item.updateTime,
          TPynetId.ACCOUNT: item.account,
          TPynetId.COMMENT: item.comment,
          TPynetId.LAST_BALANCE: item.lastBalance,
          TPynetId.BALANCE_TYPE: item.balanceType,
          TPynetId.ORDER: item.order,
          TPynetId.MERCHANT_ID: item.merchantId,
          TPynetId.MERCHANT_NAME: item.merchantName,
          TPynetId.PAY_BILL: jsonEncode(item.payBill),
        });
      });

      return await batch.commit(noResult: true);
    });
  }

  /// Возвращает списо лицевых счетов
  Future<List<PynetId>> getMyAccounts() async {
    final List<Map<String, dynamic>> result =
        (await database?.query(TPynetId.NAME, orderBy: TPynetId.ORDER) ?? []);

    return List.generate(
      result.length,
      (index) => PynetId(
        id: result[index][TPynetId.ID],
        updateTime: result[index][TPynetId.UPDATE_TIME],
        account: result[index][TPynetId.ACCOUNT],
        comment: result[index][TPynetId.COMMENT],
        lastBalance: result[index][TPynetId.LAST_BALANCE].toDouble(),
        balanceType: result[index][TPynetId.BALANCE_TYPE],
        order: result[index][TPynetId.ORDER],
        merchantId: result[index][TPynetId.MERCHANT_ID],
        merchantName: result[index][TPynetId.MERCHANT_NAME],
        payBill: jsonDecode(result[index][TPynetId.PAY_BILL]),
      ),
    );
  }

  Future deleteAccount(int merchantId, String account) async =>
      await database?.delete(
        TPynetId.NAME,
        where: '${TPynetId.MERCHANT_ID} = ? AND ${TPynetId.ACCOUNT} = ?',
        whereArgs: [merchantId, account],
      );

  Future clearMyAccounts() async => await database?.delete(TPynetId.NAME);

  Future saveReminders(List<Reminder> reminders) async {
    await database?.transaction((transaction) async {
      final batch = transaction.batch();

      reminders.forEach((item) {
        batch.insert(TReminder.NAME, {
          TReminder.ID: item.id,
          TReminder.CREATED_AT: item.createDate,
          TReminder.LOGIN: item.login,
          TReminder.MERCHANT_ID: item.merchantId,
          TReminder.ACCOUNT: item.account,
          TReminder.REQUEST_STR: item.requestString,
          TReminder.AMOUNT: item.amount,
          TReminder.FIRE_WEEK_DAY: item.fireWeekDay,
          TReminder.FIRE_MONTH_DAY: item.fireMonthDay,
          TReminder.STATUS: item.status,
          TReminder.TYPE: item.type,
          TReminder.PAY_BILL: jsonEncode(item.payBill),
          TReminder.FINISH_DATE: item.finishDate,
          TReminder.SINGLE: (item.oneTimeReminder ?? false) ? 1 : 0,
        });
      });

      return await batch.commit(noResult: true);
    });
  }

  Future<List<Reminder>> getReminders({int? limit}) async {
    final List<Map<String, dynamic>> result = (await database?.query(
          TReminder.NAME,
          orderBy: TReminder.CREATED_AT,
          limit: limit,
        ) ??
        []);

    return List.generate(result.length, (position) {
      final item = result[position];

      return Reminder(
        id: item[TReminder.ID],
        createDate: item[TReminder.CREATED_AT],
        login: item[TReminder.LOGIN],
        merchantId: item[TReminder.MERCHANT_ID],
        account: item[TReminder.ACCOUNT],
        requestString: item[TReminder.REQUEST_STR],
        amount: item[TReminder.AMOUNT].toDouble(),
        fireWeekDay: item[TReminder.FIRE_WEEK_DAY],
        fireMonthDay: item[TReminder.FIRE_MONTH_DAY],
        status: item[TReminder.STATUS],
        type: item[TReminder.TYPE],
        payBill: item[TReminder.PAY_BILL],
        finishDate: item[TReminder.FINISH_DATE],
        oneTimeReminder: item[TReminder.SINGLE] == 1,
      );
    });
  }

  Future<List<FPI>> getFastPayments() async {
    final List<Map<String, dynamic>> result =
        (await database?.query(TFastPayment.NAME) ?? []);

    return List.generate(result.length, (index) {
      final item = result[index];

      return FPI(
        type: item[TFavorites.BILL_ID] != null
            ? FPIType.MERCHANT
            : FPIType.TRANSFER,
        title: item[TFastPayment.TITLE],
        merchantId: item[TFastPayment.MERCHANT_ID],
        merchantName: item[TFastPayment.MERCHANT_NAME],
        account: item[TFastPayment.ACCOUNT],
        payBill: item[TFastPayment.PAY_BILL],
      );
    });
  }

  void addPayment(MerchantEntity merchant, Bill bill, String title) {
    database?.insert(
      TFastPayment.NAME,
      {
        TFastPayment.TITLE: title,
        TFastPayment.MERCHANT_ID: merchant.id,
        TFastPayment.MERCHANT_NAME: merchant.name,
        TFastPayment.ACCOUNT: bill.account,
        TFastPayment.PAY_BILL: bill.requestJson,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void saveCards(List<AttachedCard> cardList) {
    database?.transaction((transaction) async {
      final batch = transaction.batch();

      cardList.forEach((item) {
        batch.insert(
          TCards.NAME,
          {
            TCards.ID: item.id,
            TCards.CARD_NAME: item.name,
            TCards.TYPE: item.type,
            TCards.P2P_ENABLED: (item.p2pEnabled ?? false) ? 1 : 0,
            TCards.MAIN: (item.isMain ?? false) ? 1 : 0,
            TCards.BALANCE: '${item.balance}',
            TCards.BANK_ID: item.bankId,
            TCards.COLOR_ID: item.color,
            TCards.ESTIMATED_LIMIT_IN: '${item.limitIn}',
            TCards.ESTIMATED_LIMIT_OUT: '${item.limitOut}',
            TCards.EXPARE_DATE: item.expDate,
            TCards.LOGIN: item.login,
            TCards.MASKED_PAN: item.number,
            TCards.PHONE: item.phone,
            TCards.MASKED_PHONE: item.maskedPhone,
            TCards.SMS: (item.sms ?? false) ? 1 : 0,
            TCards.ACTIVATED: item.activated,
            TCards.STATUS: item.status.toString(),
            TCards.TOKEN: item.token,
            TCards.ORDER: item.order,
            TCards.SUBSCRIBED: (item.subscribed ?? false) ? 1 : 0,
            TCards.SUBSCRIBE_LAST_DATE: item.subscribeLastDate,
            TCards.HIDDEN_BALANCE: (item.hiddenBalance ?? false) ? 1 : 0,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });

      return batch.commit(noResult: true);
    });
  }

  void saveCard(AttachedCard card) {
    database?.transaction((transaction) async {
      final batch = transaction.batch();

      batch.insert(
        TCards.NAME,
        {
          TCards.ID: card.id,
          TCards.CARD_NAME: card.name,
          TCards.TYPE: card.type,
          TCards.P2P_ENABLED: (card.p2pEnabled ?? false) ? 1 : 0,
          TCards.MAIN: (card.isMain ?? false) ? 1 : 0,
          TCards.BALANCE: '${card.balance}',
          TCards.BANK_ID: card.bankId,
          TCards.COLOR_ID: card.color,
          TCards.ESTIMATED_LIMIT_IN: '${card.limitIn}',
          TCards.ESTIMATED_LIMIT_OUT: '${card.limitOut}',
          TCards.EXPARE_DATE: card.expDate,
          TCards.LOGIN: card.login,
          TCards.MASKED_PAN: card.number,
          TCards.PHONE: card.phone,
          TCards.MASKED_PHONE: card.maskedPhone,
          TCards.SMS: (card.sms ?? false) ? 1 : 0,
          TCards.ACTIVATED: card.activated,
          TCards.STATUS: card.status.toString(),
          TCards.TOKEN: card.token,
          TCards.ORDER: card.order,
          TCards.SUBSCRIBED: (card.subscribed ?? false) ? 1 : 0,
          TCards.SUBSCRIBE_LAST_DATE: card.subscribeLastDate,
          TCards.HIDDEN_BALANCE: (card.hiddenBalance ?? false) ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return batch.commit(noResult: true);
    });
  }

  Future<List<AttachedCard>?> readStoredCards() async {
    final List<Map<String, dynamic>> result =
        (await database?.query(TCards.NAME) ?? []);

    homeData = MainData(
      cards: List.generate(
        result.length,
        (index) {
          final item = result[index];

          return AttachedCard(
            id: item[TCards.ID],
            type: item[TCards.TYPE],
            p2pEnabled: item[TCards.P2P_ENABLED] == 1,
            balance: double.parse(item[TCards.BALANCE]),
            bankId: item[TCards.BANK_ID],
            color: item[TCards.COLOR_ID],
            expDate: item[TCards.EXPARE_DATE],
            login: item[TCards.LOGIN],
            isMain: item[TCards.MAIN] == 1,
            number: item[TCards.MASKED_PAN],
            name: item[TCards.CARD_NAME],
            phone: item[TCards.PHONE],
            maskedPhone: item[TCards.MASKED_PHONE],
            sms: item[TCards.SMS] == 1,
            activated: item[TCards.ACTIVATED],
            status: CardStatus.values.singleWhereOrNull(
                (status) => status.toString() == item[TCards.STATUS]),
            token: item[TCards.TOKEN],
            order: item[TCards.ORDER],
            subscribeLastDate: item[TCards.SUBSCRIBE_LAST_DATE],
            subscribed: item[TCards.SUBSCRIBED] == 1,
            hiddenBalance: item[TCards.HIDDEN_BALANCE] == 1,
            viewTitle: item[TCards.TYPE] == Const.BONUS,
          );
        },
      ),
    );

    final cards = homeData?.cards;

    if (cards != null && cards.isNotEmpty) {
      cards.firstWhereOrNull((card) => card.type == Const.BONUS)?.viewTitle =
          true;

      final list = cards
          .where((card) => card.type != Const.BONUS)
          .toList(growable: false);

      if (list.isNotEmpty) {
        list.sort((one, two) {
          if (one.order == null || two.order == null) {
            return -1;
          }
          return one.order!.compareTo(two.order!);
        });
        list.first.viewTitle = true;
      }
    }

    return cards;
  }

  Future<int?> removeCards() async => await database?.delete(TCards.NAME);

  Future removeCard(String token) async => await database
      ?.delete(TCards.NAME, where: '${TCards.TOKEN} = ?', whereArgs: [token]);

  Future removeCardsByCondition(List<CardBalanceEntity> cards) async {
    String _notIn = '';
    cards.forEach((element) {
      _notIn += '"${element.token}", ';
    });

    if (cards.isEmpty) {
      await database?.delete(
        TCards.NAME,
        where: '${TCards.TYPE} != 5 and ${TCards.TOKEN}',
      );
    } else {
      await database?.delete(
        TCards.NAME,
        where:
            '${TCards.TYPE} != 5 and ${TCards.TOKEN} NOT IN (${_notIn.substring(0, _notIn.length - 2)})',
      );
    }

    await readStoredCards();
  }

  void updateCardsBalance(CardsBalanceEntity cardsBalanceEntity) {
    homeData?.totalBalance = cardsBalanceEntity.totalBalance / 100;
    cardsBalanceEntity.cardsBalance.forEach((cardBalance) {
      final card = homeData?.cards
          .firstWhereOrNull((card) => card.token == cardBalance.token);

      if (card != null) {
        card.balance = cardBalance.balance / 100;
        card.sms = cardBalance.sms;
        card.status = cardBalance.status;

        // обновление данный базы при условии если ранее авторизованный пользователь
        // залогинился под своей учёткой
        if (pref?.getLogin == pref?.loginedAccount) {
          database?.update(
            TCards.NAME,
            {
              TCards.BALANCE: '${card.balance}',
              TCards.SMS: card.sms ?? false ? 1 : 0,
              TCards.STATUS: card.status.toString(),
            },
            where: '${TCards.TOKEN} = ?',
            whereArgs: [card.token],
          );
        }
      }
    });
  }

  void updateCardsBalanceFromCardList(List<AttachedCard> cardList) {
    // пропуск обновления базы данных в случае входа с другой учётки
    if (pref?.getLogin != pref?.loginedAccount) return;

    cardList.forEach((card) {
      database?.update(
        TCards.NAME,
        {
          TCards.BALANCE: '${card.balance}',
          TCards.SMS: card.sms ?? false ? 1 : 0,
          TCards.STATUS: card.status.toString(),
        },
        where: '${TCards.TOKEN} = ?',
        whereArgs: [card.token],
      );
    });
  }

  Future<List<FavoriteEntity>> saveFavorites(
    List<dynamic> favoriteJsonList,
  ) async {
    final List<FavoriteEntity> result = [];

    await database?.transaction((transaction) async {
      final batch = transaction.batch();

      for (int i = 0; i < favoriteJsonList.length; i++) {
        final jsonItem = favoriteJsonList[i];

        final favoriteItem = FavoriteEntity.fromJson(jsonItem);

        /// TODO разобратья может ли быть null?

        favoriteItem.order ??= favoriteList
                .firstWhereOrNull((f) => f.id == favoriteItem.id)
                ?.order ??
            i + 1;

        result.add(favoriteItem);

        batch.insert(
          TFavorites.NAME,
          {
            TFavorites.ID: jsonItem['id'],
            TFavorites.TITLE: jsonItem['name'],
            TFavorites.BILL_ID: jsonItem['billId'],
            TFavorites.BILL: jsonItem['bill'],
            TFavorites.ORDER: favoriteItem.order,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      return await batch.commit(noResult: true);
    });

    return result;
  }

  Future<FavoriteEntity> saveFavorite(Map<String, dynamic> json) async {
    await database?.insert(
      TFavorites.NAME,
      {
        TFavorites.TITLE: json['name'],
        TFavorites.BILL: json['bill'],
        TFavorites.BILL_ID: json['billId'],
        TFavorites.ID: json['id'],
        TFavorites.ORDER: json['ord'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return FavoriteEntity.fromJson(json);
  }

  Future<FavoriteEntity> updateFavorite(Map<String, dynamic> json) async {
    await database?.update(
      TFavorites.NAME,
      {
        TFavorites.TITLE: json['name'],
        TFavorites.BILL: json['bill'],
        TFavorites.BILL_ID: json['billId'],
      },
      where: '${TFavorites.ID} = ?',
      whereArgs: [json['id']],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return FavoriteEntity.fromJson(json);
  }

  Future<void> updateFavoritesOrders() async {
    await database?.transaction((transaction) async {
      final batch = transaction.batch();

      favoriteList
          .where(
        (item) =>
            item.type == FPIType.MERCHANT || item.type == FPIType.TRANSFER,
      )
          .forEach((favorite) {
        batch.update(
          TFavorites.NAME,
          {
            TFavorites.ORDER: favorite.order,
          },
          where: '${TFavorites.ID} = ?',
          whereArgs: [favorite.id],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });

      return await batch.commit(noResult: true);
    });
  }

  Future<List<FavoriteEntity>> readStoredFavorites() async {
    final List<Map<String, dynamic>> result = (await database?.query(
          TFavorites.NAME,
          orderBy: TFavorites.ORDER,
        ) ??
        []);

    final List<FavoriteEntity> favorites = [];

    result.forEach((item) {
      favorites.add(
        FavoriteEntity(
          id: item[TFavorites.ID],
          bill: item[TFavorites.BILL],
          billId: item[TFavorites.BILL_ID],
          name: item[TFavorites.TITLE],
          order: item[TFavorites.ORDER],
        ),
      );
    });

    return favorites;
  }

  Future removeFavorite(int id) async => await database?.delete(
        TFavorites.NAME,
        where: '${TFavorites.ID} = ?',
        whereArgs: [id],
      );

  Future removeFavorites() async => await database?.delete(TFavorites.NAME);

  /// Проверяет, если ли сохранённые бины карт,
  /// если их нет, то они запрашиваются с сервера
  Future<bool> get isHaveCardBeans async {
    final List<Map<String, dynamic>> result =
        (await database?.query(TCardBean.NAME, limit: 1) ?? []);
    return result.isNotEmpty;
  }

  /// Сохранение бинов карт (узкард/хумо).
  ///
  /// Старые данные очищаются при перезаписи
  Future<void> storeCardBeans(Map<String, dynamic> beans) async {
    await database?.delete(TCardBean.NAME);

    await database?.transaction((transaction) async {
      final batch = transaction.batch();

      (beans['humo'] as List<dynamic>).forEach(
        (bean) => batch.insert(
          TCardBean.NAME,
          {
            TCardBean.CARD_TYPE: Const.HUMO,
            TCardBean.BEAN: bean,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        ),
      );

      (beans['uzcard'] as List<dynamic>).forEach(
        (bean) => batch.insert(
          TCardBean.NAME,
          {
            TCardBean.CARD_TYPE: Const.UZCARD,
            TCardBean.BEAN: bean,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        ),
      );

      return await batch.commit(noResult: true);
    });
  }

  Future<void> storeCardBeansAlternative(CardBeansEntity beans) async {
    await database?.delete(TCardBean.NAME);

    await database?.transaction((transaction) async {
      final batch = transaction.batch();

      (beans.humo)?.forEach(
        (bean) => batch.insert(
          TCardBean.NAME,
          {
            TCardBean.CARD_TYPE: Const.HUMO,
            TCardBean.BEAN: bean,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        ),
      );

      (beans.uzcard)?.forEach(
        (bean) => batch.insert(
          TCardBean.NAME,
          {
            TCardBean.CARD_TYPE: Const.UZCARD,
            TCardBean.BEAN: bean,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        ),
      );

      return await batch.commit(noResult: true);
    });
  }

  Future<List<CardBean>> readCardBeans() async {
    final List<Map<String, dynamic>> result =
        (await database?.query(TCardBean.NAME) ?? []);

    return List.generate(
      result.length,
      (index) => CardBean(
        cardType: result[index][TCardBean.CARD_TYPE] == Const.HUMO
            ? Const.HUMO
            : Const.UZCARD,
        bean: result[index][TCardBean.BEAN],
      ),
    );
  }

  Future<CardBeansEntity> readCardBeansAlternative() async {
    final List<Map<String, dynamic>> result =
        (await database?.query(TCardBean.NAME) ?? []);

    final List<String> humoBeans = [];
    final List<String> uzcardBeans = [];

    for (final element in result) {
      if (element[TCardBean.CARD_TYPE] == Const.HUMO) {
        humoBeans.add(element['bean']);
      } else {
        uzcardBeans.add(element['bean']);
      }
    }

    return CardBeansEntity(humo: humoBeans, uzcard: uzcardBeans);
  }

  Future clearAll() async {
    await clearMyAccounts();
    await removeCards();

    await database?.delete(TFastPayment.NAME);
    await database?.delete(TFavorites.NAME);
    await database?.delete(TCardBean.NAME);
  }
}
