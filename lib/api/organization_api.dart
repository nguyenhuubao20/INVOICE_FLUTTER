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

  Future<InvoiceReport?> getInvoiceReportByOrganization(
      DateTime? fromDate, DateTime? toDate) async {
    try {
      String? organizationId = await getOrganizationId();

      var params = {
        'id': organizationId,
      };

      if (fromDate != null) {
        params['fromDate'] = DateFormat('yyyy-MM-dd').format(fromDate);
      }

      if (toDate != null) {
        params['toDate'] = DateFormat('yyyy-MM-dd').format(toDate);
      }

      final res = await request.get(
        'organizations/$organizationId/invoice-report',
        queryParameters: params,
      );

      if (res.statusCode == 200) {
        InvoiceReport invoiceReport = InvoiceReport.fromJson(res.data);
        return invoiceReport;
      } else {
        throw Exception('Failed to load invoice report: ${res.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error during getting invoice report: $e');
      return null;
    }
  }

  Future<InvoicePaymentReport?> getInvoiceReportPaymentByOrganization(
      DateTime? fromDate, DateTime? toDate) async {
    try {
      String? organizationId = await getOrganizationId();
      var params = {
        'id': organizationId,
      };

      if (fromDate != null) {
        params['fromDate'] = DateFormat('yyyy-MM-dd').format(fromDate);
      }

      if (toDate != null) {
        params['toDate'] = DateFormat('yyyy-MM-dd').format(toDate);
      }

      final res = await request.get(
        'organizations/$organizationId/invoice-payment-report',
        queryParameters: params,
      );

      if (res.statusCode == 200) {
        return InvoicePaymentReport.fromJson(res.data);
      } else {
        throw Exception('Failed to load invoice report: ${res.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error during getting invoice report: $e');
      print(stackTrace);
      return null;
    }
  }
}
