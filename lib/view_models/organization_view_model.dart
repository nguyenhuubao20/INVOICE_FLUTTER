import 'dart:developer';

import 'package:get/get.dart';
import 'package:invoice/models/invoice.dart';
import 'package:invoice/view_models/account_view_model.dart';
import 'package:invoice/view_models/base_view_model.dart';
import 'package:invoice/widgets/other_dialogs/dialog.dart';

import '../api/organization_api.dart';
import '../enums/view_status.dart';
import '../models/store.dart';

class OrganizationViewModel extends BaseViewModel {
  late Store _store;
  Store? get store => _store;
  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
  List<Store>? storeList = [];
  List<String>? storeNames = [];
  InvoiceReport? invoiceReports;
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
          setState(ViewStatus.Error, 'Invoice list not found');
        }
      } else {
        // showAlertDialog(
        //     title: 'Error', content: 'You have no access to load store list');
      }
    } catch (e) {
      setState(ViewStatus.Error, 'Failed to load invoice list');
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
        invoiceReports = await OrganizationAPI()
            .getInvoiceReportByOrganization(fromDate, toDate);
        if (invoiceReports != null) {
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

  Future<void> getInvoicePaymentReportByOrganization(
      {DateTime? fromDate,
      DateTime? toDate,
      String errorMessage = 'Failed to load payment report',
      Duration delay = const Duration(seconds: 1)}) async {
    try {
      setState(ViewStatus.Loading);
      await Future.delayed(delay);
      if (_accountViewModel.account?.role == 2) {
        invoicePaymentReport = await OrganizationAPI()
            .getInvoiceReportPaymentByOrganization(fromDate, toDate);
        if (invoicePaymentReport != null) {
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

  List<String>? getStoreNames() {
    return storeList!.map((e) => e.name!).toList();
  }
}
