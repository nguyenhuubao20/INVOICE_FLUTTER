import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoice/view_models/account_view_model.dart';
import 'package:invoice/view_models/invoice_view_model.dart';

import '../../api/brand_api.dart';
import '../../api/organization_api.dart';
import '../../enums/view_status.dart';
import '../../models/invoice_dashboard.dart';
import '../../widgets/other_dialogs/dialog.dart';
import '../base_view_model.dart';

class DashboardRevenueViewModel extends BaseViewModel {
  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
  final InvoiceViewModel _invoiceViewModel = Get.find<InvoiceViewModel>();
  List<InvoicePaymentReport>? revenueReports;

  DateTime? selectedFromDate;
  DateTime? selectedToDate;

  double maxRevenue = 0;
  double minRevenue = 0;

  double totalTaxAmount = 0.0;
  double totalAmountAfterTax = 0.0;
  double totalSaleAmount = 0.0;
  double totalDiscountAmount = 0.0;
  double totalAmountWithoutTax = 0.0;
  double totalAmount = 0.0;

  Map<String?, double> chartData = {};
  List<MapEntry<String, InvoicePaymentReport>> dateReportPairs = [];
  final DateFormat formatter = DateFormat('dd/MM');

  // Setters for dates
  void setSelectedFromDate(DateTime? fromDate) {
    selectedFromDate = fromDate;
    if (selectedFromDate != null && selectedToDate == null) {
      return;
    } else {
      if (selectedToDate != null &&
          selectedToDate!.isBefore(selectedFromDate!)) {
        showMessageDialog(
            title: 'Thông báo',
            message: 'Ngày kết thúc không thể nhỏ hơn ngày bắt đầu');
      } else {
        getRevenueDashboard();
      }
    }
    notifyListeners();
  }

  void setSelectedToDate(DateTime? toDate) {
    selectedToDate = toDate;
    if (selectedToDate != null && selectedFromDate != null) {
      if (selectedToDate!.isBefore(selectedFromDate!)) {
        showMessageDialog(
            title: 'Thông báo',
            message: 'Ngày kết thúc không thể nhỏ hơn ngày bắt đầu');
      } else {
        getRevenueDashboard();
      }
    }
    notifyListeners();
  }

  Future<void> getRevenueDashboard() async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));
      if (_accountViewModel.account?.role == 2) {
        revenueReports = await OrganizationAPI().getOrganizationReportRevenue(
            selectedFromDate,
            selectedToDate,
            _invoiceViewModel.selectedStoreId);
      } else if (_accountViewModel.account?.role == 0) {
        revenueReports = await BrandAPI().getBrandReportRevenue(
            selectedFromDate,
            selectedToDate,
            _invoiceViewModel.selectedOrganizationId);
      }
      chartData.clear();
      dateReportPairs.clear();
      reset();
      for (var report in revenueReports!) {
        DateTime? reportDate = report.date;
        if (reportDate != null) {
          String formattedDate = formatter.format(reportDate);
          double totalAmountValue = report.totalAmountReport?.toDouble() ?? 0.0;
          chartData[formattedDate] = totalAmountValue;
          dateReportPairs.add(MapEntry(formattedDate, report));
        }
      }
      getTotalInvoiceReportDetails(revenueReports);
      setState(ViewStatus.Completed);
      notifyListeners();
    } catch (e) {
      setState(ViewStatus.Error, 'Failed to load invoice list');
    }
  }

  void getTotalInvoiceReportDetails(List<InvoicePaymentReport>? revenueDetail) {
    if (revenueDetail == null || revenueDetail.isEmpty) return;

    for (var report in revenueDetail) {
      totalTaxAmount += report.totalTaxAmountReport ?? 0;
      totalAmountAfterTax += report.totalAmountAfterTaxReport ?? 0;
      totalSaleAmount += report.totalSaleAmountReport ?? 0;
      totalDiscountAmount += report.totalDiscountAmountReport ?? 0;
      totalAmountWithoutTax += report.totalAmountWithoutTaxReport ?? 0;
      totalAmount += report.totalAmountReport ?? 0;
    }
  }

  void reset() {
    maxRevenue = 0;
    minRevenue = 0;
    selectedFromDate = null;
    selectedToDate = null;
    totalTaxAmount = 0.0;
    totalAmountAfterTax = 0.0;
    totalSaleAmount = 0.0;
    totalDiscountAmount = 0.0;
    totalAmountWithoutTax = 0.0;
    totalAmount = 0.0;
    notifyListeners();
  }

  Future<void> removeAll() async {
    revenueReports = null;
    maxRevenue = 0;
    minRevenue = 0;
    selectedFromDate = null;
    selectedToDate = null;
    totalTaxAmount = 0.0;
    totalAmountAfterTax = 0.0;
    totalSaleAmount = 0.0;
    totalDiscountAmount = 0.0;
    totalAmountWithoutTax = 0.0;
    totalAmount = 0.0;
    chartData.clear();
    dateReportPairs.clear();
  }
}
