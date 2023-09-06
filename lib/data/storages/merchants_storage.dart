import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

const _lastSelectedMerchantIdsKey = 'lastSelectedMerchantIdsKey';

@injectable
class MerchantsStorage {
  MerchantsStorage(this._storage);

  final Box _storage;

  Future<List<int>> restoreLastSelectedMerchantIds() async {
    return await _storage.get(_lastSelectedMerchantIdsKey) ?? [];
  }

  Future<void> storeLastSelectedMerchantId(int merchantId) async {
    final list = await restoreLastSelectedMerchantIds();
    if (list.contains(merchantId)) {
      list.remove(merchantId);
    } else if (list.length == 4) {
      list.removeAt(3);
    }
    list.insert(0, merchantId);

    await _storage.put(_lastSelectedMerchantIdsKey, list);
  }
}
