import 'package:get/get.dart';
import 'package:invoice/view_models/account_view_model.dart';
import 'package:invoice/view_models/brand_view_model.dart';
import 'package:invoice/view_models/dashboard_view_model.dart';
import 'package:invoice/view_models/invoice_template_view_model.dart';
import 'package:invoice/view_models/invoice_view_model.dart';
import 'package:invoice/view_models/organization_view_model.dart';
import 'package:invoice/view_models/store_view_model.dart';

import 'view_models/startup_view_model.dart';
import 'view_models/theme_view_model.dart';

void createRouteBindings() {
  Get.put(StartUpViewModel());
  Get.put(ThemeViewModel());
  Get.put(AccountViewModel());
  Get.put(InvoiceViewModel());
  Get.put(StoreViewModel());
  Get.put(BrandViewModel());
  Get.put(OrganizationViewModel());
  Get.put(InvoiceTemplateViewModel());
  Get.put(DashboardViewModel());
}
