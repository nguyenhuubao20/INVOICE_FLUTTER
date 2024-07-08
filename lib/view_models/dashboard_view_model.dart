import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoice/models/invoice.dart';
import 'package:invoice/view_models/account_view_model.dart';

import '../api/organization_api.dart';
import '../enums/view_status.dart';
import '../widgets/other_dialogs/dialog.dart';
import 'base_view_model.dart';

class DashboardViewModel extends BaseViewModel {
  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
  InvoiceReport? invoiceReports;
  InvoiceReport? invoicetTotalReports;

  String? selectedStatus = 'draft';
  int requestDays = 1;
  List<String> dateData = [];
  List<String> data = [];
  Map<String?, InvoiceReport?> chartData = {};

  void setRequestDays(int requestDays) {
    this.requestDays = requestDays;
    chartData.clear();
    getLastRequestDays();
    getInvoiceReportByOrganizationDashBoard();
    notifyListeners();
  }

  void setSelectedStatus(String status) {
    selectedStatus = status;
    notifyListeners();
  }

  List<String> getLastRequestDays() {
    dateData.clear();
    if (requestDays == 0) {
      return [];
    }

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    for (int i = requestDays - 1; i >= 0; i--) {
      DateTime date = now.subtract(Duration(days: i));
      String formattedDate = formatter.format(date);
      dateData.add(formattedDate);
    }
    notifyListeners();
    return dateData;
  }

  Future<void> getInvoiceReportByOrganizationDashBoard() async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));
      DateFormat formatter = DateFormat('yyyy-MM-dd');

      if (dateData.isEmpty) {
        var invoiceReports =
            await OrganizationAPI().getInvoiceReportByOrganization(null, null);
        if (invoiceReports != null) {
          addInvoiceReportData(invoiceReports);
          setState(ViewStatus.Completed);
        } else {
          setState(ViewStatus.Error, 'Invoice list not found');
        }
        return;
      }

      for (String? dateString in dateData) {
        DateTime? date;
        if (dateString != null) {
          date = formatter.parse(dateString);
        }
        var invoiceReports =
            await OrganizationAPI().getInvoiceReportByOrganization(date, date);
        if (invoiceReports != null) {
          addInvoiceReportData(invoiceReports);
          final dateFormat =
              DateFormat('d MMMM').format(DateTime.parse(dateString!));
          chartData[dateFormat] = invoiceReports;
        }
      }

      if (data.isNotEmpty) {
        this.data = data;
        notifyListeners();
        setState(ViewStatus.Completed);
      } else {
        setState(ViewStatus.Error, 'Invoice list not found');
      }
    } catch (e) {
      setState(ViewStatus.Error, 'Failed to load invoice list');
    }
  }

  void addInvoiceReportData(InvoiceReport invoiceReports) {
    switch (selectedStatus) {
      case 'draft':
        data.add(invoiceReports.draft.toString());
        break;
      case 'success':
        data.add(invoiceReports.success.toString());
        break;
      case 'sent':
        data.add(invoiceReports.sent.toString());
        break;
      case 'pendingApproval':
        data.add(invoiceReports.pendingApproval.toString());
        break;
      case 'completed':
        data.add(invoiceReports.completed.toString());
        break;
      case 'failed':
        data.add(invoiceReports.failed.toString());
        break;
      case 'pending':
        data.add(invoiceReports.pending.toString());
        break;
      case 'retryPending':
        data.add(invoiceReports.retryPending.toString());
        break;
      default:
        data.add(invoiceReports.replaced.toString());
        break;
    }
  }

  Future<void> getInvoiceReportByOrganization(
      {DateTime? fromDate,
      DateTime? toDate,
      String errorMessage = 'Failed to load invoice list',
      Duration delay = const Duration(seconds: 1)}) async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(delay);

      if (_accountViewModel.account?.role == 2) {
        invoicetTotalReports = await OrganizationAPI()
            .getInvoiceReportByOrganization(fromDate, toDate);
        if (invoicetTotalReports != null) {
          setState(ViewStatus.Completed);
          notifyListeners();
        } else {
          setState(ViewStatus.Error, 'Invoice list not found');
        }
      } else {
        showAlertDialog(
          title: 'Error',
          content: 'You have no access to load this data',
        );
      }
    } catch (e, stackTrace) {
      log('Error loading invoice report: $e', stackTrace: stackTrace);
      setState(ViewStatus.Error, errorMessage);
    }
  }
}
