import 'package:get/get.dart';
import 'package:invoice/view_models/account_view_model.dart';
import 'package:invoice/view_models/invoice_view_model.dart';

import 'view_models/startup_view_model.dart';

void createRouteBindings() {
  Get.put(StartUpViewModel());
  Get.put(InvoiceViewModel());
  Get.put(AccountViewModel());
}
