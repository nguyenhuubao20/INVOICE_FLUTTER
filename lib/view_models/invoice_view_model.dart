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

  DateTime? selectedDate;

  String? selectedStoreNameStr;
  String? selectedStatusStr;
  String? selectedDateStr;
  String? searchName;
  String? selectedStoreId;

  int? selectedStatusIndex;

  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
  String? errorMessage;
  final RefreshController refreshController = RefreshController();

  int currentPage = 1;
  int totalPage = 0;

  Future<void> loadTotalPage(int t) async {
    totalPage = t;
  }

  void setStore(String? id, String? name) {
    selectedStoreId = id;
    selectedStoreNameStr = name;
    notifyListeners();
  }

  void resetStore() {
    selectedStoreId = null;
    selectedStoreNameStr = null;
    notifyListeners();
  }

  void setSelectedStatus(String? status) {
    selectedStatusStr = status;
    notifyListeners();
  }

  void setSelectedDate(DateTime? date) {
    selectedDate = date;
    notifyListeners();
  }

  void setSearchedName(String? name) {
    searchName = name;
    notifyListeners();
  }

  int convertStatusToInt(String? newStatus) {
    switch (newStatus) {
      case 'Draft':
        return 0;
      case 'Success':
        return 1;
      case 'Sent':
        return 2;
      case 'Pending Approval':
        return 3;
      case 'Completed':
        return 4;
      case 'Failed':
        return 5;
      case 'Pending':
        return 6;
      case 'RetryPending':
        return 7;
      default:
        return -1;
    }
  }

  String? convertDateTimeToString(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }
    return null;
  }

  Future<bool> loadInvoice({bool isRefresh = false}) async {
    try {
      // setState(ViewStatus.Loading);
      int selectedStatusIndex = convertStatusToInt(selectedStatusStr);
      String? selectedDateStr = convertDateTimeToString(selectedDate);
      if (isRefresh) {
        currentPage = 1;
      } else {
        if (currentPage > totalPage) {
          refreshController.loadNoData();
          notifyListeners();
          return false;
        }
      }
      // await Future.delayed(Duration(milliseconds: 100));
      InvoiceResponse? invoiceResponse;
      if (selectedStoreId != null) {
        invoiceResponse = await InvoiceAPI()
            .getInvoiceListByStoreIdAndCreatedDateAndStatus(
                currentPage,
                selectedStoreId,
                selectedDateStr,
                selectedStatusIndex,
                searchName);
      } else {
        switch (_accountViewModel.account!.role) {
          case 1:
            invoiceResponse =
                await InvoiceAPI().getInvoicesBySystemAdmin(currentPage);
            break;
          case 2:
            invoiceResponse = await InvoiceAPI().getInvoicesByOrganizationAdmin(
                currentPage, selectedDateStr, selectedStatusIndex, searchName);
            break;
          case 0:
            invoiceResponse = await InvoiceAPI().getInvoicesByBrandAdmin(
                currentPage, selectedDateStr, selectedStatusIndex, searchName);
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
    /// FAILED VOI DRAFT THI TRA VE PARTNER
    Invoice? invoice =
        invoiceList.firstWhere((element) => element.id == invoiceId);
    if (invoice.status == 1) {
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
