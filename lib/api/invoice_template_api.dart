import 'package:get/get.dart';
import 'package:invoice/utils/route_constrant.dart';
import 'package:invoice/widgets/other_dialogs/dialog.dart';

import '../models/invoice_template.dart';
import '../utils/request.dart';
import '../utils/share_pref.dart';

class InvoiceTemplateAPI {
  static int page = 1;
  static int size = 10;

  Future<List<InvoiceTemplate>?> getTemplateByOrganizationId() async {
    try {
      final organizationId = await getOrganizationId();
      if (organizationId == "") {
        showAlertDialog(
            title: 'Error', content: 'You have no access to do this');
        return Get.offAllNamed(RouteHandler.HOME);
      }
      var params = {
        'id': organizationId,
        'page': page,
        'size': size,
      };
      final res = await request.get('organizations/$organizationId/templates',
          queryParameters: params);
      if (res.statusCode == 200) {
        List<dynamic> jsonList = res.data['items'];
        List<InvoiceTemplate> invoiceTemplates =
            jsonList.map((json) => InvoiceTemplate.fromJson(json)).toList();
        return invoiceTemplates;
      } else {
        throw Exception('Failed to load invoices: ${res.statusCode}');
      }
    } catch (e) {
      showAlertDialog(title: 'Error', content: 'You have no access to do this', confirmText: "OK");
      return null;
    }
  }
}
