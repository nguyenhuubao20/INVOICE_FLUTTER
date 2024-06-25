import 'package:get/get.dart';
import 'package:invoice/models/organization.dart';
import 'package:invoice/view_models/account_view_model.dart';
import 'package:invoice/view_models/base_view_model.dart';

import '../api/brand_api.dart';
import '../enums/view_status.dart';

class BrandViewModel extends BaseViewModel {
  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
  List<Organization>? organizationList = [];

  Future<void> loadOrganizationList() async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));

      // Fetch organization list based on role 1
      organizationList = await BrandAPI().getStoreByBrandId();

      if (organizationList != null) {
        setState(ViewStatus.Completed);
        notifyListeners();
      } else {
        setState(ViewStatus.Error, 'Organization list not found');
      }
    } catch (e) {
      setState(ViewStatus.Error, 'Failed to load organization list: $e');
    }
  }
}
