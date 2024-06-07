import 'package:invoice/view_models/base_view_model.dart';

import '../api/invoice_template_api.dart';
import '../enums/view_status.dart';
import '../models/invoice_template.dart';

class InvoiceTemplateViewModel extends BaseViewModel {
  List<InvoiceTemplate>? invoiceTemplates = [];

  Future<void> loadInvoiceTemplatesByOrganizationId() async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));
      // Load invoice templates
      List<InvoiceTemplate>? invoiceFetch =
          await InvoiceTemplateAPI().getTemplateByOrganizationId();
      invoiceTemplates = invoiceFetch;
      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error, 'Failed to load invoice templates');
    }
  }
}
