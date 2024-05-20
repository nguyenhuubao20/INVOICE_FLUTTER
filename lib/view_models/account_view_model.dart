import 'package:get/get.dart';
import 'package:invoice/models/account.dart';
import 'package:invoice/utils/request.dart';
import 'package:invoice/utils/share_pref.dart';
import 'package:invoice/view_models/base_view_model.dart';

import '../api/account.dart';
import '../utils/route_constrant.dart';
import '../widgets/other_dialogs/dialog.dart';

class AccountViewModel extends BaseViewModel {
  AccountAPI accountAPI = AccountAPI();
  AccountViewModel() {
    getToken().then((value) => requestObj.setToken = value);
  }

  Future<void> onLogin(String username, String password) async {
    showLoadingDialog();
    try {
      Account? account = await accountAPI.signIn(username, password);
      if (account == null) {
        Get.snackbar('Lỗi đăng nhập', 'Không thể kết nối đến máy chủ');
        return;
      }
      // if (account.status == 200) {
        requestObj.setToken = account.accessToken;
        await setToken(account.accessToken);
        await getUserId(account.id);
        hideDialog();
        Get.snackbar('Thông báo', 'Đăng nhập thành công');
        Get.offAllNamed(RouteHandler.HOME);
      // } else {
      //   Get.snackbar('Lỗi đăng nhập', account.message ?? 'Đã xảy ra lỗi');
      // }
    } catch (e) {
      print('Đã xảy ra lỗi: $e');
      Get.snackbar('Lỗi', 'Đã xảy ra lỗi khi đăng nhập');
    } finally {
      hideDialog();
    }
  }
}
