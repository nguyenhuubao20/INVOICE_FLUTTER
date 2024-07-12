import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoice/enums/date_format.dart';
import 'package:invoice/view_models/account_view_model.dart';

import '../../api/organization_api.dart';
import '../../enums/view_status.dart';
import '../../models/invoice.dart';
import '../../widgets/other_dialogs/dialog.dart';
import '../base_view_model.dart';

class DashboardRevenueViewModel extends BaseViewModel {
  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
  InvoicePaymentReport? revenueTotalReports;

  double maxRevenue = 0;
  double minRevenue = 0;

  String selectedKey = 'Tuần này';
  int requestDays = 7;
  List<String> dateData = [];
  List<String> data = [];
  Map<String?, InvoicePaymentReport?> chartData = {};

  void setRequestDays(int requestDays) {
    this.requestDays = requestDays;
    chartData.clear();
    getLastRequestDays();
    getRevenueReportByOrganizationDashboard();
    notifyListeners();
  }

  void setSelectedKey(String key) {
    selectedKey = key;
    notifyListeners();
  }

  void setMinMaxRevenue(double min, double max) {
    minRevenue = min;
    maxRevenue = max;
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

  Future<void> getRevenueReportByOrganizationDashboard() async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));
      DateFormat formatter = DateFormat('yyyy-MM-dd');

      if (dateData.isEmpty) {
        var revenueReports = await OrganizationAPI()
            .getInvoiceReportPaymentByOrganization(null, null);
        if (revenueReports != null) {
          addRevenueReportData(revenueReports);
          setState(ViewStatus.Completed);
        } else {
          setState(ViewStatus.Error, 'Revenue list not found');
        }
        return;
      }

      for (String? dateString in dateData) {
        DateTime? date;
        if (dateString != null) {
          date = formatter.parse(dateString);
        }
        var revenueReports = await OrganizationAPI()
            .getInvoiceReportPaymentByOrganization(date, date);
        if (revenueReports != null) {
          addRevenueReportData(revenueReports);
          final dateFormat = DateFormatVN.formatDateDDMM("${dateString}");
          chartData[dateFormat] = revenueReports;
        }
      }

      if (data.isNotEmpty) {
        this.data = data;
        notifyListeners();
        setState(ViewStatus.Completed);
      } else {
        setState(ViewStatus.Error, 'Revenue list not found');
      }
    } catch (e) {
      setState(ViewStatus.Error, 'Failed to load revenue list');
    }
  }

  void addRevenueReportData(InvoicePaymentReport revenueReports) {
    data.add(revenueReports.totalInvoiceReportInDate.toString());
  }

  Future<void> getRevenueReportByOrganization(
      {DateTime? fromDate,
      DateTime? toDate,
      String errorMessage = 'Failed to load revenue list',
      Duration delay = const Duration(seconds: 1)}) async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(delay);

      if (_accountViewModel.account?.role == 2) {
        revenueTotalReports = await OrganizationAPI()
            .getInvoiceReportPaymentByOrganization(fromDate, toDate);
        if (revenueTotalReports != null) {
          setMinMaxRevenue(getMinTotalRevenueInDate().toDouble(),
              getMaxTotalRevenueInDate().toDouble());
          notifyListeners();
          setState(ViewStatus.Completed);
        } else {
          setState(ViewStatus.Error, 'Revenue list not found');
        }
      } else {
        showAlertDialog(
          title: 'Error',
          content: 'You have no access to load this data',
        );
      }
    } catch (e, stackTrace) {
      log('Error loading revenue report: $e', stackTrace: stackTrace);
      setState(ViewStatus.Error, errorMessage);
    }
  }

  int getMaxTotalRevenueInDate() {
    int max = 0;
    for (var entry in chartData.entries) {
      if (entry.value != null) {
        int totalAmount = entry.value!.totalInvoiceReportInDate ?? 0;
        if (totalAmount > max) {
          max = totalAmount;
        }
      }
    }
    return max;
  }

  int getMinTotalRevenueInDate() {
    int min = 0;
    for (var entry in chartData.entries) {
      if (entry.value != null) {
        int totalAmount = entry.value!.totalInvoiceReportInDate ?? 0;
        if (totalAmount < min) {
          min = totalAmount;
        }
      }
    }
    return min;
  }
}
