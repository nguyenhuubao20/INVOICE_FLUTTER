import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoice/enums/date_format.dart';
import 'package:invoice/view_models/account_view_model.dart';

import '../../api/organization_api.dart';
import '../../enums/view_status.dart';
import '../../models/invoice_dashboard.dart';
import '../../widgets/other_dialogs/dialog.dart';
import '../base_view_model.dart';

class DashboardInvoiceViewModel extends BaseViewModel {
  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
  InvoiceReport? invoicetTotalReports;

  double maxInvoices = 0;
  double minInvoices = 0;

  String selectedKey = 'Hôm qua';
  int requestDays = 2;
  List<String> dateData = [];
  Map<String?, InvoiceReport?> chartData = {};

  void setRequestDays(int requestDays) {
    this.requestDays = requestDays;
    chartData.clear();
    getLastRequestDays();
    getInvoiceReporPaymenttByOrganizationDashBoard();
    notifyListeners();
  }

  void setSelectedKey(String key) {
    selectedKey = key;
    notifyListeners();
  }

  void setMinMaxInvoices(double min, double max) {
    minInvoices = min;
    maxInvoices = max;
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
    return dateData;
  }

  Future<void> getInvoiceReporPaymenttByOrganizationDashBoard() async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));
      DateFormat formatter = DateFormat('yyyy-MM-dd');

      for (String? dateString in dateData) {
        DateTime? date;
        if (dateString != null) {
          date = formatter.parse(dateString);
        }
        var invoiceReports =
            await OrganizationAPI().getInvoiceReportByOrganization(date, date);
        if (invoiceReports != null) {
          final dateFormat = DateFormatVN.formatDateDDMM("${dateString}");
          chartData[dateFormat] = invoiceReports;
        }
      }
      setMinMaxInvoices(getMinTotalInvoicesInDate().toDouble(),
          getMaxTotalInvoicesInDate().toDouble());
      setState(ViewStatus.Completed);
      notifyListeners();
    } catch (e) {
      setState(ViewStatus.Error, 'Failed to load invoice list');
    }
  }

  Future<void> getInvoiceReportByOrganization({
    DateTime? fromDate,
    DateTime? toDate,
    String errorMessage = 'Failed to load invoice list',
  }) async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));
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

  double getMaxTotalInvoicesInDate() {
    int max = 0;
    for (var entry in chartData.entries) {
      if (entry.value != null) {
        int totalAmount = entry.value!.totalInvoiceReportInDate ?? 0;
        if (totalAmount > max) {
          max = totalAmount;
        }
      }
    }
    return max.toDouble();
  }

  double getMinTotalInvoicesInDate() {
    int min = 0;
    for (var entry in chartData.entries) {
      if (entry.value != null) {
        int totalAmount = entry.value!.totalInvoiceReportInDate ?? 0;
        if (totalAmount < min) {
          min = totalAmount;
        }
      }
    }
    return min.toDouble();
  }
}
