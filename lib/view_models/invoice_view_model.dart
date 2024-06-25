import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoice/enums/view_status.dart';
import 'package:invoice/models/invoice.dart';
import 'package:invoice/models/invoice_history_partner.dart';
import 'package:invoice/view_models/account_view_model.dart';
import 'package:invoice/view_models/base_view_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../api/invoice_api.dart';

class InvoiceViewModel extends BaseViewModel {
  late Invoice _invoice;
  Invoice? get invoice => _invoice;

  List<Invoice> _invoiceList = [];
  List<Invoice> get invoiceList => _invoiceList;

  late InvoiceHistoryPartner? _invoiceHistoryPartner;
  InvoiceHistoryPartner? get invoiceHistoryPartner => _invoiceHistoryPartner;

  List<InvoiceDetail>? invoiceDetail = [];
  List<String> invoiceStatus = [];
  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
  String? errorMessage;
  final RefreshController refreshController = RefreshController();

  int currentPage = 1;
  int totalPage = 0;

  Future<void> loadTotalPage(int t) async {
    totalPage = t;
  }

  Future<bool> loadInvoice(
      String? createDate, String? storeId, int? status, String? name,
      {bool isRefresh = false}) async {
    createDate ??= DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      if (isRefresh) {
        currentPage = 1;
      } else {
        if (currentPage > totalPage) {
          refreshController.loadNoData();
          return false;
        }
      }
      await Future.delayed(const Duration(seconds: 5));
      InvoiceResponse? invoiceResponse;
      if (storeId != null && storeId.isNotEmpty) {
        invoiceResponse = await InvoiceAPI()
            .getInvoiceListByStoreIdAndCreatedDateAndStatus(
                currentPage, storeId, createDate, status, name);
      } else {
        switch (_accountViewModel.account!.role) {
          case 1:
            invoiceResponse =
                await InvoiceAPI().getInvoicesBySystemAdmin(currentPage);
            break;
          case 2:
            invoiceResponse = await InvoiceAPI().getInvoicesByOrganizationAdmin(
                currentPage, createDate, status, name);
            break;
          case 0:
            invoiceResponse = await InvoiceAPI()
                .getInvoicesByBrandAdmin(currentPage, createDate, status, name);
            break;
          default:
            throw Exception('Unknown role');
        }
      }

      if (invoiceResponse != null &&
          invoiceResponse.items != null &&
          invoiceResponse.items!.isNotEmpty) {
        loadTotalPage(invoiceResponse.totalPages ?? 0);
        currentPage++;
        if (isRefresh) {
          _invoiceList = invoiceResponse.items!;
        } else {
          _invoiceList.addAll(invoiceResponse.items!);
        }
        _invoiceList.sort((a, b) => b.createdDate!.compareTo(a.createdDate!));
        setState(ViewStatus.Completed);
        notifyListeners();
        return true;
      } else {
        setState(ViewStatus.Empty, 'Invoice list is empty');
      }
    } catch (e) {
      setState(ViewStatus.Error, 'Failed to load invoice list: $e');
    }
    return false;
  }

  Future<void> getInvoiceHistoryPartner(String invoiceId) async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));
      _invoiceHistoryPartner =
          (await InvoiceAPI().getInvoiceHistoryPartner(invoiceId))!;
      if (_invoiceHistoryPartner != null) {
        setState(ViewStatus.Completed);
        notifyListeners();
      } else {
        setState(ViewStatus.Error, 'Invoice History Partner not found');
      }
    } catch (e) {
      setState(ViewStatus.Error, 'Failed to load Invoice History Partner');
    }
  }

  Invoice? getInvoiceDetailSync(String invoiceId) {
    getInvoiceHistoryPartner(invoiceId);
    return invoiceList.firstWhere((element) => element.id == invoiceId);
  }

  List<Invoice> getInvoiceByStatus(int status) {
    return invoiceList.where((element) => element.status == status).toList();
  }

  List<Invoice> getInvoiceListByStoreIdSync(String? idStore) {
    return invoiceList.where((element) => element.storeId == idStore).toList();
  }
}
