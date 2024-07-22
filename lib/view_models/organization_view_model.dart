import 'package:get/get.dart';
import 'package:invoice/view_models/account_view_model.dart';
import 'package:invoice/view_models/base_view_model.dart';
import 'package:invoice/view_models/invoice_view_model.dart';
import 'package:invoice/widgets/other_dialogs/dialog.dart';

import '../api/brand_api.dart';
import '../api/organization_api.dart';
import '../enums/view_status.dart';
import '../models/invoice_dashboard.dart';
import '../models/organization.dart';
import '../models/store.dart';

class OrganizationViewModel extends BaseViewModel {
  late Store _store;
  Store? get store => _store;
  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
  final InvoiceViewModel _invoiceViewModel = Get.find<InvoiceViewModel>();
  List<Store>? storeList = [];
  List<String>? storeNames = [];
  InvoiceReport? invoiceReports;
  List<Organization>? organizationList = [];
  InvoicePaymentReport? invoicePaymentReport;

  Future<void> getStoreByOrganizationId() async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));
      if (_accountViewModel.account!.role == 2) {
        storeList = await OrganizationAPI().getStoreByOrganizationId();
        getStoreNames();
        if (storeList != null) {
          setState(ViewStatus.Completed);
          notifyListeners();
        } else {
          setState(ViewStatus.Error, 'Không có danh sách cửa hàng nào');
        }
      } else {
        showMessageDialog(
            title: 'Lỗi', message: 'Bạn không có quyền truy cập dữ liệu này');
      }
    } catch (e) {
      setState(ViewStatus.Error, 'Thất bại khi tải danh sách cửa hàng');
    }
  }

  //forBrand
  Future<void> getOrganizationListByBrandId() async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(const Duration(seconds: 1));
      if (_accountViewModel.account!.role == 0) {
        organizationList = await BrandAPI().getOrganizationListByBrandId();
        // getStoreNames();
        if (organizationList != null) {
          setState(ViewStatus.Completed);
          notifyListeners();
        } else {
          setState(ViewStatus.Error, 'Không có danh sách tổ chức nào');
        }
      } else {
        showMessageDialog(
            title: 'Lỗi', message: 'Bạn không có quyền truy cập dữ liệu này');
      }
    } catch (e) {
      setState(ViewStatus.Error, 'Tải danh sách tổ chức thất bại');
    }
  }

  // Future<void> getInvoiceReportByOrganization(
  //     {DateTime? fromDate,
  //     DateTime? toDate,
  //     String errorMessage = 'Thất bại khi tải báo cáo hóa đơn',
  //     Duration delay = const Duration(seconds: 1)}) async {
  //   try {
  //     setState(ViewStatus.Loading);
  //     await Future.delayed(delay);

  //     if (_accountViewModel.account?.role == 2) {
  //       invoiceReports = await OrganizationAPI().getInvoiceReportByOrganization(
  //           fromDate, toDate, _invoiceViewModel.selectedStoreId);
  //       if (invoiceReports != null) {
  //         setState(ViewStatus.Completed);
  //         notifyListeners();
  //       } else {
  //         setState(ViewStatus.Error, 'Báo cáo hóa đơn không tìm thấy');
  //       }
  //     } else if (_accountViewModel.account?.role == 0) {
  //       invoiceReports = await BrandAPI().getInvoiceReportByOrganization(
  //           fromDate, toDate, _invoiceViewModel.selectedOrganizationId);
  //       if (invoiceReports != null) {
  //         setState(ViewStatus.Completed);
  //         notifyListeners();
  //       } else {
  //         setState(ViewStatus.Error, 'Báo cáo hóa đơn không tìm thấy');
  //       }
  //     }
  //   } catch (e, stackTrace) {
  //     log('Error loading invoice report: $e', stackTrace: stackTrace);
  //     setState(ViewStatus.Error, errorMessage);
  //   }
  // }

  // Future<void> getInvoicePaymentReportByOrganization(
  //     {DateTime? fromDate,
  //     DateTime? toDate,
  //     String errorMessage = 'Thất bại khi tải báo cáo thanh toán hóa đơn',
  //     Duration delay = const Duration(seconds: 1)}) async {
  //   try {
  //     setState(ViewStatus.Loading);
  //     await Future.delayed(delay);
  //     if (_accountViewModel.account?.role == 2) {
  //       invoicePaymentReport = await OrganizationAPI()
  //           .getInvoiceReportPaymentChart(
  //               fromDate, toDate, _invoiceViewModel.selectedStoreId);
  //       if (invoicePaymentReport != null) {
  //         setState(ViewStatus.Completed);
  //         notifyListeners();
  //       } else {
  //         setState(
  //             ViewStatus.Error, 'Báo cáo thanh toán hóa đơn không tìm thấy');
  //       }
  //     } else {
  //       showMessageDialog(
  //           title: 'Lỗi', message: 'Bạn không có quyền truy cập dữ liệu này');
  //     }
  //   } catch (e, stackTrace) {
  //     log('Error loading invoice report: $e', stackTrace: stackTrace);
  //     setState(ViewStatus.Error, errorMessage);
  //   }
  // }

  List<String>? getStoreNames() {
    return storeList!.map((e) => e.name!).toList();
  }
}
