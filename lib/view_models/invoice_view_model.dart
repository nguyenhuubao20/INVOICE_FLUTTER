import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoice/enums/invoice_status.dart';
import 'package:invoice/enums/view_status.dart';
import 'package:invoice/models/invoice.dart';
import 'package:invoice/models/invoice_history_partner.dart';
import 'package:invoice/view_models/account_view_model.dart';
import 'package:invoice/view_models/base_view_model.dart';
import 'package:invoice/widgets/other_dialogs/dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../api/invoice_api.dart';
import '../models/organization.dart';
import '../models/store.dart';
import '../utils/string_constrant.dart';

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
  String? selectedStatusStr = 'Tất cả';
  String? selectedDateStr;
  String? searchName;
  String? selectedStoreId;

  String? selectedOrganizationNameStr;
  String? selectedOrganizationId;

  int? selectedStatusIndex;

  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
  String? errorMessage;
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  int currentPage = 1;
  int totalPage = 0;

  Future<void> loadTotalPage(int t) async {
    totalPage = t;
  }

  void handleSelectedItem(dynamic selectedItem) {
    if (selectedItem is Store) {
      setStore(selectedItem.id, selectedItem.name);
    } else if (selectedItem is Organization) {
      setOrganization(selectedItem.id, selectedItem.name);
    }
    setInvoiceToDisplayed();
    // notifyListeners();
  }

  void setInvoiceToDisplayed() {
    loadInvoice();
    refreshController.requestRefresh();
    // notifyListeners();
  }

  void setStore(String? id, String? name) {
    selectedStoreId = id;
    selectedStoreNameStr = name;
    notifyListeners();
  }

  void setOrganization(String? id, String? name) {
    selectedOrganizationId = id;
    selectedOrganizationNameStr = name;
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

  Future<void> removeAll() async {
    selectedDate = null;
    selectedStoreNameStr = null;
    selectedOrganizationId = null;
    selectedOrganizationNameStr = null;
    selectedStatusStr = null;
    selectedDateStr = null;
    searchName = null;
    selectedStoreId = null;
    selectedStatusIndex = null;
    _invoiceList.clear();
    invoiceDetail?.clear();
    invoiceStatus.clear();
  }

  Future<void> onRefresh() async {
    final result = await loadInvoice(
      isRefresh: true,
    );
    if (result) {
      refreshController.refreshCompleted();
    } else {
      refreshController.refreshFailed();
    }
  }

  Future<void> onLoading() async {
    final result = await loadInvoice();
    if (result) {
      refreshController.loadComplete();
    } else {
      refreshController.loadNoData();
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
      await Future.delayed(const Duration(seconds: 1));
      int selectedStatusIndex = invoiceStatusFromString(selectedStatusStr);
      String? selectedDateStr = convertDateTimeToString(selectedDate);
      if (isRefresh) {
        currentPage = 1;
      } else {
        if (currentPage > totalPage) {
          refreshController.loadNoData();
          notifyListeners();
          setState(ViewStatus.Completed);
          return false;
        }
      }
      InvoiceResponse? invoiceResponse;
      if (selectedStoreId != null && selectedOrganizationId == null) {
        invoiceResponse = await InvoiceAPI().getInvoiceListByStoreId(
            currentPage,
            selectedStoreId,
            selectedDateStr,
            selectedStatusIndex,
            searchName);
      } else if (selectedOrganizationId != null && selectedStoreId == null) {
        invoiceResponse = await InvoiceAPI().getInvoiceListByOrganization(
            currentPage,
            selectedOrganizationId,
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
          default:
            invoiceResponse = await InvoiceAPI().getInvoicesByBrandAdmin(
                currentPage, selectedDateStr, selectedStatusIndex, searchName);
            break;
        }
      }

      if (invoiceResponse != null &&
          invoiceResponse.items != null &&
          invoiceResponse.items!.isNotEmpty) {
        List<Invoice> invoiceListToGet = List.from(invoiceResponse.items!)
          ..sort((a, b) => b.createdDate!.compareTo(a.createdDate!));

        loadTotalPage(invoiceResponse.totalPages ?? 0);
        currentPage++;
        if (isRefresh) {
          _invoiceList = invoiceListToGet;
        } else {
          _invoiceList.addAll(invoiceListToGet);
        }
        refreshController.loadComplete();
        setState(ViewStatus.Completed);
        notifyListeners();
        return true;
      } else {
        setState(ViewStatus.Empty, Message.emptyInvoiceList);
      }
    } catch (e) {
      setState(ViewStatus.Error, Message.errorLoadInvoice);
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
        setState(ViewStatus.Empty, Message.errorLoadInvoiceHistoryPartner);
      }
    } catch (e) {
      setState(ViewStatus.Error, Message.errorLoadInvoiceHistoryPartner);
      showAlertDialog(
          title: Message.error,
          content: Message.errorLoadInvoiceHistoryPartnerContent,
          confirmText: Message.confirm);
    }
  }

  Future<void> approvalInvoice(String invoiceId) async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));
      if (_accountViewModel.account!.role == 2) {
        await InvoiceAPI().approvalInvoice(invoiceId);
        showAlertDialog(
            title: Message.success,
            content: Message.approvalInvoiceSuccess,
            confirmText: Message.confirm);
        loadInvoice(isRefresh: true);
        notifyListeners();
        setState(ViewStatus.Completed);
      } else {
        showConfirmDialog(
            title: Message.error, content: Message.approvalInvoiceNoAccess);
        notifyListeners();
        setState(ViewStatus.Completed);
      }
    } catch (e) {
      String errorDescription = Message.approvalInvoiceError;
      showAlertDialog(
          title: Message.error,
          content: errorDescription,
          confirmText: Message.confirm);
      setState(ViewStatus.Error, errorDescription);
    }
  }

  Invoice? getInvoiceDetailSync(String invoiceId) {
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
