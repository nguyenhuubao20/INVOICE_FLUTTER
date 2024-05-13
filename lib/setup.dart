import 'package:get/get.dart';

import 'view_models/startup_view_model.dart';

void createRouteBindings() {
  Get.put(StartUpViewModel());
  // Get.put(MenuViewModel());
  // Get.put(AccountViewModel());
  // Get.put(CartViewModel());
  // Get.put(OrderViewModel());
}