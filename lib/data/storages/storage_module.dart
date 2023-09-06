import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/hive/payment/category_hive_object.dart';
import 'package:mobile_ultra/data/hive/payment/merchant_hive_object.dart';
import 'package:mobile_ultra/data/storages/database.dart';
import 'package:mobile_ultra/data/storages/preference.dart';

@module
abstract class DBModule {
  @Singleton(dispose: disposeDb)
  @factoryMethod
  Future<MUDatabase> createDb() async {
    final database = MUDatabase();
    await database.open();
    return database;
  }

  @Singleton()
  @factoryMethod
  Future<Preference> createPrefs() async {
    final preference = Preference();
    await preference.init();
    return preference;
  }

  @preResolve
  @singleton
  Future<Box> createHive() async {
    Hive.registerAdapter(CategoryHiveObjectAdapter());
    Hive.registerAdapter(MerchantHiveObjectAdapter());
    await Hive.openBox<CategoryHiveObject>('paynet_payment_categories');
    await Hive.openBox<MerchantHiveObject>('paynet_merchants');
    return Hive.openBox('paynet_storage');
  }
}

Future disposeDb(MUDatabase database) {
  return database.close();
}
