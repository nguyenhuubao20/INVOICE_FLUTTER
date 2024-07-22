import 'package:intl/intl.dart';
import 'package:invoice/utils/request.dart';
import 'package:invoice/utils/share_pref.dart';

import '../models/invoice_dashboard.dart';
import '../models/store.dart';

class OrganizationAPI {
  static int page = 1;
  static int size = 10;
  List<Store> stores = [];

  Future<List<Store>> getStoreByOrganizationId() async {
    try {
      String? organizationId = await getOrganizationId();
      var params = {
        'id': organizationId,
        'page': page,
        'size': size,
      };
      final res = await request.get('organizations/$organizationId/stores',
          queryParameters: params);
      if (res.statusCode == 200) {
        List<dynamic> jsonList = res.data['items'];
        List<Store> storesList =
            jsonList.map((json) => Store.fromJson(json)).toList();
        stores = storesList;
        return storesList;
      } else {
        throw Exception('Failed to load stores: ${res.statusCode}');
      }
    } catch (e) {
      print('Error during get stores: $e');
      return [];
    }
  }

  Future<List<InvoiceReport>> getOrganizationReportInvoices(
      DateTime? fromDate, DateTime? toDate, String? storeId) async {
    try {
      String? organizationId = await getOrganizationId();

      var params = {
        'id': organizationId,
      };

      if (storeId != null) {
        params['storeId'] = storeId;
      }

      if (fromDate != null) {
        params['fromDate'] = DateFormat('yyyy-MM-dd').format(fromDate);
      }

      if (toDate != null) {
        params['toDate'] = DateFormat('yyyy-MM-dd').format(toDate);
      }

      final res = await request.get(
        'organizations/$organizationId/invoice-report-in-date',
        queryParameters: params,
      );

      if (res.statusCode == 200) {
        Map<String, dynamic> data = res.data;
        List<dynamic> jsonList = data['items'];
        List<InvoiceReport> reports =
            jsonList.map((item) => InvoiceReport.fromJson(item)).toList();
        return reports;
      } else {
        throw Exception('Failed to load invoice report: ${res.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error during getting invoice report: $e');
      return [];
    }
  }

  Future<List<InvoicePaymentReport>> getOrganizationReportRevenue(
    DateTime? fromDate,
    DateTime? toDate,
    String? storeId,
  ) async {
    try {
      String? organizationId = await getOrganizationId();
      var params = {
        'id': organizationId,
      };

      if (storeId != null) {
        params['storeId'] = storeId;
      }

      if (fromDate != null) {
        params['fromDate'] = DateFormat('yyyy-MM-dd').format(fromDate);
      }

      if (toDate != null) {
        params['toDate'] = DateFormat('yyyy-MM-dd').format(toDate);
      }

      final res = await request.get(
        'organizations/$organizationId/invoice-payment-report-in-date',
        queryParameters: params,
      );

      if (res.statusCode == 200) {
        Map<String, dynamic> data = res.data;
        List<dynamic> jsonList = data['items'];
        List<InvoicePaymentReport> reports = jsonList
            .map((item) => InvoicePaymentReport.fromJson(item))
            .toList();
        return reports;
      } else {
        throw Exception('Failed to load invoice report: ${res.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Exception: $e');
      return [];
    }
  }
}
