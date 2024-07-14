import 'package:get/get.dart';
import 'package:invoice/view_models/base_view_model.dart';
import 'package:invoice/view_models/organization_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/account.dart';
import '../utils/route_constrant.dart';
import 'account_view_model.dart';

class StartUpViewModel extends BaseViewModel {
  StartUpViewModel() {
    handleStartUpLogic();
  }
  Future handleStartUpLogic() async {
    if (GetPlatform.isWeb && (GetPlatform.isAndroid || GetPlatform.isIOS)) {
      // final appId = GetPlatform.isIOS ? '6476899403' : 'com.reso.deercoffee';
      // final url = Uri.parse(GetPlatform.isIOS
      //     ? "https://apps.apple.com/us/app/deer-coffee/id$appId"
      //     : "https://play.google.com/store/apps/details?id=$appId");
      final url = Uri.parse('');
      launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
    await Future.delayed(const Duration(seconds: 1));
    _checkUserIsLogged();
  }

  Future<void> _checkUserIsLogged() async {
    Account? account = await Get.find<AccountViewModel>().checkUserIsLogged();
    if (account != null) {
      switch (account.role) {
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
      Get.toNamed(RouteHandler.HOME);
    } else {
      Get.offAllNamed(RouteHandler.LOGIN);
    }
  }
}
