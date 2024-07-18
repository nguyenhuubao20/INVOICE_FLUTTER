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

class DashboardRevenueViewModel extends BaseViewModel {
  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
  InvoicePaymentReport? revenueTotalReports;

  double maxRevenue = 0;
  double minRevenue = 0;

  String selectedKey = 'Hôm qua';
  int requestDays = 2;
  List<String> dateData = [];
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
    return dateData;
  }

  Future<void> getRevenueReportByOrganizationDashboard() async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));
      DateFormat formatter = DateFormat('yyyy-MM-dd');

      for (String? dateString in dateData) {
        DateTime? date;
        if (dateString != null) {
          date = formatter.parse(dateString);
        }
        var revenueReports = await OrganizationAPI()
            .getInvoiceReportPaymentByOrganization(date, date);
        if (revenueReports != null) {
          final dateFormat = DateFormatVN.formatDateDDMM("${dateString}");
          chartData[dateFormat] = revenueReports;
        } else {
          final dateFormat = DateFormatVN.formatDateDDMM("${dateString}");
          chartData[dateFormat] = InvoicePaymentReport.empty();
        }
      }
      setMinMaxRevenue(getMinTotalRevenueInDate().toDouble(),
          getMaxTotalRevenueInDate().toDouble());
      setState(ViewStatus.Completed);
      notifyListeners();
    } catch (e) {
      setState(ViewStatus.Error, 'Failed to load revenue list');
    }
  }

  Future<void> getRevenueReportByOrganization({
    DateTime? fromDate,
    DateTime? toDate,
    String errorMessage = 'Failed to load revenue list',
  }) async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));
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

  double getMaxTotalRevenueInDate() {
    double max = 0;
    for (var entry in chartData.entries) {
      if (entry.value != null) {
        double totalAmount = entry.value!.totalAmountReport ?? 0;
        if (totalAmount > max) {
          max = totalAmount;
        }
      }
    }
    return max.toDouble();
  }

  double getMinTotalRevenueInDate() {
    double min = 0;
    for (var entry in chartData.entries) {
      if (entry.value != null) {
        double totalAmount = entry.value!.totalAmountReport ?? 0;
        if (totalAmount < min) {
          min = totalAmount;
        }
      }
    }
    return min.toDouble();
  }
}
