import 'package:get/get.dart';
import 'package:invoice/models/account.dart';
import 'package:invoice/utils/request.dart';
import 'package:invoice/utils/share_pref.dart';
import 'package:invoice/view_models/base_view_model.dart';
import 'package:invoice/view_models/dashboard_view_model/dashboard_invoices_view_model.dart';

import '../api/account_api.dart';
import '../enums/view_status.dart';
import '../utils/route_constrant.dart';
import '../widgets/other_dialogs/dialog.dart';
import 'invoice_view_model.dart';
import 'organization_view_model.dart';
import 'startup_view_model.dart';

class AccountViewModel extends BaseViewModel {
  AccountAPI accountAPI = AccountAPI();
  String? userId;
  Account? account;

  AccountViewModel() {
    getToken().then((value) => requestObj.setToken = value);
  }

  Future<Account?> onLogin(String username, String password) async {
    showLoadingDialog();
    try {
      account = await accountAPI.signIn(username, password);
      if (account == null) {
        showAlertDialog(
            title: 'Lỗi đăng nhập', content: 'Có lôi xảy ra khi đăng nhập');
        return account;
      }
      if (account?.status == 0) {
        requestObj.setToken = account?.accessToken;
        //BrandAdmin = 0,
        //SystemAdmin = 1,
        //Organization = 2,
        await setBrandId(account?.brandId ?? '');
        await setOrganizationId(account?.organizationId ?? '');
        await setUserId(account?.id);
        await setToken(account?.accessToken);
        switch (account!.role) {
          case 0:
            await Get.find<OrganizationViewModel>()
                .getOrganizationListByBrandId();
            break;
          case 2:
            await Get.find<OrganizationViewModel>().getStoreByOrganizationId();
            break;
          default:
            // Handle other cases if needed
            break;
        }
        getBrandId();
        hideDialog();
        Get.snackbar('Thông báo', 'Đăng nhập thành công');
        Get.offAllNamed(RouteHandler.HOME);
        notifyListeners();
      } else {
        Get.snackbar('Lỗi đăng nhập', 'Đã xảy ra lỗi');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Đã xảy ra lỗi khi đăng nhập');
    } finally {
      hideDialog();
    }
    return null;
  }

  //sign out
  Future<void> signOut() async {
    var option = await showConfirmDialog();
    if (option == true) {
      showLoadingDialog();
      userId = null;
      account = null;
      await removeALL();
      await Get.find<StartUpViewModel>().handleStartUpLogic();
      await Get.find<InvoiceViewModel>().removeAll();
      await Get.find<DashboardInvoiceViewModel>().removeAll();
      hideDialog();
    }
  }

  Future<Account?> checkUserIsLogged() async {
    try {
      account = await accountAPI.checkUserIsLogged();
      if (account != null) {
        notifyListeners();
        return account;
      } else {
        return null;
      }
    } catch (e) {
      print('Error checking user login status: $e');
      return null;
    } finally {}
  }

  Future<void> getAccountInfo(String id) async {
    try {
      setState(ViewStatus.Loading);
      account = await accountAPI.getAccountInfo(id);
      setState(ViewStatus.Completed);
      notifyListeners();
    } catch (e) {
      setState(ViewStatus.Error);
      showAlertDialog(title: "Lỗi", content: e.toString());
    }
  }
}
