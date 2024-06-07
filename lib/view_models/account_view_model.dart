import 'package:get/get.dart';
import 'package:invoice/models/account.dart';
import 'package:invoice/utils/request.dart';
import 'package:invoice/utils/share_pref.dart';
import 'package:invoice/view_models/base_view_model.dart';
import 'package:invoice/view_models/startup_view_model.dart';

import '../api/account_api.dart';
import '../enums/view_status.dart';
import '../utils/route_constrant.dart';
import '../widgets/other_dialogs/dialog.dart';

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
        Get.snackbar('Lỗi đăng nhập', 'Không tìm thấy tài khoản');
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
        getBrandId();
        hideDialog();
        Get.snackbar('Thông báo', 'Đăng nhập thành công');
        Get.offAllNamed(RouteHandler.HOME);
      } else {
        Get.snackbar('Lỗi đăng nhập', 'Đã xảy ra lỗi');
      }
    } catch (e) {
      print('Đã xảy ra lỗi: $e');
      Get.snackbar('cccccc', 'Đã xảy ra lỗi khi đăng nhập');
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
    }
  }

  Future<void> getAccountInfo(String id) async {
    try {
      setState(ViewStatus.Loading);
      account = await accountAPI.getAccountInfo(id);
      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error);
      showAlertDialog(title: "Lỗi", content: e.toString());
    }
  }
}
