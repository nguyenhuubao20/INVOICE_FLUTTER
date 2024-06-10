import 'package:get/get.dart';
import 'package:invoice/enums/view_status.dart';
import 'package:invoice/models/invoice.dart';
import 'package:invoice/view_models/account_view_model.dart';
import 'package:invoice/view_models/base_view_model.dart';

import '../api/invoice_api.dart';
import '../enums/invoice_status.dart';

class InvoiceViewModel extends BaseViewModel {
  late Invoice _invoice;
  Invoice? get invoice => _invoice;
  List<Invoice>? invoiceList = [];
  List<InvoiceDetail>? invoiceDetail = [];
  List<String> invoiceStatus = [];
  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();

  Future<void> loadInvoice() async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));
      switch (_accountViewModel.account!.role) {
        case 1:
          invoiceList = await InvoiceAPI().getInvoicesBySystemAdmin();
          break;
        case 2:
          invoiceList = await InvoiceAPI().getInvoicesByOrganizationAdmin();
          break;
        case 0:
          invoiceList = await InvoiceAPI().getInvoicesByBrandAdmin();
          break;
      }

      if (invoiceList != null) {
        await getInvoiceStatus();
        setState(ViewStatus.Completed);
      } else {
        setState(ViewStatus.Error, 'Invoice list not found');
      }
    } catch (e) {
      setState(ViewStatus.Error, 'Failed to load invoice list');
    }
  }

  Future<void> loadInvoiceDetail(String invoiceId) async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));
      invoiceList = await InvoiceAPI().getInvoicesBySystemAdmin();
      _invoice = invoiceList!.firstWhere((element) => element.id == invoiceId);
      if (_invoice != null) {
        setState(ViewStatus.Completed);
      } else {
        setState(ViewStatus.Error, 'Invoice not found');
      }
    } catch (e) {
      setState(ViewStatus.Error, 'Failed to load invoice details');
    }
  }

  Invoice? getInvoiceDetailSync(String invoiceId) {
    return invoiceList!.firstWhere((element) => element.id == invoiceId);
  }

  List<Invoice> getInvoiceByStatus(int status) {
    return invoiceList!.where((element) => element.status == status).toList();
  }

  Future<void> getInvoiceStatus() async {
    if (invoiceList != null) {
      final distinctStatuses = invoiceList!
          .map((e) => invoiceStatusFromString(e.status))
          .toSet()
          .toList();

      invoiceStatus = distinctStatuses;
    } else {
      invoiceStatus = [];
    }
  }

  // Future<List<Invoice?>> getInvoiceListByStoreId(String? idStore) async {
  //   try {
  //     setState(ViewStatus.Loading);
  //     await Future.delayed(const Duration(seconds: 2));
  //     invoiceList = await InvoiceAPI().getInvoiceListByStoreId(idStore);
  //     if (invoiceList != null) {
  //       setState(ViewStatus.Completed);
  //       return invoiceList!;
  //     } else {
  //       setState(ViewStatus.Error, 'Invoice list not found');
  //       return [];
  //     }
  //   } catch (e) {
  //     setState(ViewStatus.Error, 'Failed to load invoice list');
  //     return [];
  //   }
  // }

  List<Invoice> getInvoiceListByStoreIdSync(String? idStore) {
    return invoiceList!.where((element) => element.storeId == idStore).toList();
  }
}
