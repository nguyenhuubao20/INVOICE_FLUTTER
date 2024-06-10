import 'package:get/get.dart';
import 'package:invoice/view_models/account_view_model.dart';
import 'package:invoice/view_models/base_view_model.dart';
import 'package:invoice/widgets/other_dialogs/dialog.dart';

import '../api/organization_api.dart';
import '../enums/view_status.dart';
import '../models/store.dart';

class OrganizationViewModel extends BaseViewModel {
  late Store _store;
  Store? get store => _store;
  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
  List<Store>? storeList = [];
  List<String>? storeNames = [];

  Future<void> getStoreByOrganizationId() async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));
      if (_accountViewModel.account!.role == 2) {
        storeList = await OrganizationAPI().getStoreByOrganizationId();
        getStoreNames();
        if (storeList != null) {
          setState(ViewStatus.Completed);
        } else {
          setState(ViewStatus.Error, 'Invoice list not found');
        }
      } else {
        showAlertDialog(
            title: 'Error', content: 'You have no access to load store list');
      }
    } catch (e) {
      setState(ViewStatus.Error, 'Failed to load invoice list');
    }
  }

  List<String>? getStoreNames() {
    return storeList!.map((e) => e.name!).toList();
  }
}
