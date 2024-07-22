import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoice/api/brand_api.dart';
import 'package:invoice/view_models/account_view_model.dart';
import 'package:invoice/widgets/other_dialogs/dialog.dart';

import '../../api/organization_api.dart';
import '../../enums/view_status.dart';
import '../../models/invoice_dashboard.dart';
import '../base_view_model.dart';
import '../invoice_view_model.dart';

class DashboardInvoiceViewModel extends BaseViewModel {
  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
  final InvoiceViewModel _invoiceViewModel = Get.find<InvoiceViewModel>();

  DateTime? selectedFromDate;
  DateTime? selectedToDate;

  double totalDraft = 0.0, totalSuccess = 0.0, totalSent = 0.0;
  double totalPendingApproval = 0.0, totalCompleted = 0.0;
  double totalFailed = 0.0, totalPending = 0.0, totalRetryPending = 0.0;
  double totalReplaced = 0.0;
  double totalInvoiceReportInDate = 0.0;

  List<InvoiceReport>? invoiceReports;
  final DateFormat formatter = DateFormat('dd/MM');
  Map<String?, double> chartData = {};
  List<MapEntry<String, InvoiceReport>> dateReportPairs = [];

  void setSelectedFromDate(DateTime? fromDate) {
    selectedFromDate = fromDate;
    if (selectedFromDate != null && selectedToDate == null) {
      return;
    } else {
      if (selectedToDate!.isBefore(selectedFromDate!)) {
        showMessageDialog(
            title: 'Thông báo',
            message: 'Ngày kết thúc không thể nhỏ hơn ngày bắt đầu');
      } else {
        getInvoicesDashboard();
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
        getInvoicesDashboard();
      }
    }
    notifyListeners();
  }

  void reset() {
    // maxInvoices = 0;
    // minInvoices = 0;
    // selectedFromDate = null;
    // selectedToDate = null;
    totalDraft = 0.0;
    totalSuccess = 0.0;
    totalSent = 0.0;
    totalPendingApproval = 0.0;
    totalCompleted = 0.0;
    totalFailed = 0.0;
    totalPending = 0.0;
    totalRetryPending = 0.0;
    totalReplaced = 0.0;
    totalInvoiceReportInDate = 0.0;
    notifyListeners();
  }

  Future<void> removeAll() async {
    selectedFromDate = null;
    selectedToDate = null;

    totalDraft = 0.0;
    totalSuccess = 0.0;
    totalSent = 0.0;
    totalPendingApproval = 0.0;
    totalCompleted = 0.0;
    totalFailed = 0.0;
    totalPending = 0.0;
    totalRetryPending = 0.0;
    totalReplaced = 0.0;
    totalInvoiceReportInDate = 0.0;

    invoiceReports = null;
    chartData.clear();
    dateReportPairs.clear();
  }

  Future<void> getInvoicesDashboard() async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));
      if (_accountViewModel.account?.role == 2) {
        invoiceReports = await OrganizationAPI().getOrganizationReportInvoices(
            selectedFromDate,
            selectedToDate,
            _invoiceViewModel.selectedStoreId);
      } else if (_accountViewModel.account?.role == 0) {
        invoiceReports = await BrandAPI().getBrandReportInvoices(
            selectedFromDate,
            selectedToDate,
            _invoiceViewModel.selectedOrganizationId);
      }
      chartData.clear();
      dateReportPairs.clear();
      reset();
      for (var report in invoiceReports!) {
        DateTime? reportDate = report.date;
        if (reportDate != null) {
          String formattedDate = formatter.format(reportDate);
          double totalDraftValue =
              report.totalInvoiceReportInDate?.toDouble() ?? 0.0;
          chartData[formattedDate] = totalDraftValue;
          dateReportPairs.add(MapEntry(formattedDate, report));
        }
      }
      getTotalInvoiceReportDetails(invoiceReports);
      setState(ViewStatus.Completed);
      notifyListeners();
    } catch (e) {
      setState(ViewStatus.Error, 'Failed to load invoice list');
    }
  }

  void getTotalInvoiceReportDetails(List<InvoiceReport>? invoiceDetail) {
    if (invoiceDetail == null || invoiceDetail.isEmpty) return;

    for (var report in invoiceDetail) {
      totalDraft += report.draft ?? 0;
      totalSuccess += report.success ?? 0;
      totalSent += report.sent ?? 0;
      totalPendingApproval += report.pendingApproval ?? 0;
      totalCompleted += report.completed ?? 0;
      totalFailed += report.failed ?? 0;
      totalPending += report.pending ?? 0;
      totalRetryPending += report.retryPending ?? 0;
      totalReplaced += report.replaced ?? 0;
      totalInvoiceReportInDate += report.totalInvoiceReportInDate ?? 0;
    }
  }
}
