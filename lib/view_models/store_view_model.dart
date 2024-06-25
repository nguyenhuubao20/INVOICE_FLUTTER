import 'package:invoice/view_models/base_view_model.dart';

import '../api/brand_api.dart';
import '../enums/view_status.dart';
import '../models/store.dart';

class StoreViewModel extends BaseViewModel {
  List<Store> _storeList = [];
  List<Store> get storeList => _storeList;

  Store _store = Store();
  Store get store => _store;

  Future<void> getStorById(String? storeId) async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));
      _store = (await BrandAPI().getStoreById(storeId))!;
      setState(ViewStatus.Completed);
      notifyListeners();
    } catch (e) {
      setState(ViewStatus.Error, 'Failed to load store: $e');
    }
  }

  Store? getStoreByName(String name) {
    return _storeList.firstWhere((store) => store.name == name);
  }
}
