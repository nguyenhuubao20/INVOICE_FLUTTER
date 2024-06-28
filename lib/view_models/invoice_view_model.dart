import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoice/enums/view_status.dart';
import 'package:invoice/models/invoice.dart';
import 'package:invoice/models/invoice_history_partner.dart';
import 'package:invoice/view_models/account_view_model.dart';
import 'package:invoice/view_models/base_view_model.dart';
import 'package:invoice/widgets/other_dialogs/dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../api/invoice_api.dart';

class InvoiceViewModel extends BaseViewModel {
  late Invoice _invoice;
  Invoice? get invoice => _invoice;

  List<Invoice> _invoiceList = [];
  List<Invoice> get invoiceList => _invoiceList;

  InvoiceHistoryPartner? _invoiceHistoryPartner = null;
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
        _invoiceList.sort((b, a) => a.createdDate!.compareTo(b.createdDate!));
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
        showAlertDialog(
            title: 'Error',
            content: 'Invoice History Partner is error',
            confirmText: 'OK');
      }
    } catch (e) {
      setState(ViewStatus.Error, 'Failed to load Invoice History Partner');
      showAlertDialog(
          title: 'Error',
          content: 'Invoice History Partner is error',
          confirmText: 'OK');
    }
  }

  Future<void> approvalInvoice(String invoiceId) async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));
      await InvoiceAPI().approvalInvoice(invoiceId);
      showAlertDialog(
          title: 'Success',
          content: 'Approval invoice successfully',
          confirmText: 'OK');
      setState(ViewStatus.Completed);
    } catch (e) {
      String errorDescription = 'Failed to load Invoice History Partner';
      showAlertDialog(
          title: 'Error', content: errorDescription, confirmText: 'OK');
      setState(ViewStatus.Error, errorDescription);
    }
  }

  Invoice? getInvoiceDetailSync(String invoiceId) {
    Invoice? invoice =
        invoiceList.firstWhere((element) => element.id == invoiceId);
    if (invoice != null && invoice.status != 5) {
      getInvoiceHistoryPartner(invoiceId);
    }
    return invoice;
  }

  List<Invoice> getInvoiceByStatus(int status) {
    return invoiceList.where((element) => element.status == status).toList();
  }

  List<Invoice> getInvoiceListByStoreIdSync(String? idStore) {
    return invoiceList.where((element) => element.storeId == idStore).toList();
  }

  List<Invoice> filterInvoicesByDate(DateTime selectedDate) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    return _invoiceList
        .where((invoice) => invoice.createdDate!.startsWith(formattedDate))
        .toList();
  }
}
